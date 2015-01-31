package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.system.Security;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	
	
	public class Main extends MovieClip {
		
		public static var DEBUG_TRACE:Boolean = true;
		public static var rt:Main;
		
		// ---------------------------------------------------------------
		
		public static var CONFIG_W:Number = 650;
		public static var CONFIG_H:Number = 350;
		
		
		public static var CONFIG_XML:String = "app.xml";
		
		// ค่าที่อ่านได้จาก config file
		public static var CONFIG_AUTH:String;
		public static var CONFIG_SERVER_URL:String;
		public static var CONFIG_STEP_QUERY:Number;
		public static var CONFIG_STEP_REFRESH_UI:Number;
		
		public static var CONFIG_KEY_SCORE_PLUS_A:String;
		public static var CONFIG_KEY_SCORE_PLUS_B:String;
		public static var CONFIG_KEY_SCORE_MINUS_A:String;
		public static var CONFIG_KEY_SCORE_MINUS_B:String;
		public static var CONFIG_KEY_SCORE_RESET:String;
		
		public static var CONFIG_KEY_TIME_START_STOP:String;
		public static var CONFIG_KEY_TIME_FORWARD_MODE:String;
		public static var CONFIG_KEY_TIME_FORWARD_RESET:String;
		public static var CONFIG_KEY_TIME_COUNTDOWN_MODE:String;
		public static var CONFIG_KEY_TIME_COUNTDOWN_PLUS:String;
		public static var CONFIG_KEY_TIME_COUNTDOWN_MINUS:String;
		
		public static var CONFIG_TIMER_COUNTDOWN_MODE_DEFAULT_PERIOD:Number;
		public static var CONFIG_TIMER_COUNTDONW_MODE_STEP:Number;
		// ---------------------------------------------------------------

		private var clockIntervalID:uint;
		
		// นับ step ละ 1s
		private var stepIntervalID:uint;
		private var stepCnt:Number;
		
		// ---------------------------------------------------------------
		
		private static var cacheA:Number;
		private static var cacheB:Number;
			
		// forward, countdown
		private static var cacheTimerMode:String;
		// start, stop
		private static var cacheTimerState:String;
		
		private static var cacheCountForward:Number;
		private static var cacheCountCountdown:Number;
		
		// ---------------------------------------------------------------		
		
		public function Main() {
			
			// เก็บ global reference
			Main.rt 					= this;
			this.stepCnt 				= 0; 
			this.modalPanel.visible 	= false;
			
			this.clearUI();
		
			try{
				this.stage.scaleMode 	= StageScaleMode.EXACT_FIT;
				this.stage.align 		= StageAlign.TOP;
				Security.exactSettings 	= false;
			}catch(err:Error){}
			
			// -------------------------------------------------------------------
			// -------------------------------------------------------------------
			// อ่านค่า config
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event) {
				
				// อ่านค่า config.xml เรียบร้อยแล้ว
				var responseXML:XML = new XML(e.target.data);
				
				var config:XML = responseXML;
				if(config.auth.length() < 1
					|| config.keyScorePlusA.length() < 1
					|| config.keyScorePlusB.length() < 1
					|| config.keyScoreMinusA.length() < 1
					|| config.keyScoreMinusB.length() < 1
					|| config.keyScoreReset.length() < 1
					|| config.keyTimeStartStop.length() < 1
					|| config.keyTimeForwardMode.length() < 1
					|| config.keyTimeForwardReset.length() < 1
					|| config.keyTimeCountdownMode.length() < 1
					|| config.keyTimeCountdownPlus.length() < 1
					|| config.keyTimeCountdownMinus.length() < 1
					|| config.timerDefaultMode.length() < 1
					|| config.timerCountdownModeDefaultPeriod.length() < 1
					|| config.timerCountdownModeStep.length() < 1
				){
					failedOnLoadConfig();
					return;
				}
				Main.CONFIG_AUTH 						= config.auth;
				Main.CONFIG_SERVER_URL 					= config.serverURL;
				Main.CONFIG_STEP_QUERY 					= Utils.parse(config.stepQuery);
				Main.CONFIG_STEP_REFRESH_UI 			= Utils.parse(config.stepRefreshUI);
				
				Main.CONFIG_KEY_SCORE_PLUS_A 			= config.keyScorePlusA;
				Main.CONFIG_KEY_SCORE_PLUS_B 			= config.keyScorePlusB;
				Main.CONFIG_KEY_SCORE_MINUS_A 			= config.keyScoreMinusA;
				Main.CONFIG_KEY_SCORE_MINUS_B 			= config.keyScoreMinusB;
				Main.CONFIG_KEY_SCORE_RESET 			= config.keyScoreReset;
				
				Main.CONFIG_KEY_TIME_START_STOP 		= config.keyTimeStartStop;
				Main.CONFIG_KEY_TIME_FORWARD_MODE 		= config.keyTimeForwardMode;
				Main.CONFIG_KEY_TIME_FORWARD_RESET 		= config.keyTimeForwardReset;
				Main.CONFIG_KEY_TIME_COUNTDOWN_MODE 	= config.keyTimeCountdownMode;
				Main.CONFIG_KEY_TIME_COUNTDOWN_PLUS 	= config.keyTimeCountdownPlus;
				Main.CONFIG_KEY_TIME_COUNTDOWN_MINUS 	= config.keyTimeCountdownMinus;
				
				if(config.timerDefaultMode.toString() == "countdown"){
					Main.cacheTimerMode = "countdown";
				}else{
					Main.cacheTimerMode = "forward";
				}
				Main.CONFIG_TIMER_COUNTDOWN_MODE_DEFAULT_PERIOD = Utils.parse(config.timerCountdownModeDefaultPeriod);
				Main.CONFIG_TIMER_COUNTDONW_MODE_STEP = Utils.parse(config.timerCountdownModeStep);				
				
				Main.rt.stepIntervalID = setInterval(function(){
					
					Main.rt.updateTimerUI();
					
				}, 1000);
				
				// นาฬิกา 
			 	Main.rt.clockIntervalID = setInterval(function(){ updateClockUI();}, (60 * 1000));
				
				Main.rt.clearUI();
				
				trace("--------------------------------");
				trace("LOADED - config file");
				trace("--------------------------------");
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event) {
										   
				// อ่านค่า config.xml ไม่สำเร็จ (ปิดโปรแกรม)
				var responseXML:XML = new XML(e.target.data);
				trace("--------------------------------");
				trace("FAILED - config file");
				trace("--------------------------------");
				failedOnLoadConfig();
			});
			loader.load(new URLRequest("./" + Main.CONFIG_XML));
			
			try { stage.displayState=StageDisplayState.FULL_SCREEN; }catch(err:Error){}
			
			// -------------------------------------------------------------------
			// -------------------------------------------------------------------
			function onKeyDown(ev:KeyboardEvent):void{ 
				
				trace("Key Pressed: " + String.fromCharCode(ev.charCode) +         " (character code: " + ev.charCode + ")"); 

				var key:String = String.fromCharCode(ev.charCode);
				
				if(key == Main.CONFIG_KEY_SCORE_PLUS_A){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] plus A");
					Main.cacheA++;
					updateScoreUI();
					
				}else if(key == Main.CONFIG_KEY_SCORE_MINUS_A){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] minus A");
					if(Main.cacheA > 0) Main.cacheA--;
					updateScoreUI();
					
				}else if(key == Main.CONFIG_KEY_SCORE_PLUS_B){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] plus B");
					Main.cacheB++;
					updateScoreUI();
					
				}else if(key == Main.CONFIG_KEY_SCORE_MINUS_B){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] plus B");
					if(Main.cacheB > 0) Main.cacheB--;
					updateScoreUI();
					
				}else if(key == Main.CONFIG_KEY_SCORE_RESET){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] clear score");
					clearScore();
					
				}else if(key == Main.CONFIG_KEY_TIME_START_STOP){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] start/stop");
					
					if(Main.cacheTimerState == "stop"){
						
						Main.cacheTimerState = "start";
					}else{
					
						Main.cacheTimerState = "stop";
					}
					
				}else if(key == Main.CONFIG_KEY_TIME_FORWARD_MODE){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] forward mode");
					
					// เปลี่ยน mode การแสดงผลและหยุด ไม่ reset
					if(Main.cacheTimerMode != "forward"){
						Main.cacheTimerState = "stop";
						Main.cacheTimerMode = "forward";
						updateTimerUI();
					}
					
				}else if(key == Main.CONFIG_KEY_TIME_COUNTDOWN_MODE){
					
					if(Main.DEBUG_TRACE) trace("[BUTTON] countdown mode");
					
					// เปลี่ยน mode การแสดงผลและหยุด ไม่ reset
					if(Main.cacheTimerMode != "countdown"){
						Main.cacheTimerState = "stop";
						Main.cacheTimerMode = "countdown";
						updateTimerUI();
					}
					
				}else if(key == Main.CONFIG_KEY_TIME_COUNTDOWN_PLUS){
					
					if(Main.cacheTimerMode == "countdown" && Main.cacheTimerState == "stop"){
						
						Main.cacheCountCountdown += Main.CONFIG_TIMER_COUNTDONW_MODE_STEP;
						updateTimerUI();
					}
				}else if(key == Main.CONFIG_KEY_TIME_COUNTDOWN_MINUS){
					
					if(Main.cacheTimerMode == "countdown" && Main.cacheTimerState == "stop"){
						
						if(Main.cacheCountCountdown >= Main.CONFIG_TIMER_COUNTDONW_MODE_STEP) {
							Main.cacheCountCountdown -= Main.CONFIG_TIMER_COUNTDONW_MODE_STEP;
						}else{
							Main.cacheCountCountdown = 0;
						}
						updateTimerUI();
					}
				}
				
			} 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			
			this.hiddenToggleButton.addEventListener(MouseEvent.CLICK, function(e:Event) {
				try { 
					if (stage.displayState == StageDisplayState.NORMAL) {
						stage.displayState=StageDisplayState.FULL_SCREEN;
					} else {
						stage.displayState=StageDisplayState.NORMAL;
					}
				}catch(err:Error){}
			});
			
		}
		
		// -------------------------------------------------------------------
		// UI
		// -------------------------------------------------------------------

		// อัพเดทนาฬิกา
		private function updateClockUI():void{
			
			// นาฬิกา
			if (getChildByName("clock") != null){ 
				((this["clock"] as MovieClip).clockLabel as TextField).text = Utils.timeString();
			}
			// วันที่
			if (getChildByName("dateLabel") != null) this["dateLabel"].text = Utils.thaiDateString();
		}
		
		private function updateScoreUI():void{
			
			(Main.rt["scoreA_1"] as NumberPanel).setN(Math.floor(Main.cacheA / 10));
			(Main.rt["scoreA_0"] as NumberPanel).setN(Main.cacheA % 10);
			
			(Main.rt["scoreB_1"] as NumberPanel).setN(Math.floor(Main.cacheB / 10));
			(Main.rt["scoreB_0"] as NumberPanel).setN(Main.cacheB % 10);
		}
		
		// แสดงเวลาจากค่าใน cache
		// อัพเดทโดย interval กับ clear timer เท่านั้น
		private function updateTimerUI():void{
			
			//trace(Main.cacheTimerState , Main.cacheTimerMode, Main.cacheTimer );
			// ---------------------------------------------------
			var tmpTimer:Number;
			
			if(Main.cacheTimerMode == "countdown"){
				
				if(Main.cacheTimerState != "stop"){
					
					if(Main.cacheCountCountdown > 0) Main.cacheCountCountdown--;
				}
				tmpTimer = Main.cacheCountCountdown;
				
			}else{
				
				if(Main.cacheTimerState != "stop"){
					
					Main.cacheCountForward++;
				}
				tmpTimer = Main.cacheCountForward;
			}
			
			trace("tmpTimer",tmpTimer);
			// ---------------------------------------------------
			// อัพเดท UI
			var min:Number = Math.floor(tmpTimer / 60);
			if(min > 99) min = 99;
			var sec:Number = Math.floor(tmpTimer % 60);
			
			(Main.rt["timer"] as FieldTimer).setTimer(min,sec);
			// ---------------------------------------------------
		}
		
		private function clearUI():void{
			
			clearScore();
			clearTimer();
		}
		private function clearScore():void{
			Main.cacheA = 0;
			Main.cacheB = 0;
			updateScoreUI();
		}
		private function clearTimer():void{
			
			Main.cacheTimerState = "stop";
			Main.cacheCountForward = 0;
			Main.cacheCountCountdown = Main.CONFIG_TIMER_COUNTDOWN_MODE_DEFAULT_PERIOD;
			
			updateTimerUI();
		}
		
		// -------------------------------------------------------------------
		// Event Handler
		// -------------------------------------------------------------------
		
		// โหลด config ไม่สำเร็จ บังคับ refresh ข้อมูล
		private function failedOnLoadConfig():void{
			
			var msg: ModalDialog = new ModalDialog("เกิดข้อผิดพลาดในการอ่านค่า "+ Main.CONFIG_XML +" \n กรุณาลองเปิดโปรแกรมใหม่อีกครั้ง");
			(new DialogManager(msg)).showDialog();
		}
		
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
	}
}

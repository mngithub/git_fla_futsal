package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import fl.transitions.Tween;
	import flash.events.Event;
	
	
	public class MaqueeText extends MovieClip {
		
		var cnt:Number;
	 	static var SPEED:Number 		= 2;
	 	static var WAIT_START:Number 	= 50;
	 	static var WAIT_END:Number 		= 50;
		
		// start
		// tween
		// end
	 	var mqState:String;
		var mqCnt:Number;
		var lastText:String;
		
		public function MaqueeText() {
			// constructor code
			(this.txt as TextField).autoSize = TextFieldAutoSize.LEFT;
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			this.cnt = 0;
			this.dot.visible = false;
			this.goToState("start");
			
		}
		public function setText(txt:String):void{
			
			//trace(this.lastText,"::::" , txt);
			
			if((this.lastText) == txt) return;
			(this.txt as TextField).text = txt;
			this.lastText = txt;
			this.dot.visible = false;
			this.goToState("start");
		}
		private function onEnter(e:Event):void{
			
			if(cnt % 2 == 0){
				
				// execute
				var isMaquee:Boolean = false;
				if(this.txt.width > (this.maskLayer.width)) isMaquee = true;

				if(!isMaquee){
					// เลื่อนกลับมาตำแหน่งแรก
					this.goToState("start");
					this.dot.visible = false;
					
				}else{
					
					if(this.mqState == "start"){
						this.mqCnt++;
						if(this.mqCnt >= WAIT_START){
							this.goToState("tween");
						}
					}else if(this.mqState == "tween"){
						
						(this.txt as TextField).x -= SPEED;
						if(this.txt.width + this.txt.x  <=  (this.maskLayer.width)){
							this.goToState("end");
						}
					}else{
						this.mqCnt++;
						if(this.mqCnt >= WAIT_END){ this.goToState("start"); }
					}
				}
				cnt = 0;
			}
			cnt++;
		}
		private function goToState(st:String):void{
			
			//trace("goToState", st);
			
			if(st == "start"){
				// เลื่อนกลับมาตำแหน่งแรก
				(this.txt as TextField).x = 0;
				this.mqState = "start";
				this.mqCnt = 0;
				this.dot.visible = true;
			}else if(st == "tween"){
				this.mqState = "tween";
				this.mqCnt = 0;
				this.dot.visible = true;
			}else if(st == "end"){
				this.mqState = "end";
				this.mqCnt = 0;
				this.dot.visible = false;
			}
		}
	}
}

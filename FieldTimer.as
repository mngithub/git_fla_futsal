package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class FieldTimer extends MovieClip {
		
		
		public function FieldTimer() {
			// constructor code
		}
		
		public function setTimer(min:Number, sec:Number):void{
			
			var tmpMin:String;
			var tmpSec:String;
			
			if(min < 10) tmpMin = "0" + min.toString(); 
			else tmpMin = min.toString();
			
			if(sec < 10) tmpSec = "0" + sec.toString(); 
			else tmpSec = sec.toString();
			
			(this.timeLabel as TextField).text = tmpMin + ":" + tmpSec;
				
		}
	}
	
}

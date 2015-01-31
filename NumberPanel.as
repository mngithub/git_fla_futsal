package  {
	
	import flash.display.MovieClip;
	
	
	public class NumberPanel extends MovieClip {
		
		
		public function NumberPanel() {
			// constructor code
			setN(0);
		}
		
		public function setN(n:Number):void{
				
			if(n == 0) gotoAndStop("n0");
			else if(n == 1) gotoAndStop("n1");
			else if(n == 2) gotoAndStop("n2");
			else if(n == 3) gotoAndStop("n3");
			else if(n == 4) gotoAndStop("n4");
			else if(n == 5) gotoAndStop("n5");
			else if(n == 6) gotoAndStop("n6");
			else if(n == 7) gotoAndStop("n7");
			else if(n == 8) gotoAndStop("n8");
			else if(n == 9) gotoAndStop("n9");
			else gotoAndStop("n0");
		}
		public function setS(n:String):void{
				
			if(n == "0") gotoAndStop("n0");
			else if(n == "1") gotoAndStop("n1");
			else if(n == "2") gotoAndStop("n2");
			else if(n == "3") gotoAndStop("n3");
			else if(n == "4") gotoAndStop("n4");
			else if(n == "5") gotoAndStop("n5");
			else if(n == "6") gotoAndStop("n6");
			else if(n == "7") gotoAndStop("n7");
			else if(n == "8") gotoAndStop("n8");
			else if(n == "9") gotoAndStop("n9");
			else gotoAndStop("n0");
		}
	}
	
}

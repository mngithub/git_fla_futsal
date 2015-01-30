package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MessageDialog extends Dialog {
		
		
		public function MessageDialog(txt:String= "") {
			// constructor code
			(this.txt).text = txt;
			this.btn.addEventListener(MouseEvent.CLICK, onClickBtn);
		}
		
		public function onClickBtn(e:MouseEvent):void
		{
			this.dm.closeDialog();
		}
	}
}

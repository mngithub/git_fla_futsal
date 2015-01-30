package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.SimpleButton;

	public class DialogManager extends MovieClip
	{
		public var dialog:Dialog;
		
		private static var dialogLayerArray = new Array();
	
		public function DialogManager(dialog:Dialog)
		{
			this.setDialog(dialog);
		}
		
		public function setDialog(dialog:Dialog):void
		{
			if (dialog != null)
			{
				this.dialog = dialog;
				this.dialog.dm = this;
				// วาง dialog ลงไปใน modal screen
				this.attachDialog();
			}
		}
		// วาง dialog ลงไปใน modal screen
		private function attachDialog():void
		{
			if(this.dialog == null) return;
			this.addChild(this.dialog);
			
			// dialog ตรงกลาง screen
			this.dialog.x = Main.rt.width / 2;
			this.dialog.y = Main.rt.height / 2 - 40;
		}
		// ปิด dialog
		public function closeDialog():void
		{
			if(this.dialog != null && this.contains(dialog))
			{ 
				// บางกรณีการลบจะปิด 2 step คือ ปิด dialog ก่อนแล้วค่อยปิด modal
				this.removeChild(this.dialog);
			}
			var i;
			
			if (Main.rt.dialogPanel.contains(this))
			{
				// ลบค่าออกจาก array
				for (i=0; i<dialogLayerArray.length; i++)
				{
					if(dialogLayerArray[i] == this)
					{
						dialogLayerArray.splice(i, 1);
						break;
					}
				}
				Main.rt.dialogPanel.removeChild(this);
			}
			Main.rt.modalPanel.visible = (dialogLayerArray.length > 0);
		}
		
		public static function clearDialog():void{
			Utils.emptySlot(Main.rt.dialogPanel,false);
			Main.rt.modalPanel.visible = false;
		}
		
		// เปิด modal screen กับ dialog หรือเปิด modal screen อย่างเดียว
		public function showDialog()
		{
			
			if (!Main.rt.dialogPanel.contains(this))
			{
				Main.rt.dialogPanel.addChild(this);
				// เก็บค่าลง array 
				dialogLayerArray[dialogLayerArray.length] = this;
			}
			// ถ้ามีการ resize windows ตำแหน่งของ dm จะเปลี่ยน
			this.x = 0;
			this.y = 0;
			
			Main.rt.modalPanel.x = 0;
			Main.rt.modalPanel.y = 0;
			Main.rt.modalPanel.width = Main.rt.width;
			Main.rt.modalPanel.height = Main.rt.height;
			Main.rt.modalPanel.visible = true;
			Main.rt.dialogPanel.setChildIndex(this,Main.rt.dialogPanel.numChildren -1);
			
			//trace( Main.rt.width,Main.rt.height, stage.height);
			
		}
	}
}
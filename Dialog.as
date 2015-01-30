package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Dialog extends MovieClip
	{
		public var dm:DialogManager;

		public function Dialog()
		{
			stop();
		}
		protected function closeDialog(e:Event)
		{
			this.dm.closeDialog();
		}
	}
}
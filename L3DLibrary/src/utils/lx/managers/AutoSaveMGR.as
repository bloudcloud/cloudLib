package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AutoSaveMGR
	{
		public static const AutoSave:String = "AutoSave";
		public static const Close:String = "AutoSaveClose";
//		private var time:Timer = new Timer(1000*60*0.5);
		private var time:Timer = new Timer(1000*60*30);
//		private var time:Timer = new Timer(1000*30);
		private var isOpen:Boolean;
		public function AutoSaveMGR()
		{
			time.addEventListener(TimerEvent.TIMER,timerHandler);
			time.start();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			if(!isOpen)
			{
				isOpen = true;
				GlobalManager.Instance.dispatchEvent(new Event(AutoSave));
				GlobalManager.Instance.addEventListener(Close,closeHandler);
			}
		}
		
		private function closeHandler(event:Event):void
		{
			isOpen = false;
		}
	}
}
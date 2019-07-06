package L3DCAD
{
	import flash.events.Event;

	public class L3DProcessingEvent extends Event
	{
		public static const PROCESSING:String = "LoadCADProcessing";
		private var percent:int = 0;
		
		public function L3DProcessingEvent(percent:int)
		{
			super(PROCESSING);
			this.percent = percent;
		}
		
		public function get Percent():int
		{
			return percent;
		}
		
		public function set Percent(v:int):void
		{
			percent = v;
		}
	}
}
package core.events
{
	import flash.events.Event;

	/**
	 * 带参数的事件
	 * @author lx
	 */
	public class DatasEvent extends Event
	{
		private var _data:*;
		
		public function get data():*
		{
			return _data;
		}

 		public function DatasEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=data;
			super(type, bubbles, cancelable);
 		}

		override public function clone():Event
		{
			return new DatasEvent(this.type,_data, this.bubbles, this.cancelable);
		}
	}
}


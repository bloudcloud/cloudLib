package cloud.core.event
{
	import flash.events.Event;
	
	/**
	 * 数据事件类
	 * @author cloud
	 */
	public class CDataEvent extends Event
	{
		private var _data:*;
		
		public function get data():*
		{
			return _data;
		}
		
		public function CDataEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CDataEvent(type,data,bubbles,cancelable);
		}
	}
}
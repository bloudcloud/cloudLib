package happyECS.ecs.events
{
	import flash.events.Event;
	
	/**
	 * ECS事件类，用于HAPPY引擎里的ECS之间的消息通知
	 * @author cloud
	 * @2018-3-23
	 */
	public class ECSEvent extends Event
	{
		private var _data:*;

		public function get data():*
		{
			return _data;
		}
		public function ECSEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ECSEvent(this.type,_data,this.bubbles,this.cancelable);
		}
	}
}
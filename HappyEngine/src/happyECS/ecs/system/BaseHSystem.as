package happyECS.ecs.system
{
	import flash.events.EventDispatcher;
	
	import happyECS.ecs.component.IHComponent;

	/**
	 * 基础系统类
	 * @author cloud
	 * @2018-3-9
	 */
	public class BaseHSystem extends EventDispatcher implements IHSystem
	{
		public function BaseHSystem()
		{
			super();
		}
		
		public function update(timeStep:uint):void
		{
		}
		
		public function notifyComponent(component:IHComponent):void
		{
		}
	}
}
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
		private var _clsName:String;
		
		public function BaseHSystem(clsRefName:String="BaseHSystem")
		{
			_clsName=clsRefName;
		}
		
		public function update(timeStep:uint):void
		{
		}
		
		public function notifyComponent(component:IHComponent):void
		{
		}
	}
}
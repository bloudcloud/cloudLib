package happyECS.ecs.system
{
	import happyECS.ecs.component.IHComponent;

	/**
	 * 系统接口
	 * @author cloud
	 * @2018-3-9
	 */
	public interface IHSystem
	{
		/**
		 * 更新 
		 * @param timeStep	执行时间
		 * 
		 */		
		function update(timeStep:uint):void;
		/**
		 * 发送消息 
		 * @param component
		 * 
		 */		
		function notifyComponent(component:IHComponent):void;
	}
}
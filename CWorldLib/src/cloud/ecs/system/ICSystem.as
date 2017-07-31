package cloud.ecs.system
{
	import cloud.ecs.component.ICComponent;

	/**
	 * 系统接口
	 * @author cloud
	 * @2017-6-28
	 */
	public interface ICSystem
	{
		/**
		 * 根据当前运行时间,执行系统更新操作
		 * @param timeStep
		 * 
		 */		
		function update(timeStep:Number):void;
		/**
		 * 为所有系统中所有组件发送消息 
		 * @param components
		 * 
		 */		
		function notifyComponents(components:Vector.<ICComponent>):void;
	}
}
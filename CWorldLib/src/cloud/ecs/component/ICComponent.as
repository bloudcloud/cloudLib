package cloud.ecs.component
{
	/**
	 * 组件接口
	 * @author cloud
	 * @2017-6-28
	 */
	public interface ICComponent
	{
		/**
		 * 初始化组件 
		 * 
		 */		
		function initialize():void;
		/**
		 * 销毁组件 
		 * 
		 */		
		function dispose():void;
	}
}
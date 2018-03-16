package happyECS.ecs.entity
{
	import happyECS.ecs.component.IHComponent;

	/**
	 * 实体接口
	 * @author cloud
	 * @2018-3-8
	 */
	public interface IHEntity
	{
		/**
		 * 获取实体ID 
		 * @return uint
		 * 
		 */		
		function get entityID():String;
		/**
		 * 添加组件 
		 * @param name
		 * @param component
		 * 
		 */		
		function addComponent(name:String,component:IHComponent):void;
		/**
		 * 移除组件 
		 * @param name
		 * 
		 */		
		function removeComponent(name:String):void;
		/**
		 * 添加动态属性 
		 * @param name
		 * @param value
		 * 
		 */		
		function addProperty(name:String,value:*):void;
		/**
		 * 获取动态属性 
		 * @param name
		 * @return *
		 * 
		 */		
		function getProperty(name:String):*;
		/**
		 *	销毁 
		 * 
		 */		
		function dispose():void;
	}
}
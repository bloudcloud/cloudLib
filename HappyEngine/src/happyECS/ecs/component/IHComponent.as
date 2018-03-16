package happyECS.ecs.component
{
	import happyECS.ecs.entity.IHEntity;

	/**
	 * 组件接口
	 * @author cloud
	 * @2018-3-8
	 */
	public interface IHComponent
	{
		/**
		 * 获取拥有者（实体）对象 
		 * @return IHEntity
		 * 
		 */		
		function get owner():IHEntity;
		/**
		 * 设置拥有者（实体）对象 
		 * @param ref	实体对象的引用
		 * 
		 */		
		function set owner(ref:IHEntity):void;
		/**
		 * 创建 
		 * @param resource	资源对象
		 * 
		 */		
		function create(resource:*):void;
		/**
		 * 销毁 
		 * 
		 */		
		function dispose():void;
	}
}
package happyECS.module
{
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.entity.IHEntity;
	import happyECS.ecs.system.IHSystem;
	import happyECS.resources.pool.ICPool;

	/**
	 * 模块接口
	 * @author cloud
	 * @2018-3-9
	 */
	public interface IHModule
	{
		/**
		 * 获取模块是否已安装 
		 * @return Boolean
		 * 
		 */		
		function get isInstalled():Boolean;
		/**
		 * 设置模块相关的系统容器
		 * @param value
		 * 
		 */		
		function set systems(value:Vector.<IHSystem>):void;  
		/**
		 * 设置模块相关的实体容器
		 * @param value
		 * 
		 */		
		function set entities(value:Vector.<IHEntity>):void;
		/**
		 * 设置模块相关缓冲池容器 
		 * @param value
		 * 
		 */		
		function set pools(value:Vector.<ICPool>):void;
		/**
		 * 设置模块相关组件容器 
		 * @param value
		 * 
		 */		
		function set components(value:Vector.<IHComponent>):void;
		/**
		 * 安装 
		 * 
		 */		
		function install():void;
		/**
		 * 卸载 
		 * 
		 */		
		function uninstall():void;
	}
}
package cloud.ecs
{
	import cloud.core.data.map.CHashMap;
	import cloud.ecs.component.ICComponent;
	import cloud.ecs.system.ICSystem;

	/**
	 * ECS世界接口
	 * @author cloud
	 * @2017-6-28
	 */
	public interface ICWorld
	{
		/**
		 * 获取所有系统
		 * @return Vector.<ICSystem>
		 * 
		 */		
		function get systems():Vector.<ICSystem>;
		/**
		 * 获取实体哈希表 
		 * @return CHashMap
		 * 
		 */		
		function get entities():CHashMap;
		/**
		 * 获取所有组件 
		 * @return Vector.<ICComponent>
		 * 
		 */		
		function get components():Vector.<ICComponent>;
		
	}
}
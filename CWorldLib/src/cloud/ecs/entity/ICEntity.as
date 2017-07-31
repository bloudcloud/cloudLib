package cloud.ecs.entity
{
	import cloud.ecs.component.ICComponent;

	/**
	 * 实体接口
	 * @author cloud
	 * @2017-6-28
	 */
	public interface ICEntity
	{
		/**
		 * 获取实体唯一ID 
		 * @return String
		 * 
		 */		
		function get entityID():String;
		/**
		 * 获取组件集合 
		 * @return Vector.<ICComponent>
		 * 
		 */		
		function get components():Vector.<ICComponent>;
		/**
		 * 获取显示资源对象
		 * @return *
		 * 
		 */		
		function get resourceAsset():*;
	}
}
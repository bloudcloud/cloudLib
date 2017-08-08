package cloud.core.interfaces
{
	/**
	 * 数据模型接口
	 * @author cloud
	 */
	public interface ICDataModel
	{
		/**
		 * 添加共享数据 
		 * @param data
		 * 
		 */		
		function addShareData(data:ICData):void;
		/**
		 * 添加缓存数据
		 * @param data
		 * 
		 */		
		function addCacheData(data:ICData):void;
		/**
		 * 移除缓存数据 
		 * @param data
		 * 
		 */		
		function removeCacheData(data:ICData):void;
		/**
		 * 移除同一个类型的共享数据 
		 * @param type
		 * 
		 */		
		function removeShareDataByType(type:uint):void;
		/**
		 * 清除所有存储数据 
		 * 
		 */		
		function clearAll():void;
		/**
		 * 清理所有共享数据 
		 * 
		 */		
		function clearAllShareData():void
		/**
		 * 清理所有缓存数据 
		 * 
		 */		
		function clearAllCache():void;
	}
}
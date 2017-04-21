package cloud.core.interfaces
{
	/**
	 * 数据模型接口
	 * @author cloud
	 */
	public interface ICDataModel
	{
		/**
		 * 添加数据
		 * @param data
		 * 
		 */		
		function addCacheData(data:ICData):void;
		/**
		 * 移除数据 
		 * @param data
		 * 
		 */		
		function removeCacheData(data:ICData):void;
		/**
		 * 清除所有存储数据 
		 * 
		 */		
		function clearAll():void;
	}
}
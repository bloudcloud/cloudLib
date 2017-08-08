package cloud.core.model
{
	import flash.events.EventDispatcher;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICDataModel;
	import cloud.core.singleton.CDataManager;
	
	import ns.cloudLib;
	
	use namespace cloudLib;
	/**
	 *	基础数据模型类
	 * @author cloud
	 */
	public class BaseDataModel extends EventDispatcher implements ICDataModel
	{
		public function BaseDataModel()	
		{
		}
		/**
		 * 根据数据类型，获取缓存数据对象集合 
		 * @param type		数据类型
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getCacheDatasByType(type:uint):Vector.<ICData>
		{
			return CDataManager.Instance.getCacheDatasByType(type);
		}
		/**
		 * 根据数据类型，获取数据对象集合
		 * @param type		数据类型
		 * @return Vector.<ICData>
		 * 
		 */	
		public function getDatasByType(type:uint):Vector.<ICData>
		{
			return CDataManager.Instance.getShareDatasByType(type);
		}
		/**
		 * 根据数据类型和父数据对象的唯一ID，获取数据对象集合 
		 * @param type
		 * @param parentID
		 * @return Vector.<ICData>
		 * 
		 */
		public function getDatasByTypeAndParentID(type:uint,parentID:String):Vector.<ICData>
		{
			return CDataManager.Instance.getShareDatasByTypeAndParentID(type,parentID);
		}
		/**
		 * 根据数据的类型和唯一ID，获取数据对象
		 * @param type		数据的类型
		 * @param uniqueID		数据的唯一ID
		 * @return ICData
		 * 
		 */		
		public function getDataByTypeAndID(type:uint,uniqueID:String):ICData
		{
			return CDataManager.Instance.getShareDataByTypeAndID(type,uniqueID);
		}
		/**
		 * 根据数据对象的父ID，获取数据对象集合 
		 * @param parentID
		 * @return Vector.<ICData>
		 * 
		 */	
		protected function getDatasByParentID(parentID:String):Vector.<ICData>
		{
			return CDataManager.Instance.getShareDatasByParentID(parentID);
		}
		public function addShareData(data:ICData):void
		{
			CDataManager.Instance.addShareData(data);
		}
		public function addCacheData(data:ICData):void
		{
			CDataManager.Instance.addCacheData(data);
		}
		public function removeCacheData(data:ICData):void
		{
			CDataManager.Instance.removeCacheData(data);
		}
		public function removeShareDataByType(type:uint):void
		{
			CDataManager.Instance.removeShareDataByType(type);
		}
		public function clearAll():void
		{
			CDataManager.Instance.clearAll();
		}
		public function clearAllShareData():void
		{
			CDataManager.Instance.clearShareData();
		}
		public function clearAllCache():void
		{
			CDataManager.Instance.clearCache();
		}
	}
}
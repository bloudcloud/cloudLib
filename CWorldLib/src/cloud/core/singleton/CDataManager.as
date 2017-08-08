package cloud.core.singleton
{
	import flash.utils.Dictionary;
	
	import cloud.core.interfaces.ICData;
	
	import ns.cloudLib;
	
	/**
	 * 户内的数据管理类
	 * @author cloud
	 */
	public class CDataManager
	{
		private static var _Instance:CDataManager;
		cloudLib static function get Instance():CDataManager
		{
			return _Instance ||= new CDataManager(new SingletonEnforce());
		}
		
		private var _dataCacheDic:Dictionary;
		private var _dataShareDic:Dictionary;
		
		public function CDataManager(enforcer:SingletonEnforce)
		{
			_dataCacheDic=new Dictionary();
			_dataShareDic=new Dictionary();
		}
		
		public function addCacheData(data:ICData,mark:String=null):void
		{
			_dataCacheDic[data.type] ||= new Vector.<ICData>();
			if((_dataCacheDic[data.type] as Vector.<ICData>).indexOf(data)<0)
				_dataCacheDic[data.type].push(data);
		}
		public function addShareData(data:ICData):void
		{
			_dataShareDic[data.type] ||= new Vector.<ICData>();
			if((_dataShareDic[data.type] as Vector.<ICData>).indexOf(data)<0)
				_dataShareDic[data.type].push(data);
		}
		public function removeCacheData(cache:ICData):void
		{
			var caches:Vector.<ICData>=_dataCacheDic[cache.type] as Vector.<ICData>;
			if(caches)
			{
				var index:int=caches.indexOf(cache);
				if(index>=0)
				{
					caches[index].clear();
					caches.splice(index,1);
				}
			}
		}
		/**
		 * 移除一个类型的所有存储数据 
		 * @param type 数据类型
		 * 
		 */		
		public function removeShareDataByType(type:uint):void
		{
			var datas:Vector.<ICData>=_dataShareDic[type] as Vector.<ICData>;
			if(datas)
			{
				for each(var data:ICData in datas)
				{
					data.clear();
				}
				datas.length=0;
			}
		}
		public function removeShareData(data:ICData):void
		{
			var datas:Vector.<ICData>=_dataShareDic[data.type] as Vector.<ICData>;
			if(datas)
			{
				var index:int=datas.indexOf(data);
				if(index>=0)
				{
					datas[index].clear();
					datas.splice(index,1);
				}
			}
		}
		public function getCacheDatasByType(type:uint):Vector.<ICData>
		{
			_dataCacheDic[type] ||= new Vector.<ICData>();
			return _dataCacheDic[type];
		}
		/**
		 * 根据数据类型，获取数据对象集合
		 * @param type		数据类型
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getShareDatasByType(type:uint):Vector.<ICData>
		{
			_dataShareDic[type] ||= new Vector.<ICData>();
			return _dataShareDic[type];
		}
		/**
		 * 根据数据类型和父数据对象的唯一ID，获取数据对象集合 
		 * @param type
		 * @param parentID
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getShareDatasByTypeAndParentID(type:uint,parentID:String):Vector.<ICData>
		{
			var datas:Vector.<ICData>=_dataShareDic[type] as Vector.<ICData>;
			if(parentID!=null)
			{
				var returnDatas:Vector.<ICData>=new Vector.<ICData>();
				for(var i:int=0; i<datas.length; i++)
				{
					if(datas[i].parentID==parentID)
						returnDatas.push(datas[i]);
				}
				return returnDatas.length>0 ? returnDatas : null;
			}
			return datas;
		}
		/**
		 * 根据数据对象的父ID，获取数据对象集合 
		 * @param parentID
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getShareDatasByParentID(parentID:String):Vector.<ICData>
		{
			var returnDatas:Vector.<ICData>=new Vector.<ICData>();
			for each(var datas:Vector.<ICData> in _dataShareDic)
			{
				for each(var data:ICData in datas)
				{
					if(data.parentID==parentID)
						returnDatas.push(data);
				}
			}
			return returnDatas.length==0 ? null : returnDatas;
		}
		/**
		 * 根据数据对象的唯一ID，获取数据对象 
		 * @param uniqueID		数据对象的唯一ID
		 * @return ICData
		 * 
		 */		
		public function getShareDataByUniqueID(uniqueID:String):ICData
		{
			for each(var datas:Vector.<ICData> in _dataShareDic)
			{
				for each(var data:ICData in datas)
				{
					if(data.uniqueID==uniqueID)
					{
						return data;
					}
				}
			}
			return null;
		}
		/**
		 * 根据数据对象的类型和唯一ID，获取数据对象 
		 * @param type		数据对象的类型
		 * @param uniqueID		数据对象的唯一ID
		 * @return ICData
		 * 
		 */		
		public function getShareDataByTypeAndID(type:uint, uniqueID:String):ICData
		{
			var datas:Vector.<ICData>=_dataShareDic[type] as Vector.<ICData>;
			for each(var data:ICData in datas)
			{
				if(data.uniqueID==uniqueID)
				{
					return data;
				}
			}
			return null;
		}
		/**
		 * 清空所有数据 
		 * 
		 */		
		public function clearAll():void
		{
			clearCache();
			clearShareData();
		}
		/**
		 * 清空所有共享数据 
		 * 
		 */		
		public function clearShareData():void
		{
			for(var key:* in _dataShareDic)
			{
				var datas:Vector.<ICData>=_dataShareDic[key] as Vector.<ICData>;
				for each(var data:ICData in datas)
				{
					if(data.isLife)
						data.clear();
				}
				datas.length=0;
				delete _dataShareDic[key];
			}
		}
		/**
		 * 清空所有缓存数据 
		 * 
		 */		
		public function clearCache():void
		{
			for(var key:* in _dataCacheDic)
			{
				var datas:Vector.<ICData>=_dataCacheDic[key] as Vector.<ICData>;
				for each(var data:ICData in datas)
				{
					if(data.isLife)
						data.clear();
				}
				datas.length=0;
				delete _dataCacheDic[key];
			}
		}
	}
}
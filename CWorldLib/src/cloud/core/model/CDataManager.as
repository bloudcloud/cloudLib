package cloud.core.model
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
		private static var _instance:CDataManager;
		cloudLib static function get instance():CDataManager
		{
			return _instance ||= new CDataManager(new Singleton());
		}
		
		private var _dataCacheDic:Dictionary;
		private var _dataDic:Dictionary;
		
		public function CDataManager(enforcer:Singleton)
		{
			_dataCacheDic=new Dictionary();
			_dataDic=new Dictionary();
		}
		
		public function addCacheData(data:ICData):void
		{
			_dataCacheDic[data.type] ||= new Vector.<ICData>();
			if((_dataCacheDic[data.type] as Vector.<ICData>).indexOf(data)<0)
				_dataCacheDic[data.type].push(data);
		}
		public function addData(data:ICData):void
		{
			_dataDic[data.type] ||= new Vector.<ICData>();
			if((_dataDic[data.type] as Vector.<ICData>).indexOf(data)<0)
				_dataDic[data.type].push(data);
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
					caches.removeAt(index);
				}
			}
		}
		public function removeData(data:ICData):void
		{
			var datas:Vector.<ICData>=_dataDic[data.type] as Vector.<ICData>;
			if(datas)
			{
				var index:int=datas.indexOf(data);
				if(index>=0)
				{
					datas[index].clear();
					datas.removeAt(index);
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
		public function getDatasByType(type:uint):Vector.<ICData>
		{
			_dataDic[type] ||= new Vector.<ICData>();
			return _dataDic[type];
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
			var datas:Vector.<ICData>=_dataDic[type] as Vector.<ICData>;
			if(parentID!=null)
			{
				var returnDatas:Vector.<ICData>=new Vector.<ICData>();
				for each(var data:ICData in datas)
				{
					if(data.parentID==parentID)
						returnDatas.push(data);
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
		public function getDatasByParentID(parentID:String):Vector.<ICData>
		{
			var returnDatas:Vector.<ICData>=new Vector.<ICData>();
			for each(var datas:Vector.<ICData> in _dataDic)
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
		public function getDataByUniqueID(uniqueID:String):ICData
		{
			for each(var datas:Vector.<ICData> in _dataDic)
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
		public function getDataByTypeAndID(type:uint, uniqueID:String):ICData
		{
			var datas:Vector.<ICData>=_dataDic[type] as Vector.<ICData>;
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
			for(var key:* in _dataDic)
			{
				var datas:Vector.<ICData>=_dataDic[key] as Vector.<ICData>;
				for each(var data:ICData in datas)
				{
					data.clear();
				}
				datas.length=0;
				delete _dataDic[key];
			}
		}
		public function clearCache():void
		{
			for(var key:* in _dataCacheDic)
			{
				var datas:Vector.<ICData>=_dataCacheDic[key] as Vector.<ICData>;
				for each(var data:ICData in datas)
				{
					data.clear();
				}
				datas.length=0;
				delete _dataCacheDic[key];
			}
		}
	}
}
class Singleton{}
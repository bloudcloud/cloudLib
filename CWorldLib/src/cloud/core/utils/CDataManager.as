package cloud.core.utils
{
	import cloud.core.datas.maps.CHashMap;
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICResource;
	
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
		
		private var _dataCacheMap:CHashMap;
		private var _dataShareMap:CHashMap;
		
		public function CDataManager(enforcer:SingletonEnforce)
		{
			_dataCacheMap=new CHashMap();
			_dataShareMap=new CHashMap();
		}
		
		public function addCacheData(data:ICData,mark:String=null):void
		{
			var datas:Array;
			var isSearch:Boolean;
			if(_dataCacheMap.containsKey(data.type))
			{
				datas=_dataCacheMap.get(data.type) as Array;
				for each(var saveData:ICData in datas)
				{
					if(saveData.uniqueID==data.uniqueID)
					{
						isSearch=true;
						break;
					}
				}
			}
			else
			{
				datas=[];
				_dataCacheMap.put(data.type,datas);
			}
			if(!isSearch)
			{
				datas.push(data);
			}
		}
		public function addShareData(data:ICData):void
		{
			var datas:Array;
			var isSearch:Boolean;
			if(_dataShareMap.containsKey(data.type))
			{
				datas=_dataShareMap.get(data.type) as Array;
				for(var i:int=datas.length-1; i>=0; i--)
				{
					if(datas[i].uniqueID==data.uniqueID)
					{
						isSearch=true;
						break;
					}
				}
			}
			else
			{
				datas=[];
				_dataShareMap.put(data.type,datas);
			}
			if(!isSearch)
			{
				datas.push(data);
			}
		}
		public function removeCacheData(cache:ICData):void
		{
			var caches:Array;
			var index:int=-1;
			if(_dataCacheMap.containsKey(cache.type))
			{
				caches=_dataCacheMap.get(cache.type) as Array;
				for(var i:int=caches.length-1; i>=0; i--)
				{
					if(caches[i].uniqueID==cache.uniqueID)
					{
						index=i;
						break;
					}
				}
				if(index>=0)
				{
					caches[index].clear();
					caches.removeAt(index);
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
			var datas:Array;
			if(_dataShareMap.containsKey(type))
			{
				datas=_dataShareMap.get(type) as Array;
				for each(var data:ICResource in datas)
				{
					data.clear();
				}
				datas.length=0;
			}
		}
		public function removeShareData(data:ICData):void
		{
			var index:int=-1;
			var datas:Array;
			if(_dataShareMap.containsKey(data.type))
			{
				datas=_dataShareMap.get(data.type) as Array;
				for(var i:int=datas.length-1; i>=0; i--)
				{
					if(datas[i].uniqueID==data.uniqueID)
					{
						index=i;
						break;
					}
				}
				if(index>=0)
				{
					datas[index].clear();
					datas.removeAt(index);
				}
			}
		}
		public function getCacheDatasByType(type:uint):Vector.<ICData>
		{
			return _dataCacheMap.containsKey(type) ? Vector.<ICData>(_dataCacheMap.get(type)) : null;
		}
		/**
		 * 根据数据类型，获取数据对象集合
		 * @param type		数据类型
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getShareDatasByType(type:uint):Vector.<ICData>
		{
			return _dataShareMap.containsKey(type) ? Vector.<ICData>(_dataShareMap.get(type)) : null;
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
			var datas:Array;
			
			if(_dataShareMap.containsKey(type))
			{
				datas=_dataShareMap.get(type) as Array;
				if(parentID!=null)
				{
					var returnDatas:Vector.<ICData>=new Vector.<ICData>();
					var len:int=datas.length;
					for(var i:int=0; i<len; i++)
					{
						if(datas[i].parentID==parentID)
						{
							returnDatas.push(datas[i]);
						}
					}
					return returnDatas.length>0 ? returnDatas : null;
				}
			}
			return null;
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
			var datas:Array;
			var len:int;
			
			for(var i:int=_dataShareMap.keys.length-1; i>=0; i--)
			{
				if(!_dataShareMap.containsKey(_dataShareMap.keys[i]))
				{
					continue;
				}
				datas=_dataShareMap.get(_dataShareMap.keys[i]) as Array;
				len=datas.length;
				for(var j:int=0; j<len; j++)
				{
					if(datas[j].parentID==parentID)
					{
						returnDatas.push(datas[j]);
					}
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
			var datas:Array;
			
			for(var i:int=_dataShareMap.keys.length-1; i>=0; i--)
			{
				if(!_dataShareMap.containsKey(_dataShareMap.keys[i]))
				{
					continue;
				}
				datas=_dataShareMap.get(_dataShareMap.keys[i]) as Array;
				
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
			var datas:Array;
			if(_dataShareMap.containsKey(type))
			{
				datas=_dataShareMap.get(type) as Array;
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
			var datas:Array;
			for(var i:int=_dataShareMap.keys.length-1; i>=0; i--)
			{
				datas =_dataShareMap.get(_dataShareMap.keys[i]) as Array;
				for each(var data:ICResource in datas)
				{
					if(data.isLife)
					{
						data.clear();
					}
				}
				datas.length=0;
				_dataShareMap.remove(_dataShareMap.keys[i]);
			}
		}
		/**
		 * 清空所有缓存数据 
		 * 
		 */		
		public function clearCache():void
		{
			var datas:Array;
			for(var i:int=_dataCacheMap.keys.length-1; i>=0; i--)
			{
				datas =_dataCacheMap.get(_dataCacheMap.keys[i]) as Array;
				for each(var data:ICResource in datas)
				{
					if(data.isLife)
					{
						data.clear();
					}
				}
				datas.length=0;
				_dataCacheMap.remove(_dataCacheMap.keys[i]);
			}
		}
	}
}
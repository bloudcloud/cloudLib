package extension.cloud.mvcs.base.model
{
	import cloud.core.datas.maps.CHashMap;
	
	import ns.cloud_lejia;

	use namespace cloud_lejia;
	/**
	 * 基础业务框架数据模型类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CBaseL3DModel
	{
		
		private var _baseDataMap:CHashMap;
		
		public function CBaseL3DModel()
		{
			_baseDataMap=new CHashMap();
		}
		/**
		 * 添加基础数据 
		 * @param data	基础数据对象
		 * 
		 */		
		protected function doAddBaseData(data:CBaseL3DData):void
		{
			var cache:CBaseL3DData;
			
			cache=_baseDataMap.get(data.uniqueID) as CBaseL3DData;
			if(cache)
			{
				_baseDataMap.remove(data.uniqueID);
			}
			_baseDataMap.put(data.uniqueID,data);
		}
		/**
		 *	移除基础数据
		 * @param dataID		基础数据唯一ID
		 * 
		 */		
		protected function doRemoveBaseData(dataID:String):void
		{
			var baseData:CBaseL3DData=_baseDataMap.get(dataID) as CBaseL3DData;
			if(baseData)
			{
				baseData.clear();
				_baseDataMap.remove(dataID);
			}
		}
		/**
		 * 根据ownerID移除基础数据
		 * @param ownerID
		 * 
		 */		
		protected function doRemoveBaseDatasByOwnerID(ownerID:String):void
		{
			var baseData:CBaseL3DData;
			var result:Array;		
			var keys:Array;
			var key:String;
			
			keys=_baseDataMap.keys;
			for(var i:int=keys.length-1; i>=0; i--)
			{
				key=keys[i];
				baseData=_baseDataMap.get(key) as CBaseL3DData;
				if(baseData.ownerID==ownerID)
				{
					_baseDataMap.remove(key);
				}
			}
		}
		/**
		 * 获取基础数据 
		 * @param dataID
		 * @return CBaseL3DData
		 * 
		 */		
		protected function doGetBaseDataFromID(roomID:String):CBaseL3DData
		{
			return _baseDataMap.get(roomID) as CBaseL3DData;
		}
		/**
		 * 通过拥有者的唯一ID获取基础数据对象集合 
		 * @param ownerID
		 * @return Array
		 * 
		 */		
		cloud_lejia function doGetBaseDatasFromOwnerID(ownerID:String):Array
		{
			var baseData:CBaseL3DData;
			var result:Array;
			
			for each(var key:String in _baseDataMap.keys)
			{
				baseData=_baseDataMap.get(key) as CBaseL3DData;
				if(baseData.ownerID==ownerID)
				{
					result||=[];
					result.push(baseData);
				}
			}
			return result;
		}
		/**
		 * 通过唯一ID获取基础数据对象 
		 * @param uniqueID
		 * @return CBaseL3DData
		 * 
		 */		
		cloud_lejia function doGetBaseDataByUniqueID(uniqueID:String):CBaseL3DData
		{
			return _baseDataMap.get(uniqueID) as CBaseL3DData;
		}
		/**
		 * 遍历所有的基础数据，执行搜索回调，返回是否发生中断
		 * @param callback	回调函数
		 * @param callbackParams	回调函数的执行参数
		 * @return String
		 * 
		 */		
		protected function doMapBaseData(callback:Function,...callbackParams):Boolean
		{
			if(callback==null)
			{
				return null;
			}
			var isBroken:Boolean;
			var params:Array;
			
			params=callbackParams.concat();
			params.unshift(null);
			for each(var key:String in _baseDataMap.keys)
			{
				params[0]=_baseDataMap.get(key);
				if(callback.apply(null,params))
				{
					isBroken=true;
					break;
				}
			}
			return isBroken;
		}
		/**
		 * 遍历所有基础数据,执行回调函数
		 * @param callback	回调函数，只有一个参数为基础数据，并且必须返回一个Boolean值，确定是否处理成功
		 * @param callbackParams	回调函数的执行参数
		 * @return Boolean	遍历是否中断
		 * 
		 */		
		cloud_lejia function doDealForEachBaseData(callback:Function,...callbackParams):Boolean
		{
			if(callback==null)
			{
				return false;
			}
			for each(var key:String in _baseDataMap.keys)
			{
				callbackParams.unshift(_baseDataMap.get(key));
				if(callback.apply(null,callbackParams))
				{
					return true;
				}
			}
			return false;
		}
		
		public function clearAllCache():void
		{
			_baseDataMap.clear();
		}
//		/**
//		 * 获取缓存的基础数据集合 
//		 * @return CHashMap
//		 * 
//		 */		
//		cloud_lejia function get baseDataMap():CHashMap
//		{
//			return _baseDataMap;
//		}
	}
}
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
		
		private var _dataDic:Dictionary;
		
		public function CDataManager(enforcer:Singleton)
		{
			_dataDic=new Dictionary();
		}
		
		public function addData(data:ICData):void
		{
			_dataDic[data.type] ||= new Vector.<ICData>();
			_dataDic[data.type].push(data);
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
		/**
		 * 根据数据类型获取数据集合,如果有过滤条件，返回过滤后的数据集合 
		 * @param type
		 * @param filterCallBack
		 * @return Vector.<ICData>
		 * 
		 */		
		public function getDatasByType(type:uint,filterCallBack:Function=null):Vector.<ICData>
		{
			_dataDic[type] ||= new Vector.<ICData>();
			if(filterCallBack!=null)
			{
				//有过滤条件
				var returnDatas:Vector.<ICData>=new Vector.<ICData>();
				var datas:Vector.<ICData>=_dataDic[type] as Vector.<ICData>;
				for each(var data:ICData in datas)
				{
					if(filterCallBack.call(null,data))
						returnDatas.push(data);
				}
				return returnDatas;
			}
			return _dataDic[type];
		}
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
		public function clear():void
		{
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
	}
}
class Singleton{}
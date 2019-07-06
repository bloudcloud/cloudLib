package utils.lx.managers.task
{
	import cloud.core.utils.CUtil;
	
	import ns.cloud_lejia;
	
	import utils.lx.LoadType;
	
	use namespace cloud_lejia;
	/**
	 * 下载任务数据类
	 * @author cloud
	 */
	public class L3DRPCLoadTaskData implements ILoaderTaskData
	{
		/**
		 *	下载成功后的回调处理
		 */		
		private var _successCallback:Function;
		/**
		 * 下载失败后的回调处理 
		 */		
		private var _faultCallback:Function;
		
		private var _uniqueID:String;
		/**
		 * 下载任务数据的类型 
		 */		
		private var _type:int;
		private var _path:String;
		/**
		 * 是否处理完成 
		 */		
		cloud_lejia var _isFinished:Boolean;
		/**
		 * 当前任务需要执行的下载数量，当任务启动后，该值为0时认为下载任务完成
		 */		
		cloud_lejia var _loadCount:int;
		
		/**
		 * rpc异步类型 
		 */		
		public var rpcType:int;
		public var url:String;
		public var code:String;
		public var nodeID:String;
		
		public function get uniqueID():String
		{
			return _uniqueID;
		}
		public function get type():int
		{
			return _type;
		}
		public function get path():String
		{
			if(!_path || !_path.length)
			{
				switch(_type)
				{
					case LoadType.RPCLOADDATA_URL:
						_path=url;
						break;
					case LoadType.RPCLOADDATA_CODE:
						_path=code;
						break;
					case LoadType.RPCLOADDATA_NODEID:
						_path=nodeID;
						break;
				}
			}
			return _path;
		}
		public function get successCallback():Function
		{
			return _successCallback;
		}
		public function get faultCallback():Function
		{
			return _faultCallback;
		}
		public function get isFinished():Boolean
		{
			return _isFinished;
		}
		public function get isUsed():Boolean
		{
			return _isFinished || _loadCount>0;
		}
		
		public function L3DRPCLoadTaskData(path:String,type:int,sCallback:Function=null,fCallback:Function=null,rpcType:int=0)
		{
			_path=path;
			_type=type;
			_successCallback=sCallback;
			_faultCallback=fCallback;
			this.rpcType=rpcType;
			_uniqueID=CUtil.Instance.createUID();
			switch(_type)
			{
				case LoadType.RPCLOADDATA_URL:
					url=path;
					break;
				case LoadType.RPCLOADDATA_CODE:
					code=path;
					break;
				case LoadType.RPCLOADDATA_NODEID:
					nodeID=path;
					break;
			}
		}
		
		public function updateData(source:Object):void
		{
			_type=source.type;
			url=source.url;
			code=source.code;
			nodeID=source.nodeID;
			_successCallback=source.successCallback;
			_faultCallback=source.faultCallback;
		}
		
		public function clear():Boolean
		{
			_type=0;
			_path=null;
			rpcType=0;
			url=null;
			code=null;
			nodeID=null;
			_loadCount=0;
			_successCallback=null;
			_faultCallback=null;
			_uniqueID=null;
			_isFinished=true;
			return true;
		}
	}
}
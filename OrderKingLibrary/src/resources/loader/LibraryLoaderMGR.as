package resources.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.HashMap;
	import core.L3DLibraryWebService;
	import core.events.DatasEvent;
	
	import resources.task.ILoaderTaskData;
	import resources.task.L3DRPCLoadTaskData;
	
	import utils.OKBaseUtil;

	[Event(name="LibraryLoader_LoadAllComplete",type="utils.DatasEvent")]
	[Event(name="LibraryLoader_LoadComplete", type="utils.DatasEvent")]
	[Event(name="LibraryLoader_LoadError", type="utils.DatasEvent")]
	
	public class LibraryLoaderMGR extends EventDispatcher
	{
		public static const Event_loadAllComplete:String="LibraryLoader_LoadAllComplete";
		public static const Event_loadComplete:String="LibraryLoader_LoadComplete";
		public static const Event_loadError:String="LibraryLoader_LoadError";
		
		private var _isRunning:Boolean;
		/**
		 * 下载器
		 */		
		private var _rpcLoaders:Vector.<IL3DLoader>;
		private var _loadQueueMap:HashMap;
		/**
		 * 后台下载任务队列 
		 */		
		private var _backQueue:Vector.<ILoaderTaskData>;
		/**
		 * 下载任务队列 
		 */		
		private var _loadQueue:Vector.<ILoaderTaskData>;
		private var _loadQueueID:String;
		/**
		 * 完成的任务数量 
		 */		
		private var _finishedTaskCount:uint;
		/**
		 * 当前空闲的下载器 
		 */		
		private var _curFreeRPCLoader:IL3DLoader;
		
		public function get freeRPCLoader():IL3DLoader
		{
			if(!_curFreeRPCLoader || _curFreeRPCLoader.isRunning)
			{
				var isSearched:Boolean=false;
				var i:int=_rpcLoaders.length-1;
				for(;i>=0;i--)
				{
					if(!_rpcLoaders[i].isRunning)
					{
						isSearched=true;
						_curFreeRPCLoader=_rpcLoaders[i];
						break;
					}
				}
				if(!isSearched)
				{
					_curFreeRPCLoader=null;
				}
			}
			return _curFreeRPCLoader;
		}
		
		public function LibraryLoaderMGR()
		{
			_rpcLoaders=new Vector.<IL3DLoader>();
			_rpcLoaders.push(new L3DRPCLoader(),new L3DRPCLoader());
			var i:int=_rpcLoaders.length-1;
			for(;i>=0;i--)
			{
				_rpcLoaders[i].addEventListener(Event.COMPLETE,onLoadComplete);
				_rpcLoaders[i].addEventListener("loadError",onLoadError);
			}
			_loadQueueMap=new HashMap();
			_backQueue=new Vector.<ILoaderTaskData>();
		}
		private function get nextTask():ILoaderTaskData
		{
			var taskData:ILoaderTaskData;
			var i:int=_loadQueue?_loadQueue.length-1:0;
			for(;i>=0;i--)
			{
				if(!_loadQueue[i].isUsed)
				{
					taskData=_loadQueue[i];
					break;
				}
			}
			return taskData;
		}
		private function onLoadComplete(evt:DatasEvent):void
		{
			var loader:IL3DLoader=evt.currentTarget as IL3DLoader;
			_finishedTaskCount++;
			if(loader.isNeedBroadcast)
			{
				dispatchEvent(new DatasEvent(Event_loadComplete,evt.data));
			}
			_isRunning=doExcuteRPCLoad();
 		}
		private function onLoadError(evt:DatasEvent):void
		{
			_finishedTaskCount++;
			dispatchEvent(new DatasEvent(Event_loadError,evt.data));
			_isRunning=doExcuteRPCLoad();
		}
		private function doAddToQueue(key:String,type:int,successCallback:Function,faultCallback:Function,rpcType:int):void
		{
			var taskData:L3DRPCLoadTaskData;
			taskData=new L3DRPCLoadTaskData(key,type,successCallback,faultCallback,rpcType);
			_backQueue.push(taskData);
		}
		private function doAllFinished():Boolean
		{
			if(!_loadQueue) return true;
			if(_loadQueue.length==_finishedTaskCount) 
			{
				for each(var taskData:ILoaderTaskData in _loadQueue)
				{
					if(taskData)
					{
						taskData.clear();
					}
				}
				//移除下载任务队列缓存
				var keys:Array=_loadQueueMap.getAllKey();
				for(var i:int=keys.length-1; i>=0; i--)
				{
					if(_loadQueueMap.getValue(keys[i])==_loadQueue)
					{
						_loadQueueID=keys[i];
						_loadQueueMap.remove(keys[i]);
						break;
					}
				}
				_loadQueue.length=0;
				_loadQueue=null;
				_finishedTaskCount=0;
				_isRunning=false;
				if(hasEventListener(Event_loadAllComplete))
				{
					dispatchEvent(new DatasEvent(Event_loadAllComplete,_loadQueueID));
				}
				_loadQueueID=null;
				//下载队列任务全部完成，检查是否还有缓存的下载队列，如果有则继续下载
				if(!excuteRPCLoad())
				{
					return true;
				}
			}
			return false;
		}
		private function doExcuteRPCLoad():Boolean
		{
			var result:Boolean;
			result=!doAllFinished();
			if(result)
			{
				var task:ILoaderTaskData=nextTask;
				if(!task) 
				{
					return true;
				}
				if(freeRPCLoader)
				{
					//找到空闲下载器，执行一个下载任务
					freeRPCLoader.excuteLoad(task);
				}
			}
			return result;
		}
		/**
		 * 执行RPC异步下载 
		 * 
		 */		
		public function excuteRPCLoad():String
		{
			var tmpQueueID:String;
			if(_backQueue.length>0)
			{
				//下载执行中若临时下载队列不为空，则打包成一整个队列任务缓存到下载任务哈希图中
				tmpQueueID=OKBaseUtil.Instance.createUID();
				_loadQueueMap.add(tmpQueueID,_backQueue);
				_backQueue=new Vector.<ILoaderTaskData>();
			}
			if(!_isRunning)
			{
				if(!_loadQueue || !_loadQueue.length)
				{
					if(_loadQueueMap.length>0)
					{
						//下载任务哈希图中获取一个下载队列先执行
						_loadQueueID=_loadQueueMap.getAllKey()[0];
						_loadQueue=_loadQueueMap.getValue(_loadQueueID);
						doExcuteRPCLoad();
						tmpQueueID=_loadQueueID;
						_isRunning=true;
					}
				}
			}
			return tmpQueueID;
		}
		/**
		 * 根据路径和类型执行RPC下载商品信息，默认下载商品的原图，需要走监听事件流程时，可监听Event_loadComplete和Event_loadError事件
		 * @param path	下载路径
		 * @param type	下载类型
		 * @param successCallback
		 * @param faultCallback
		 * @param rpcType	rpc下载类型，0-全图 1-100px 2-200px 3-None
		 * 
		 */		
		public function createRPCLoadTask(path:String,type:int,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):void
		{
			if(!path || !path.length)
			{
				return;
			}
			doAddToQueue(path,type,successCallback,faultCallback,rpcType);
		}
		/**
		 * 根据URL加载L3DMaterialInformation，默认下载大图，监听LibraryLoader_LoadURLComplete和LibraryLoader_LoadURLError事件
		 * @param url
		 * @param successCallback
		 * @param faultCallback
		 * @param rpcType 0-全图 1-100px 2-200px 3-None
		 * 
		 */				
		public function addInfomationByUrl(url:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):void
		{
			if(url == null || url.length == 0)
			{
				return;
			}
			doAddToQueue(url,LoadType.RPCLOADDATA_URL,successCallback,faultCallback,rpcType);
			if(_loadQueue==null)
			{
				_loadQueue=_backQueue;
				_loadQueueID=OKBaseUtil.Instance.createUID();
				_loadQueueMap.add(_loadQueueID,_backQueue);
				_backQueue=new Vector.<ILoaderTaskData>();
			}
			doExcuteRPCLoad();
		}
		/**
		 * 根据Code加载L3DMaterialInformation，默认下载大图，监听LibraryLoader_LoadCodeComplete和LibraryLoader_LoadCodeError事件
		 * @param code
		 * @param successCallback
		 * @param faultCallback
		 * @param rpcType 0-全图 1-100px 2-200px 3-None
		 * 
		 */			
		public function addInformationByCode(code:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):void
		{
			if(code == null || code.length == 0)
			{
				return;
			}
			doAddToQueue(code,LoadType.RPCLOADDATA_CODE,successCallback,faultCallback,rpcType);
			if(_loadQueue==null)
			{
				_loadQueue=_backQueue;
				_loadQueueID=OKBaseUtil.Instance.createUID();
				_loadQueueMap.add(_loadQueueID,_backQueue);
				_backQueue=new Vector.<ILoaderTaskData>();
			}
			doExcuteRPCLoad();
		}	
		/**
		 * 下载XML里包含的下载地址
		 * @param code
		 * @param successCallback
		 * @param faultCallback
		 * @param rpcType
		 */		
		public function downloadNodeXML(nodeID:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):void
		{
			if (!L3DLibraryWebService.WebServiceEnable || nodeID == null || nodeID.length == 0)
			{
				return;
			}
			doAddToQueue(nodeID,LoadType.RPCLOADDATA_NODEID,successCallback,faultCallback,rpcType);
			if(_loadQueue==null)
			{
				_loadQueue=_backQueue;
				_loadQueueID=OKBaseUtil.Instance.createUID();
				_loadQueueMap.add(_loadQueueID,_backQueue);
				_backQueue=new Vector.<ILoaderTaskData>();
			}
			doExcuteRPCLoad();
		}
	}
}
package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DMaterialInformations;
	
	import extension.cloud.dict.CWebServiceDict;
	
	import ns.cloud_lejia;
	
	import utils.DatasEvent;
	import utils.lx.LoadType;
	import utils.lx.consts.LogFlagCustom;
	import utils.lx.managers.task.ILoaderTaskData;
	import utils.lx.managers.task.L3DRPCLoadTaskData;

	use namespace cloud_lejia;
	[Event(name="loadError", type="flash.events.Event")]
	/**
	 * rpc下载器类
	 * @author cloud
	 */
	public class L3DRPCLoader extends EventDispatcher implements IL3DLoader
	{
		private static const _LOAD_MATERIALINFO_NULL:String = "正常加载完成，但materialInfo结果为空";
		private static const _LOAD_MATERIALINFO_ERROR:String = "加载materialInfo报错";
		private static const _LOAD_PREVIEW_NULL:String = "没有加载到BitmapData";
		private static const _LOAD_LINKEDDATAURL_NULL:String = "正常加载完成，加载LinkedDataURL为空值";
		private static const _LOAD_LINKEDDATAURL_ERROR:String = "加载LinkedDataURL错误";
		private static const _LOAD_MESHBUFFER_NULL:String="正常加载完成，加载MeshBuffer为空";
		private static const _LOAD_MESHBUFFER_ERROR:String="加载MeshBuffer错误";
		private static const _LOAD_XMLDATANODEID_NULL:String="正常加载完成，加载xmlDataNodeID为空值";
		private static const _LOAD_XMLDATANODEID_ERROR:String="加载xmlDataNodeID错误";
		
		private var _isRunning:Boolean;
		private var _curLoadTaskData:L3DRPCLoadTaskData;
		private var _curMaterialInfo:L3DMaterialInformations;
		private var _curXMLArray:Array;
		/**
		 * 下载器是否正在运行 
		 * @return Boolean
		 * 
		 */		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		/**
		 * 是否需要广播当前下载结果
		 * @return Boolean
		 * 
		 */		
		public function get isNeedBroadcast():Boolean
		{
			return _curLoadTaskData && _curLoadTaskData.successCallback==null;
		}
		
		public function L3DRPCLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		/**
		 * 材质下载的所有处理结束后，执行操作 
		 * 
		 */		
		private function doLoadMaterialInfoComplete():void
		{
			if(_curLoadTaskData._loadCount<=0)
			{
				//当前没有下载，结束
				_isRunning=false;
				_curLoadTaskData._isFinished=true;
				var args:Array=[getKeyByType(_curLoadTaskData.type),_curMaterialInfo];
				if(!isNeedBroadcast)
				{
					_curLoadTaskData.successCallback.apply(null,args);
				}
				this.dispatchEvent(new DatasEvent(Event.COMPLETE,args));	
			}
		}
		/**
		 * xml下载的所有处理结束后，执行操作
		 * 
		 */		
		private function doLoadXMLArrayComplete():void
		{
			if(_curLoadTaskData._loadCount<=0)
			{
				//当前没有下载，结束
				_isRunning=false;
				_curLoadTaskData._isFinished=true;
				var args:Array=[_curLoadTaskData.nodeID,_curXMLArray];
				if(!isNeedBroadcast)
				{
					_curLoadTaskData.successCallback.apply(null,args);
				}
				this.dispatchEvent(new DatasEvent(Event.COMPLETE,_curLoadTaskData));
			}
		}
		private function doLoadFault(message:String):void
		{
			if(_curLoadTaskData._loadCount==0)
			{
				//当前没有下载，结束
				_isRunning=false;
				_curLoadTaskData._isFinished=true;
				var args:Array=[getKeyByType(_curLoadTaskData.type),message];
				if(!isNeedBroadcast)
				{
					if(_curLoadTaskData.faultCallback!=null)
					{
						_curLoadTaskData.faultCallback.apply(null,args);
					}
				}
				this.dispatchEvent(new DatasEvent("loadError",args));
			}
		}
		private function getKeyByType(type:int):String
		{
			var key:String;
			switch(type)
			{
				case LoadType.RPCLOADDATA_URL:
					key=_curLoadTaskData.url;
					break;
				case LoadType.RPCLOADDATA_CODE:
					key=_curLoadTaskData.code;
					break;
				case LoadType.RPCLOADDATA_NODEID:
					key=_curLoadTaskData.nodeID;
					break;
			}
			return key;
		}
		private function onLoadMaterialInformationResultByUrl(evt:ResultEvent):void
		{
			var buffer:ByteArray = evt.result as ByteArray;
			_curLoadTaskData._loadCount--;
			if(buffer == null || buffer.length == 0)
			{
				doLoadFault(_LOAD_MATERIALINFO_NULL);
				return;
			}
			var tmpInfo:L3DMaterialInformations=new L3DMaterialInformations(buffer, _curLoadTaskData.url);
			GlobalManager.log.print(LogFlagCustom.LoadResource,"加载{0}",_curLoadTaskData.url);
			if(_curLoadTaskData.rpcType==0)
			{
				_curMaterialInfo=GlobalManager.Instance.resourceMGR.getInformation(_curLoadTaskData.url);
				if(_curMaterialInfo && !_curMaterialInfo.textureBmp)
				{
					_curMaterialInfo.textureBuffer=tmpInfo.previewBuffer;
					_curMaterialInfo.addEventListener(L3DLibraryEvent.LOAD_TEXTURE_BITMAPDATA,onLoadTextureResult);
					_curLoadTaskData._loadCount++;
					_curMaterialInfo.loadTextureBitmapdata();
				}
				else if(!_curMaterialInfo)
				{
					_curMaterialInfo=tmpInfo;
					_curMaterialInfo.textureBuffer=_curMaterialInfo.previewBuffer;
					GlobalManager.Instance.resourceMGR.addInformationURL(_curLoadTaskData.url,_curMaterialInfo);
					_curMaterialInfo.addEventListener(L3DLibraryEvent.LoadPreview,onLoadPreviewResult);
					_curLoadTaskData._loadCount++;
					_curMaterialInfo.LoadPreview();
				}
				else
				{
					//拿到全部资源，不需要下载，当前下载任务完成
					doLoadMaterialInfoComplete();
				}
			}
			else
			{
				_curMaterialInfo=tmpInfo;
				GlobalManager.Instance.resourceMGR.addInformationURL(_curLoadTaskData.url,_curMaterialInfo);
				_curMaterialInfo.addEventListener(L3DLibraryEvent.LoadPreview,onLoadPreviewResult);
				_curLoadTaskData._loadCount++;
				_curMaterialInfo.LoadPreview();
			}
		}
		private function onLoadMaterialInformationFault(evt:FaultEvent=null):void
		{
			_curLoadTaskData._loadCount--;
			doLoadFault(_LOAD_MATERIALINFO_ERROR);
		}
		private function onLoadMeshBufferResult(evt:ResultEvent):void
		{
			_curLoadTaskData._loadCount--;
			var buffer:ByteArray = evt.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				doLoadFault(_LOAD_MESHBUFFER_NULL);
				return;
			}
			buffer.position = 0;
			_curMaterialInfo.meshBuffer=buffer;
			doLoadMaterialInfoComplete();
		}
		private function onLoadMeshBufferFault(evt:FaultEvent):void
		{
			_curLoadTaskData._loadCount--;
			doLoadFault(_LOAD_MESHBUFFER_ERROR);
		}
		private function onLoadLinkedDataResult(evt:ResultEvent):void
		{
			_curLoadTaskData._loadCount--;
			var buffer:ByteArray = evt.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				doLoadFault("linkedDataUrl="+_curMaterialInfo.linkedDataUrl+","+_LOAD_LINKEDDATAURL_NULL);
				return;
			}
			buffer.position=0;
			_curMaterialInfo.xml= XML(buffer);
//			try
//			{
//				_curMaterialInfo.xml= XML(buffer);
//			}
//			catch(error:Error)
//			{
//				print(error);
//			}
			doLoadMaterialInfoComplete();
		}
		private function onLoadLinkedDataFault(evt:FaultEvent):void
		{
			_curLoadTaskData._loadCount--;
			doLoadFault("linkedDataUrl="+_curMaterialInfo.linkedDataUrl+","+_LOAD_LINKEDDATAURL_ERROR);
		}
		private function onLoadTextureResult(evt:L3DLibraryEvent):void
		{
			evt.currentTarget.removeEventListener(evt.type,onLoadTextureResult);
			_curLoadTaskData._loadCount--;
			if(evt.PreviewBitmap==null)
			{
				doLoadFault(_LOAD_PREVIEW_NULL);
				return;
			}
			_curMaterialInfo.textureBmp=evt.PreviewBitmap;
			if(_curLoadTaskData.rpcType==0)
			{
				doLoadLinkedData();
			}
			doLoadMaterialInfoComplete();
		}
		private function onLoadPreviewResult(evt:L3DLibraryEvent):void
		{
			evt.currentTarget.removeEventListener(evt.type,onLoadPreviewResult);
			_curLoadTaskData._loadCount--;
			if(evt.PreviewBitmap==null)
			{
				doLoadFault(_LOAD_PREVIEW_NULL);
				return;
			}
			if(_curMaterialInfo.previewBuffer==_curMaterialInfo.textureBuffer)
			{
				_curMaterialInfo.textureBmp=evt.PreviewBitmap;
			}
			_curMaterialInfo.Preview=evt.PreviewBitmap;
			if(_curLoadTaskData.rpcType==0)
			{
				doLoadLinkedData();
			}
			doLoadMaterialInfoComplete();
		}
		private function doLoadLinkedData():void
		{
			//下载全图时把附加数据全部下载
			if(_curMaterialInfo.url && _curMaterialInfo.url.length && _curMaterialInfo.url.lastIndexOf(".L3D")>=0)
			{
				//下载模型文件
				_curLoadTaskData._loadCount++;
				//zh 2018.8.3
				GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_DOWNLOADMATERIAL,onLoadMeshBufferResult, onLoadMeshBufferFault,_curMaterialInfo.url);
			}
			else if(_curMaterialInfo.linkedDataUrl && _curMaterialInfo.linkedDataUrl.length)
			{
				//如果有linkedDataUrl，继续加载
				_curLoadTaskData._loadCount++;
				//cloud 2018.8.2
				GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_DOWNLOAD,onLoadLinkedDataResult,onLoadLinkedDataFault,_curMaterialInfo.linkedDataUrl);
			}
			
		}
		private function onSearchMaterialInforDataResult(evt:ResultEvent):void
		{
			var buffer:ByteArray = evt.result as ByteArray;
			_curLoadTaskData._loadCount--;
			if(buffer == null || buffer.length == 0)
			{
				doLoadFault(_LOAD_MATERIALINFO_NULL);
				return;
			}
			var tmpInfo:L3DMaterialInformations=new L3DMaterialInformations(buffer, "");
			if(_curLoadTaskData.rpcType==0)
			{
				_curMaterialInfo=GlobalManager.Instance.resourceMGR.getInformation(_curLoadTaskData.code);
				if(_curMaterialInfo && !_curMaterialInfo.textureBmp)
				{
					_curMaterialInfo.textureBuffer=tmpInfo.previewBuffer;
					_curMaterialInfo.addEventListener(L3DLibraryEvent.LOAD_TEXTURE_BITMAPDATA,onLoadTextureResult);
					_curLoadTaskData._loadCount++;
					_curMaterialInfo.loadTextureBitmapdata();
				}
				else if(!_curMaterialInfo)
				{
					_curMaterialInfo=tmpInfo;
					_curMaterialInfo.textureBuffer=_curMaterialInfo.previewBuffer;
					GlobalManager.Instance.resourceMGR.addInformationURL(_curLoadTaskData.code,_curMaterialInfo);
					_curMaterialInfo.addEventListener(L3DLibraryEvent.LoadPreview,onLoadPreviewResult);
					_curLoadTaskData._loadCount++;
					_curMaterialInfo.LoadPreview();
				}
				else
				{
					//拿到全部资源，不需要下载，当前下载任务完成
					doLoadMaterialInfoComplete();
				}
			}
			else
			{
				_curMaterialInfo=tmpInfo;
				GlobalManager.Instance.resourceMGR.addInformationURL(_curLoadTaskData.code,_curMaterialInfo);
				_curMaterialInfo.addEventListener(L3DLibraryEvent.LoadPreview,onLoadPreviewResult);
				_curLoadTaskData._loadCount++;
				_curMaterialInfo.LoadPreview();
			}
		}
		private function onSearchMaterialInfoDataFault(evt:FaultEvent):void
		{
			_curLoadTaskData._loadCount--;
			doLoadFault(_LOAD_MATERIALINFO_ERROR);
		}
		private function onLoadPreviewNodeXMLResult(evt:ResultEvent):void
		{
			_curLoadTaskData._loadCount--;
			
			var xml:XML;
			var total:int;
			
			_curXMLArray = [];
			xml=new XML(evt.result);
			if (xml == null || !xml.url.length())
			{
				doLoadXMLArrayComplete();
				return;
			}
			total=xml.url.length();
			var url:String;
			for (var i:int=0; i < total; i++)
			{
				url=xml.url[i].@path.toString();
				_curXMLArray.push(url);
			}
			GlobalManager.Instance.resourceMGR.addURLs(_curLoadTaskData.nodeID,_curXMLArray);
			doLoadXMLArrayComplete();
		}
		private function onLoadPreviewNodeXMLFault(evt:FaultEvent):void
		{
			_curLoadTaskData._loadCount--;
			doLoadFault(_LOAD_XMLDATANODEID_ERROR);
		}
		/**
		 * 通过材质url，执行下载操作 
		 * @param url	材质url
		 * @param rpcType	rpc异步下载类型
		 * @return Boolean	是否成功执行下载操作
		 * 
		 */		
		protected function doLoadByUrl(url:String,rpcType:int=0):Boolean
		{
			if(!url || !url.length)
			{
				return false;
			}
			_curLoadTaskData._loadCount++;
			//zh 2018.8.3
			GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_DOWNLOADMATERIALDETAILBUFFER, onLoadMaterialInformationResultByUrl, onLoadMaterialInformationFault, url, rpcType);
			return true;
		}
		/**
		 * 通过材质code，执行下载操作
		 * @param code	材质code
		 * @param rpcType	rpc异步下载类型
		 * @return Boolean	是否成功执行下载操作
		 * 
		 */		
		protected function doLoadByCode(code:String,rpcType:int=0):Boolean
		{
			if(!code || !code.length)
			{
				return false;
			}
			_curLoadTaskData._loadCount++;
			//zh 2018.8.3
			GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_GETVIEWDETAILBUFFERFROMCODE,onSearchMaterialInforDataResult, onSearchMaterialInfoDataFault, code, rpcType);
			return true;
		}
		/**
		 * 通过nodeID，执行下载操作 
		 * @param nodeID	节点ID
		 * @param rpcType	rpc异步下载类型
		 * @return Boolean	是否成功执行下载操作
		 * 
		 */		
		protected function doLoadByNodeID(nodeID:String,rpcType:int=0):Boolean
		{
			if(!nodeID || !nodeID.length)
			{
				return false;
			}
			_curLoadTaskData._loadCount++;
			// 2017/12/7 lrj--
			GlobalManager.Instance.serviceMGR.downloadNodeURLXML(onLoadPreviewNodeXMLResult, onLoadPreviewNodeXMLFault, nodeID);
			return true;
		}
		protected function doClear():Boolean
		{
			if(_curLoadTaskData)
			{
				_curLoadTaskData.clear();
			}
			_curLoadTaskData=null;
			_curMaterialInfo=null;
			_curXMLArray=null;
			return true;
		}

		public function excuteLoad(loadTaskData:ILoaderTaskData):Boolean
		{
			if(!(loadTaskData is L3DRPCLoadTaskData)) 
			{
				return false;
			}
			var args:Array;
			doClear();
			_curLoadTaskData=loadTaskData as L3DRPCLoadTaskData;
			switch(_curLoadTaskData.type)
			{
				case LoadType.RPCLOADDATA_URL:
//					if(GlobalManager.Instance.resourceMGR.hasInformation(_curLoadTaskData.url))
//					{
//						_curLoadTaskData=loadTaskData as L3DRPCLoadTaskData;
//						_curLoadTaskData._isFinished=true;
//						args=[_curLoadTaskData.url,GlobalManager.Instance.resourceMGR.getInformation(_curLoadTaskData.url)];
//						if(_curLoadTaskData.successCallback!=null)
//						{
//							_curLoadTaskData.successCallback.apply(null,args);
//						}
//						_isRunning=false;
//					}
//					else
//					{
//						
//					}
					_isRunning=doLoadByUrl(_curLoadTaskData.url,_curLoadTaskData.rpcType);
					break;
				case LoadType.RPCLOADDATA_CODE:
//					if(GlobalManager.Instance.resourceMGR.hasInformation(_curLoadTaskData.code))
//					{
//						_curLoadTaskData._isFinished=true;
//						args=[_curLoadTaskData.code,GlobalManager.Instance.resourceMGR.getInformation(_curLoadTaskData.code)];
//						if(_curLoadTaskData.successCallback!=null)
//						{
//							_curLoadTaskData.successCallback.apply(null,args);
//						}
//						_isRunning=false;
//					}
//					else
//					{
//						_isRunning=doLoadByCode(_curLoadTaskData.code,_curLoadTaskData.rpcType);
//					}
					_isRunning=doLoadByCode(_curLoadTaskData.code,_curLoadTaskData.rpcType);
					break;
				case LoadType.RPCLOADDATA_NODEID:
//					if(GlobalManager.Instance.resourceMGR.hasURLs(_curLoadTaskData.nodeID))
//					{
//						_curLoadTaskData._isFinished=true;
//						args=[_curLoadTaskData.nodeID,GlobalManager.Instance.resourceMGR.getURLs(_curLoadTaskData.nodeID)];
//						if(_curLoadTaskData.successCallback!=null)
//						{
//							_curLoadTaskData.successCallback.apply(null,args);
//						}
//						_isRunning=false;
//					}
//					else
//					{
//						_isRunning=doLoadByNodeID(_curLoadTaskData.nodeID,_curLoadTaskData.rpcType);
//					}
					_isRunning=doLoadByNodeID(_curLoadTaskData.nodeID,_curLoadTaskData.rpcType);
					break;
			}
			if(!_isRunning)
			{
				this.dispatchEvent(new DatasEvent(Event.COMPLETE,args));
			}
			return _isRunning;
		}

	}
}
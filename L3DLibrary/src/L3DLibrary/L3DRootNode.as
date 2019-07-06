package L3DLibrary
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import utils.lx.managers.GlobalManager;

	public class L3DRootNode extends EventDispatcher
	{
		public static const EventType_AllJSONLoadComplete:String = "L3DRootNode_EventType_AllJSONLoadComplete";
		private static var _instance:L3DRootNode = new L3DRootNode();
		private var _enabled:Boolean;
		private var _xml:XML;
		private var jsonWebService:Object;
		private var jsonConfig:Object;
		private var lejiaJsonWebService:Object;
//		private var completeFlag1:Boolean;
//		private var completeFlag2:Boolean;
		
		public function L3DRootNode()
		{
		}
		
		public function downloadRootNodeXML():void {
			if (!L3DLibraryWebService.WebServiceEnable) {
				return;
			}
			
			var sceneBrand:String = LivelyLibrary.SceneBrand;
			GlobalManager.Instance.serviceMGR.downloadRootNodeJsonByCompanyName(downloadRootNodeJsonByCompanyNameBrandSucess,downloadRootNodeJsonByCompanyNameBrandFault,sceneBrand);
//			var atObj:AsyncToken=L3DLibraryWebService.LibraryService.DownloadRootNodeXML();
//			var rpObj:mx.rpc.Responder=new mx.rpc.Responder(loadRootNodeXMLResult, loadRootNodeXMLFault);
			/**
			 * mx.rpc.AsyncToken.addResponder(responder:IResponder):void
				可向响应器 Array 中添加响应器。分配给 responder 参数的对象必须实现 mx.rpc.IResponder。
				参数:
					responder 异步请求完成时将调用的处理函数。
			 * */
//			atObj.addResponder(rpObj);
//			URLLoader 类以文本、二进制数据或 URL 编码变量的形式从 URL 下载数据。
			
//			trace(LivelyLibrary.SceneCode);
			
//			lrj 18.8.13 门窗demo读取另外的json，以免影响正式版
//			if(UserType.USER_BRAND == Brand.MenChuang)
//			{
			//urlLoader.load(new URLRequest("configs/brandnodes/"+sceneCode+"Info.json"));
//			}
			
		}
		
		private function downloadRootNodeJsonByCompanyNameBrandSucess(event:ResultEvent):void
		{
			if(!event.result)
			{
				LivelyLibrary.ShowMessage("服务端返回数据为空", 1);
				return;
			}
			jsonWebService=JSON.parse(event.result as String);
			
			if(jsonWebService.library[0].children.length > 0)
			{
				jsonSortOnHandler(jsonWebService.library[0].children as Array);
			}
			
			var urlLoader:URLLoader=new URLLoader();
			//指定以原始二进制数据形式接收下载的数据。
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,jsonBrandErrorHandler);
			urlLoader.addEventListener(Event.COMPLETE,jsonBrandCompleteHandler);
			var sceneCode:String = LivelyLibrary.SceneCode;
			urlLoader.load(new URLRequest("configs/brandinfos/"+LivelyLibrary.SceneCode+"Info.json"));
		}
		
		private function downloadRootNodeJsonByCompanyNameBrandFault(event:FaultEvent):void
		{
			LivelyLibrary.ShowMessage("服务端加载到品牌配置文件错误", 1);
		}
		
		private function jsonBrandCompleteHandler(evt:Event):void
		{
			jsonConfig=JSON.parse(evt.target.data);
			
			jsonWebService.brand = jsonConfig.brand;
			jsonWebService.loading = jsonConfig.loading;
			jsonWebService.banner = jsonConfig.banner;
			jsonWebService.login = jsonConfig.login;
			jsonWebService.quote = jsonConfig.quote;
			jsonWebService.production = jsonConfig.production;
			
			GlobalManager.Instance.serviceMGR.downloadRootNodeJsonByCompanyName(downloadRootNodeJsonByCompanyNameLejiaSucess,downloadRootNodeJsonByCompanyNameLejiaFault,"乐家");
		}
		
		private function downloadRootNodeJsonByCompanyNameLejiaSucess(event:ResultEvent):void
		{
			lejiaJsonWebService=JSON.parse(event.result as String);
			
			if(lejiaJsonWebService.library[0].children.length > 0)
			{
				jsonSortOnHandler(lejiaJsonWebService.library[0].children as Array);
			}
			
			var urlLoader1:URLLoader=new URLLoader();
			urlLoader1.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader1.addEventListener(IOErrorEvent.IO_ERROR,jsonLejiaErrorHandler);
			urlLoader1.addEventListener(Event.COMPLETE,jsonLejiaCompleteHandler);
			urlLoader1.load(new URLRequest("configs/brandinfos/LeJiaInfo.json"));
		}
		
		private function downloadRootNodeJsonByCompanyNameLejiaFault(event:FaultEvent):void
		{
			LivelyLibrary.ShowMessage("服务端加载到乐家文件错误", 1);
		}
		
		private function jsonLejiaCompleteHandler(evt:Event):void
		{
			jsonConfig=JSON.parse(evt.target.data);

			lejiaJsonWebService.brand = jsonConfig.brand;
			lejiaJsonWebService.loading = jsonConfig.loading;
			lejiaJsonWebService.banner = jsonConfig.banner;
			lejiaJsonWebService.login = jsonConfig.login;
			lejiaJsonWebService.quote = jsonConfig.quote;
			lejiaJsonWebService.production = jsonConfig.production;
			
			dispatchEvent(new Event(EventType_AllJSONLoadComplete));
		}
		
		private function jsonBrandErrorHandler(evt:*):void
		{
//			var urlLoader:URLLoader= evt.target as URLLoader;
//			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,jsonBrandErrorHandler);
//			urlLoader.removeEventListener(Event.COMPLETE,jsonBrandCompleteHandler);
//			urlLoader = null;
//			
//			var urlLoader1:URLLoader=new URLLoader();
//			urlLoader1.dataFormat=URLLoaderDataFormat.BINARY;
//			urlLoader1.addEventListener(IOErrorEvent.IO_ERROR,jsonLejiaErrorHandler);
//			urlLoader1.addEventListener(Event.COMPLETE,jsonLejiaCompleteHandler);
//			urlLoader1.load(new URLRequest("configs/brandnodes/LeJiaMerge.json"));
		}
		
		private function jsonLejiaErrorHandler(evt:*):void
		{
//			var urlLoader1:URLLoader= evt.target as URLLoader;
//			urlLoader1.removeEventListener(IOErrorEvent.IO_ERROR,jsonLejiaErrorHandler);
//			urlLoader1.removeEventListener(Event.COMPLETE,jsonLejiaCompleteHandler);
//			urlLoader1 = null;
//			
//			if(lejiaJsonWebService == null)
//			{
//				LivelyLibrary.ShowMessage("没加载到程序配置文件", 1);
//			}
		}
		
		private function jsonSortOnHandler(v:Array):void
		{
			v.sortOn("index",Array.NUMERIC);
			for (var i:int = 0; i < v.length; i++) 
			{
				var arr:Array=v[i].children as Array;
				if(arr.length>0) jsonSortOnHandler(arr);
			}
		}
		
		public function get rootJson():Object
		{
			if(jsonWebService == null)return lejiaJsonWebService;
			return jsonWebService;
		}
		
		public function get loadingJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null)
				{
					return null;
				}
				return lejiaJsonWebService.loading;
			}
			return jsonWebService.loading;
		}
		
		public function get bannerJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null) 
				{
					return null;
				}
				return lejiaJsonWebService.banner;
			}
			return jsonWebService.banner;
		}
		
		public function get loginJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null) 
				{
					return null;
				}
				return lejiaJsonWebService.login;
			}
				
			return jsonWebService.login;
		}
		
		public function get libraryJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null)
				{
					return null;
				}
				return lejiaJsonWebService.library[0];
			}
			return jsonWebService.library[0];
		}
		
		public function get quoteJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null)
				{
					return null;
				}	
				return lejiaJsonWebService.quote;
			}
			return jsonWebService.quote;
		}
		
		public function get productionJson():Object
		{
			if(jsonWebService == null)
			{
				if(lejiaJsonWebService == null)
				{ 
					return null;
				}
					
				return lejiaJsonWebService.production;
			}
			return jsonWebService.production;
		}
		
		public function get lejiaJSON():Object
		{
			return lejiaJsonWebService;
		}
		
		public function get lejiaLibraryJson():Object
		{
			return lejiaJsonWebService.library[0];
		}
		
		public function get rootXML():XML
		{
			return _xml;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		private function loadRootNodeXMLResult(reObj:ResultEvent):void{
			_xml=new XML(reObj.result);
			if (_xml == null) {
				LivelyLibrary.ShowMessage("加载XML，没有数据", 1);
				return;
			}
			_enabled = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loadRootNodeXMLFault(feObj:FaultEvent):void {
			LivelyLibrary.ShowMessage(feObj.fault.toString(), 1);
		}
		
		public static function get instance():L3DRootNode{
			return _instance;
		}
	}
}
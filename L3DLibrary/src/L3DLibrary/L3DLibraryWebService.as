package L3DLibrary
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import spark.components.Alert;
	
	import extension.wl.globalData.allStaticTypes.LivelyType;
	
	public final class L3DLibraryWebService
	{
		private static var webService:WebService = null;
		private static var webServiceEnabled:Boolean = false;
		private static var webHostAddress:String = "";
		public static var webHost:String;
		public static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var lock:Boolean;
		
		public static function get WebServiceEnable():Boolean
		{
			return webServiceEnabled;
		}	
		
		public static function get WebHostAddress():String
		{
			return webHostAddress;
		}
		
		public static function SetupWebService():void
		{			
			//			var webLoader:URLLoader = new URLLoader();
			//			webLoader.addEventListener(Event.COMPLETE, LoadCompletedHandle);
			//			webLoader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
			//			var file:String = "configs/" + LivelyLibrary.SceneCode + "library.xml";
			//			webLoader.load(new URLRequest(file));
			
			webHost = LivelyType.HomePage; //仅在CWallModulesManager中使用一次 18.5.11
			webHostAddress = LivelyType.HomePage; //没有地方使用 18.5.11
			if(!WebServiceEnable)
			{
				webService = new WebService();
				webService.wsdl = LivelyType.LivelyAddress;
				webService.addEventListener(LoadEvent.LOAD, OnWebServiceLoad);
				webService.addEventListener(FaultEvent.FAULT, OnWebServiceFault);
				webService.requestTimeout = 1200;
				webService.loadWSDL();
			}
		}
		
		public static function CurtainSetupWebService(url:String):void
		{
			if(!WebServiceEnable)
			{
				webService = new WebService();
				webService.wsdl = url;
				webService.addEventListener(LoadEvent.LOAD, OnWebServiceLoad);
				webService.addEventListener(FaultEvent.FAULT, OnWebServiceFault);
				webService.requestTimeout = 1200;
				webService.loadWSDL();
			}
		}
		
		private static function IOErrorHandle(event:IOErrorEvent):void
		{
			LivelyLibrary.ShowMessage(event.toString(), 1);
		}
		
		private static function OnWebServiceLoad(e:LoadEvent):void
		{	
			webServiceEnabled = true;
			isOpenAlert = true;
			//liuxin modify 暂时用onlyLogin区别统一登陆
			if(!LivelyLibrary.onlyLogin)
			{
				L3DRootNode.instance.downloadRootNodeXML();
			}
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private static var isOpenAlert:Boolean;
		private static function OnWebServiceFault(e:FaultEvent):void
		{	
//			Alert.show(e.message.toString());
			if(!isOpenAlert)
				Alert.show("网络连接错误，或远端服务器未能响应，请检查网络配置。","",4,null,closeHandler);
			
			isOpenAlert = true;
		}	
		
		private static function closeHandler(event:CloseEvent):void
		{
			isOpenAlert = false;
		}
		
		public static function get LibraryService():WebService
		{
	/*		if(!webServiceEnabled)
			{
				return null;
			}*/			
			return webService;
		}
		
		public static function set LibraryService(value:WebService):void
		{
			webService = value;
		}
		
		public static function newServiceSetup():void
		{
			webServiceEnabled = true;
			//liuxin modify 暂时用onlyLogin区别统一登陆
			if(!LivelyLibrary.onlyLogin)
			{
				L3DRootNode.instance.downloadRootNodeXML();
			}
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
package core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
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
			var webLoader:URLLoader = new URLLoader();
			webLoader.addEventListener(Event.COMPLETE, LoadCompletedHandle);
			webLoader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandle);
//			var file:String = "configs/" + L3DLibrary.L3DLibrary.SceneCode + "library.xml";
			var file:String = "configs/lejialibrary.xml";
			webLoader.load(new URLRequest(file));
		}
		
		private static function LoadCompletedHandle(event:Event):void
		{
			//已经加载成功，无须再加载
			if(lock)
				return;
			lock = true;
			var content:String = event.target.data.toString();
			if(content != null)
			{	
				var configXML:XML = new XML(content);
				if(configXML != null)
				{
					var host:String = configXML.address.@url;
//					var host:String="192.168.1.226:3820";
					if(host == null || host.length == 0)
					{
						host = "www.lejia3d.com:3820";
					}
					webHost = "http://"+host.slice(0,host.length-5)+"/";
					var hostAddress:String = "http://" + host + "/LejiaWebService.asmx?wsdl";
					webHostAddress = host.substring(0,host.length - 5);
					var ip:String = configXML.address.@ip;
					if(ip == null || ip.length == 0) 
					{
						ip = "113.108.168.178:8220";
					}
					ip = "http://"+ip+"/";
					Security.loadPolicyFile(ip + "crossdomain.xml"); 
				//	Security.loadPolicyFile("crossdomain.xml"); 
					
//					L3DLibrary.L3DLibrary.Company = configXML.company.@name;
					webService = new WebService();
					webService.wsdl=hostAddress;
					webService.addEventListener(LoadEvent.LOAD, OnWebServiceLoad);
					webService.addEventListener(FaultEvent.FAULT, OnWebServiceFault);
					webService.requestTimeout = 600;
					webService.loadWSDL();
				}
			}
		}
		
		private static function IOErrorHandle(event:IOErrorEvent):void
		{
			print(event.toString());
//			L3DLibrary.L3DLibrary.ShowMessage(event.toString(), 1);
		}
		
		private static function OnWebServiceLoad(e:LoadEvent):void
		{	
			webServiceEnabled = true;
//			//liuxin modify 暂时用onlyLogin区别统一登陆
//			if(!L3DLibrary.L3DLibrary.onlyLogin)
//			{
//				L3DRootNode.instance.downloadRootNodeXML();
//			}
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private static function OnWebServiceFault(e:FaultEvent):void
		{	
		//	Alert.show(e.message.toString());
		//	Alert.show("网络连接错误，或远端服务器未能响应，请检查网络配置。");
		}	
		
		public static function get LibraryService():WebService
		{
	/*		if(!webServiceEnabled)
			{
				return null;
			}*/			
			return webService;
		}
		
//		public static function newServiceSetup():void
//		{
//			webServiceEnabled = true;
//			//liuxin modify 暂时用onlyLogin区别统一登陆
//			if(!L3DLibrary.L3DLibrary.onlyLogin)
//			{
//				L3DRootNode.instance.downloadRootNodeXML();
//			}
//			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
//		}
	}
}
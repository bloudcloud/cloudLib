package L3DLibrary
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import spark.components.Alert;
	
	import extension.wl.globalData.allStaticTypes.LivelyType;

	public class L3DWebService
	{
		private static var webService:WebService = null;
		private static var webServiceEnabled:Boolean = false;
		private static var webHostAddress:String = "";
		public static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var isOpenAlert:Boolean;
		
		public function L3DWebService()
		{
		}
		
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
			var port:String = LivelyType.LivelyPort;
			webService = new WebService();
			webService.wsdl= "http://www.lejia3d.com:"+port+"/LejiaWebService.asmx?wsdl";
			webService.addEventListener(LoadEvent.LOAD, OnWebServiceLoad);
			webService.addEventListener(FaultEvent.FAULT, OnWebServiceFault);
			webService.requestTimeout = 1200;
			webService.loadWSDL();
		}
		
		protected static function OnWebServiceFault(event:FaultEvent):void
		{
			// TODO Auto-generated method stub
			if(!isOpenAlert)
			Alert.show("网络连接错误，或远端服务器未能响应，请检查网络配置。","",4,null,closeHandler);
			
			isOpenAlert = true;
		}
		
		private static function closeHandler(event:CloseEvent):void
		{
			isOpenAlert = false;
		}
		
		protected static function OnWebServiceLoad(event:LoadEvent):void
		{
			// TODO Auto-generated method stub
			webServiceEnabled = true;
			if(!LivelyLibrary.onlyLogin)
			{
				L3DRootNode.instance.downloadRootNodeXML();
			}
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
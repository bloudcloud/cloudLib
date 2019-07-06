package L3DLibrary
{
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	public class L3DPPTWebService extends EventDispatcher
	{
		private static var webService:WebService;
		private static var pptWebServiceEnabled:Boolean = false;
		
		public function L3DPPTWebService()
		{
		}
		
		public static function SetupWebService():void
		{
			webService = new WebService();
//			webService.wsdl = LivelyType.PptAddress;
			webService.wsdl = "http://www.lejia3d.com:3830/PPTService.asmx?wsdl";
			webService.addEventListener(LoadEvent.LOAD, onWebServiceLoad);
			webService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
			webService.requestTimeout = 6000;
			webService.loadWSDL();
		}
		
		private static function onWebServiceLoad(event:LoadEvent):void
		{
			pptWebServiceEnabled = true;
		}
		
		private static function onWebServiceFault(event:FaultEvent):void
		{
			print(event);
		}
		
		public static function get PPTService():WebService
		{
			return webService;
		}
		
		public static function get PPTWebServiceEnabled():Boolean
		{
			return pptWebServiceEnabled;
		}
	}
}
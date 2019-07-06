package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	
	import spark.components.Alert;
	
	import events.EventExtend;

	public class WebAPIRoomMGR extends EventDispatcher
	{
		private static const Domain:String = "http://125.88.152.119:5000/";
		
		private static const Room:String = "api/v1.0/sizechart/";
		
		private var loader:URLLoader = new URLLoader();
		
		public static const LoadRoomInfo:String = "WebAPIRoomMGR_LoadRoomInfo";
		
		public function WebAPIRoomMGR()
		{
			try
			{
				Security.allowDomain("*")
				Security.allowInsecureDomain("*");
				Security.loadPolicyFile("http://125.88.152.119:5000/crossdomain.xml");
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		public function getRoomVectors(base64:String):void
		{
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var json:Object = {file:base64};
			var jsonString:String = JSON.stringify(json);
			
			var request:URLRequest = new URLRequest();
			request.requestHeaders.push(hdr);
			request.url = Domain+Room;
			request.method = URLRequestMethod.POST;
			request.data = jsonString;
			
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			loader.load(request);
		}
		
		private function completeHandler(event:Event):void
		{
			var result:String = event.target.data as String;
			
			if(result=="No Recognition")
			{
				Alert.show("图像无法识别");
				return;
			}
			var json:Object = JSON.parse(result);
			this.dispatchEvent(new EventExtend(LoadRoomInfo,json));
		}
		
		private function ioerrorHandler(event:IOErrorEvent):void
		{
			Alert.show(event.toString());
		}
	}
}
package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import utils.lx.ListenerExtend;

	public class WebAPIMGR
	{
//		private static const Domain:String = "http://www.lejia3d.com:8086/";
		private static const Domain:String = "http://125.88.152.120:8063/"; //坚美门窗
//		private static const Domain:String = "http://192.168.1.100:8078/";
//		private static const Domain:String = "http://192.168.1.125:8086/";
		private static const ActionRequest:String = Domain+"Gateway/ActionRequest";
		
		private var _token:String;
		
		public function WebAPIMGR()
		{
			Security.loadPolicyFile("http://192.168.1.100/crossdomain.xml");
			orderLogin("13711302700","123456");
		}
		
		/**
		 * 使用订单所有接口前，先调一步
		 * @param user
		 * @param password
		 */		
		private function orderLogin(user:String,password:String):void
		{
			var data:Object = {};
			data.cellPhone = user;
			data.password = password;
			
			var variable:URLVariables = new URLVariables();
			variable.url=Domain+"User/LoginByCellphone";
			variable.token = "";
			variable.body = JSON.stringify(data);
			var request:URLRequest = new URLRequest();
			request.url = ActionRequest;
			request.method = URLRequestMethod.POST;
			request.data = variable;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,orderLoginComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,orderLoginError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,orderLoginHTTPStatus);
			loader.load(request);
		}
		
		private function orderLoginComplete(event:Event):void
		{
			var result:String = event.target.data as String;
			var jsonResult:Object = JSON.parse(result);
			_token = jsonResult.data.token;
		}
		
		private function orderLoginError(event:IOErrorEvent):void
		{
//			L3DAlert.ShowAlertInfo(event.toString(),1);
		}
		
		private function orderLoginHTTPStatus(event:HTTPStatusEvent):void
		{
			switch(event.status)
			{
				case 500:
					break;
			}
		}
		
		private function invoke(url:String,json:String,result:Function,fault:Function):void
		{
			var variable:URLVariables = new URLVariables();
			variable.url=Domain+url;
			variable.token = "BasicAuth "+_token;
			variable.body = json;
			
			var request:URLRequest = new URLRequest(Domain+url);
			request.url = ActionRequest;
			request.method = URLRequestMethod.POST;
			request.data = variable;
			
			var loader:URLLoader = new URLLoader();
			var complete:ListenerExtend = new ListenerExtend();
			loader.addEventListener(Event.COMPLETE,complete.concat(completeHandler,result));
			var error:ListenerExtend = new ListenerExtend();
			loader.addEventListener(IOErrorEvent.IO_ERROR,error.concat(ioerrorHandler,fault));
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			loader.load(request);
		}
		
		private function completeHandler(event:Event,result:Function):void
		{
			if(result!=null)
			{
				result(event);
			}
		}
		
		private function ioerrorHandler(event:IOErrorEvent,fault:Function):void
		{
			if(fault!=null)
			{
				fault(event);
			}
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
//			L3DAlert.ShowAlertInfo(event.toString(),1);
		}
		
		public function get token():String
		{
			return _token;
		}
		
		/**
		 * 创建订单接口
		 * @param result
		 * @param fault
		 * @param json
		 */		
		public function orderCreate(result:Function,fault:Function,json:String):void
		{
			invoke("OriginalOrder/Create",json,result,fault);
		}
		
		public function createMCOrder(result:Function,fault:Function,json:String):void
		{
			invoke("McOrder/Create",json,result,fault);
		}
	}
}
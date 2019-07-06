package preloadconfig
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoginConfig
	{
		private var _urlloader:URLLoader = new URLLoader();
		public var username:String;
		public var password:String;
		private var _hasData:Boolean;
		/**
		 * enable 允许自动登录 true/false
		 */
		public function LoginConfig(enable:Boolean)
		{
			if(!enable)
				return;
			_urlloader.addEventListener(Event.COMPLETE,loaderCompleteHandler);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			var request:URLRequest = new URLRequest("D:/AutoLogin.xml");
			_urlloader.load(request);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			clearListener();
			_hasData = true;
			var xml:XML = XML(event.target.data);
			username = xml.@username;
			password = xml.@password;
		}
		
		private function ioerrorHandler(event:IOErrorEvent):void
		{
			clearListener();
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			clearListener();
		}
		
		private function clearListener():void
		{
			_urlloader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
		}
		
		public function get hasData():Boolean
		{
			return _hasData;
		}
	}
}
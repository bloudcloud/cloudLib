package utils.lx.managers
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;

	public class WebAPIConnector
	{
		private const Domain:String = "http://125.88.152.116:8019/";
		private const ExtendedLoginTime:String = "api/Account/ExtendedLoginTime";
		private var timer:Timer = new Timer(60000, 0);
		private var token:String;
		private var loader:URLLoader = new URLLoader();
		
		public function WebAPIConnector()
		{
			
		}
		
		public function start(token:String):void
		{
			if(token==null || token.length==0)
			{
				return;
			}
			this.token = token;
			
			loader.addEventListener(Event.COMPLETE,connectComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,connectIOError);
			timer.addEventListener(TimerEvent.TIMER, timerComplete);
			timer.start();
		}
		
		private function timerComplete(event:TimerEvent):void
		{
			var variable:URLVariables = new URLVariables();
			variable.token = token;
			var request:URLRequest = new URLRequest();
			request.url = Domain+ExtendedLoginTime;
			request.method = URLRequestMethod.POST;
			request.data = variable;
			
			loader.load(request);
		}
		
		private function connectComplete(event:Event):void
		{
		}
		
		private function connectIOError(event:IOErrorEvent):void
		{
		}
	}
}
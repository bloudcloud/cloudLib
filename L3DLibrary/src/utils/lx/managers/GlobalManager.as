package utils.lx.managers 
{
	import flash.events.EventDispatcher;
	
	import spark.components.Application;
	
	import logs.Log;
	
	import utils.lx.views.DebugLogin;
	import utils.lx.views.DebugTrackView;
	

	public class GlobalManager extends EventDispatcher
	{
		private static var _Instance:GlobalManager;
		private static var _sunRoomDispatcher:GlobalManager;
		public static var application:Application;
		private static var _debugLogin:DebugLogin = new DebugLogin();
		private static var _debugTrackView:DebugTrackView=new DebugTrackView();
		private static var _log:Log = new Log(_debugTrackView);
		
		public static var enablePrint:Boolean = true;
		
		public static function get Instance():GlobalManager
		{
			return _Instance||=new GlobalManager();
		}
		
		public static function get sunRoomDispatcher():GlobalManager
		{
			return _Instance||=new GlobalManager();
		}
		
		public static function get debugTrackView():DebugTrackView
		{
			return _debugTrackView;
		}
		
		public static function get debugLogin():DebugLogin
		{
			return _debugLogin;
		}
		
		public static function get log():Log
		{
			return _log;
		}
		
		private var _loaderMGR:LibraryLoaderMGR = new LibraryLoaderMGR();
		private var _resourceMGR:LibraryResouceMGR = new LibraryResouceMGR();
		private var _serviceMGR:ServiceMGR = new ServiceMGR();
		private var _statusMGR:StatusMGR = new StatusMGR();
		private var _localStorageMGR:LocalStorageMGR = new LocalStorageMGR();
		private var _webAPIMGR:WebAPIMGR = new WebAPIMGR();
		private var _webAPIUserMGR:WebAPIUserMGR = new WebAPIUserMGR();
		private var _webAPIRoomMGR:WebAPIRoomMGR = new WebAPIRoomMGR();
		private var _autoSaveMGR:AutoSaveMGR = new AutoSaveMGR();
		private var _webAPIConnector:WebAPIConnector = new WebAPIConnector();
		
		public function GlobalManager()
		{
		}
		
		public function get webAPIConnector():WebAPIConnector
		{
			return _webAPIConnector;
		}
		
		public function get resourceMGR():LibraryResouceMGR
		{
			return _resourceMGR;
		}
		
		public function get loaderMGR():LibraryLoaderMGR
		{
			return _loaderMGR;
		}
		
		public function get serviceMGR():ServiceMGR
		{
			return _serviceMGR;
		}
		
		public function get statusMGR():StatusMGR
		{
			return _statusMGR;
		}
		
//		public function getLoadResource(path:String,type:int,successCallback:Function=null,faultCallback:Function=null):*
//		{
//			if(_resourceMGR.hasInformation(path) && successCallback!=null)
//			{
//				successCallback.apply(null,[path,_resourceMGR.getInformation(path)]);
//			}
//			else
//			{
//				_loaderMGR.excuteRPCL3DMaterialInformationTask(path,type,successCallback,faultCallback,0);
//				
//			}
//		}
		public function get shareobejctMGR():LocalStorageMGR
		{
			return _localStorageMGR;
		}
		
		public function get webAPIMGR():WebAPIMGR
		{
			return _webAPIMGR;
		}
		
		public function get webAPIUserMGR():WebAPIUserMGR 
		{
			return _webAPIUserMGR;
		}
		
		public function get webAPIRoomMGR():WebAPIRoomMGR
		{
			return _webAPIRoomMGR;
		}
		
		/**
		 * 清理GPU内存 
		 */		
		public function disposeGPUCache():void
		{
			_resourceMGR.disposeGPURAM();
		}
	}
}
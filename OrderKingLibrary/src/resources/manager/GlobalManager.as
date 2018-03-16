package resources.manager
	
{
	import flash.events.EventDispatcher;
	import resources.loader.LibraryLoaderMGR;
	

	public class GlobalManager extends EventDispatcher
	{
		private static var _Instance:GlobalManager;
		
		public static function get Instance():GlobalManager
		{
			return _Instance||=new GlobalManager();
		}
		
		private var _loaderMGR:LibraryLoaderMGR = new LibraryLoaderMGR();
		private var _resourceMGR:LibraryResouceMGR = new LibraryResouceMGR();
		private var _serviceMGR:ServiceMGR = new ServiceMGR();
		private var _statusMGR:StatusMGR = new StatusMGR();
		private var _localStorageMGR:LocalStorageMGR = new LocalStorageMGR();
		private var _webAPIMGR:WebAPIMGR = new WebAPIMGR();
		
		public static var enablePrint:Boolean = false;
		
		public function GlobalManager()
		{
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
		
		/**
		 * 清理GPU内存 
		 */		
		public function disposeGPUCache():void
		{
			_resourceMGR.disposeGPURAM();
		}
	}
}
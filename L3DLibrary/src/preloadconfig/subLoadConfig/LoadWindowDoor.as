package preloadconfig.subLoadConfig
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import L3DLibrary.LivelyLibrary;
	
	import preloadconfig.subDataParse.DataParseWindowDoor;

	public class LoadWindowDoor
	{
		private var urlloader:URLLoader=new URLLoader();

		private var company:String;

		private var dataParseWindowDoor:DataParseWindowDoor;
		private static var isInit:Boolean;
		private var _isLoadComplete:Boolean;
		public function LoadWindowDoor(dataParse:DataParseWindowDoor)
		{
			if(isInit){
				throw new Error("LoadWindowDoor仅有唯一实例");
			}
			dataParseWindowDoor = dataParse;
			company=LivelyLibrary.SceneCode;
			urlloader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
			urlloader.load(new URLRequest("configs/paramWindowDoor/" + company + ".xml"));
		}

		private function loaderCompleteHandler(event:Event):void
		{
			urlloader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
			var xml:XML=XML(event.target.data);
			urlloader.close();
			_isLoadComplete = true;
			dataParseWindowDoor.initParseBrand(xml);
		}

		private function ioerrorHandler(event:IOErrorEvent):void
		{
			var noitsload:URLLoader=new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler1);
			noitsload.load(new URLRequest("configs/paramWindowDoor/ymyg.xml"));
		}

		private function ioerrorHandler1(evt:IOErrorEvent):void
		{
		}
		
		public function get isLoadComplete():Boolean
		{
			return _isLoadComplete;
		}
	}
}

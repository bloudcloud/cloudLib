package extension.wl.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class SaveUtils extends EventDispatcher
	{
		public var saveType:int = BYTE_TYPE;
		public static const BYTE_TYPE:int = 0;
		public static const URL_TYPE:int = 1;
		public static const STRING_TYPE:int = 2;
		
		public var saveString:String = "";
		public var saveBytes:ByteArray = null;
		public var saveUrl:String = "";
		public var saveName:String = "";
		
		private var fileReference:FileReference = null;
		
		public function SaveUtils()
		{
			
		}
		
		public function saveHandler():void
		{
			if(!fileReference)
			{
				fileReference = new FileReference();
				fileReference.addEventListener(Event.COMPLETE,saveCompleteHandler);
				fileReference.addEventListener(Event.CANCEL,fileCancelHandler);
			}
			
			switch(saveType)
			{
				case BYTE_TYPE:
					fileReference.save(saveBytes,saveName);
					break;
				case URL_TYPE:
					fileReference.download(new URLRequest(saveUrl),saveName);
					break;
				case STRING_TYPE:
					fileReference.save(saveString,saveName);
					break;
			}
		}
		
		private function saveCompleteHandler(event:Event):void
		{
			fileCancelHandler(event);
		}
		
		private function fileCancelHandler(event:Event):void
		{
			if(fileReference)
			{
				fileReference.removeEventListener(Event.COMPLETE,saveCompleteHandler);
				fileReference.removeEventListener(Event.CANCEL,fileCancelHandler);
				fileReference = null;
			}
		}
		
	}
}
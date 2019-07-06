package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import L3DLibrary.L3DLibraryEvent;
	
	import utils.Base64;

	public class L3DBitmap extends EventDispatcher
	{
		public var userData:* = null;
		
		public function L3DBitmap()
		{
			
		}
		
		public static function BitmapDataToXML(bitmapData:BitmapData):XML
		{
			if(bitmapData == null || bitmapData.width == 0 || bitmapData.height == 0)
			{
				return null;
			}
			
			var buffer:ByteArray = L3DMaterial.BitmapDataToBuffer(bitmapData, 100);
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			
			buffer.position = 0;
			
			var xml:XML = new XML();
			xml = <BitmapData num ={buffer.length}> </BitmapData>;
			
			var bv:String = Base64.encodeByteArray(buffer);
			var bxml = <ByteData value = {bv}></ByteData>;
			xml = xml.appendChild(bxml);
		/*	while(buffer.bytesAvailable>0)  
			{  
				var byteData:int = buffer.readByte();
				var bxml = <ByteData value = {byteData}></ByteData>;
				xml = xml.appendChild(bxml); 
			} */ 

		/*	for(var i:int = 0; i< buffer.length; i++ )	
			{
				var byteData:int = buffer.readByte();
				var bxml = <ByteData value = {byteData}></ByteData>;
				xml = xml.appendChild(bxml);
			} */
			
			return xml;
		}
		
		public function LoadBitmapDataFromXML(xml:XML):void
		{
			if(xml == null || xml.@num == null || xml.@num == 0)
			{
				return;
			}
			
			var bv:String = xml.ByteData.@value.toString();
			if(bv == null || bv.length == 0)
			{
				return;
			}
			
			var buffer:ByteArray = Base64.decodeToByteArray(bv);
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
	/*		var count:int = xml.ByteData.length();
			for(var i:int = 0; i< count; i++ )	
			{
				var byteData:int = int(xml.ByteData[i].@value);
				buffer.writeByte(byteData);
			} */
			
			buffer.position = 0;
			
			var loader:Loader = new Loader();
			loader.loadBytes(buffer);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderBitmapComplete);	
		}
		
		private function loaderBitmapComplete(event:Event):void
		{
			//cloud 2017.12.25
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			var checkBitmap:BitmapData=(loaderInfo.content as Bitmap).bitmapData.clone();
//			var checkBitmap:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
//			checkBitmap.draw(loaderInfo.loader);	
			loaderInfo.loader.unloadAndStop();
			
			if(checkBitmap == null)
			{
				return;
			}
			
			var evt:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.LoadComplete);
			evt.PreviewBitmap = checkBitmap;
			this.dispatchEvent(evt);
		}
	}
}
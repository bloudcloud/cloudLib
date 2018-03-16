package core.events 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.datas.L3DMaterialInformations;
	
	public class L3DLibraryEvent extends Event
	{
		public static const LoadRootXML:String = "LoadRootXML"; 
		public static const LoadNodeXML:String = "LoadNodeXML"; 
		public static const DownloadMaterial:String = "DownloadMaterial";
		public static const DownloadTopview:String = "DownloadTopview";
		public static const DownloadMaterialInfo:String = "DownloadMaterialInfo";
		public static const LoadPreview:String = "LoadPreview";
		public static const LoadComplete:String = "LoadComplete";
		
		private var rootXML:XML = null;
		private var nodeXML:XML = null;
		private var materialBuffer:ByteArray = null;
		private var materialType:int = 0;
	    private var previewBitmap:BitmapData = null;
		private var materialInformation:L3DMaterialInformations = null;
		public var data:*;
		public var data2:*;
		public var data3:*;
		public var data4:*;
		public var data5:*;
		public var data6:*;
		public var data7:*;
		public var data8:*;
		public var data9:*;
		
		public function L3DLibraryEvent(code:String)
		{
			super(code);
		}
		
		public function get RootXML():XML
		{
			return rootXML;
		}
		
		public function set RootXML(v:XML):void
		{
			rootXML = v;
		}
		
		public function get NodeXML():XML
		{
			return nodeXML;
		}
		
		public function set NodeXML(v:XML):void
		{
			nodeXML = v;
		}
		
		public function get MaterialBuffer():ByteArray
		{
		    return materialBuffer;	
		}
		
		public function set MaterialBuffer(v:ByteArray):void
		{
			materialBuffer = v;	
		}
		
		public function get MaterialType():int
		{
			return materialType;
		}
		
		public function set MaterialType(v:int):void
		{
			materialType = v;
		}
		
		public function get PreviewBitmap():BitmapData
		{
			return previewBitmap;
		}
		
		public function set PreviewBitmap(v:BitmapData):void
		{
			previewBitmap = v;
		}
		
		public function get MaterialInformation():L3DMaterialInformations
		{
			return materialInformation;
		}
		
		public function set MaterialInformation(v:L3DMaterialInformations):void
		{
			materialInformation = v;
		}
	}
}
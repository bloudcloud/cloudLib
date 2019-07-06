package L3DLibrary
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class L3DLibraryEvent extends Event
	{
		public static const LoadRootXML:String = "LoadRootXML"; 
		public static const LoadNodeXML:String = "LoadNodeXML"; 
		public static const DownloadMaterial:String = "DownloadMaterial";
		public static const DownloadTopview:String = "DownloadTopview";
		public static const DownloadMaterialInfo:String = "DownloadMaterialInfo";
		public static const LoadPreview:String = "LoadPreview";
		public static const LOAD_TEXTURE_BITMAPDATA:String="LoadTextureBitmapdata";
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
		
		public function clear():void
		{
			rootXML=null;
			nodeXML=null;
			materialBuffer=null;
			materialInformation=null;
			data=null;
			data2=null;
			data3=null;
			data4=null;
			data5=null;
			data6=null;
			data7=null;
			data8=null;
			data9=null;
		}
		
		override public function clone():Event
		{
			var evt:L3DLibraryEvent=new L3DLibraryEvent(type);
			evt.RootXML=rootXML;
			evt.NodeXML=nodeXML;
			evt.MaterialBuffer=materialBuffer;
			evt.PreviewBitmap=previewBitmap;
			evt.MaterialInformation=materialInformation;
			evt.data=data;
			evt.data2=data2;
			evt.data3=data3;
			evt.data4=data4;
			evt.data5=data5;
			evt.data6=data6;
			evt.data7=data7;
			evt.data8=data8;
			evt.data9=data9;
			return evt;
		}
	}
}
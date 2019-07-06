package extension.wl.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class BrowseUtils extends EventDispatcher
	{
		private var fileToLoad:FileReference = null;
		private var browseData:ByteArray = null;
		
		public static const BROWSE_EVENT:String = "browse_event";
		
		public function BrowseUtils()
		{
			
		}
		/**
		 * 浏览本地文件并加载
		 * @param args 需要加载文件类型的后缀，不需要点。如"jpg","png"
		 * 
		 */		
		public function browseHandler(... args):void
		{
			var description:String="";
			var extension:String="";
			for(var i:int=0;i<args.length;i++)
			{
				description+="*."+args[i];
				extension+="*."+args[i]+";"+"*."+args[i].toString().toLocaleUpperCase()+";";
			}
			var mediaFilter:FileFilter=new FileFilter(description,extension);
			
			fileToLoad=new FileReference();
			fileToLoad.addEventListener(Event.SELECT,selectHandler);
			fileToLoad.addEventListener(Event.CANCEL,cancelHandler);
			fileToLoad.browse([mediaFilter]);
		}
		
		public function browseCAD():void
		{
			fileToLoad = new FileReference();
			fileToLoad.addEventListener(Event.SELECT,selectHandler);
			fileToLoad.addEventListener(Event.CANCEL,cancelHandler);
			fileToLoad.browse([new FileFilter("CAD文件(*.dwg, *.dxf)","*.dwg; *.dxf")]);
		}
		
		/**
		 * 浏览本地图片文件并加载 
		 * jpg;jpeg;bmp;png
		 * 
		 */		
		public function browseImages():void
		{
			fileToLoad=new FileReference();
			fileToLoad.addEventListener(Event.SELECT,selectHandler);
			fileToLoad.addEventListener(Event.CANCEL,cancelHandler);
			fileToLoad.browse([new FileFilter("Images(*.jpg, *.jpeg, *.bmp, *.png)","*.jpg;, *.jpeg;, *.bmp; *.png")]);
		}
		/**
		 * 浏览本地xml文件并加载 
		 * xml;xmls
		 * 
		 */		
		public function browseXMLs():void
		{
			fileToLoad=new FileReference();
			fileToLoad.addEventListener(Event.SELECT,selectHandler);
			fileToLoad.addEventListener(Event.CANCEL,cancelHandler);
			fileToLoad.browse([new FileFilter("xml(*.xml, *.xmls;)","*.xml; *.xmls;")]);
		}
		/**
		 * 浏览本地txt文件并加载 
		 * txt
		 * 
		 */		
		public function browseTxt():void
		{
			fileToLoad=new FileReference();
			fileToLoad.addEventListener(Event.SELECT,selectHandler);
			fileToLoad.addEventListener(Event.CANCEL,cancelHandler);
			fileToLoad.browse([new FileFilter("txt(*.txt)","*.txt;")]);
		}
		
		private function cancelHandler(evt:Event):void
		{
			fileToLoad.removeEventListener(Event.SELECT,selectHandler);
			fileToLoad.removeEventListener(Event.CANCEL,cancelHandler);
			fileToLoad = null;
		}
		
		private function selectHandler(evt:Event):void
		{
			fileToLoad.removeEventListener(Event.SELECT,selectHandler);
			fileToLoad.removeEventListener(Event.CANCEL,cancelHandler);
			
			fileToLoad.addEventListener(Event.COMPLETE,onloadComplete);
			fileToLoad.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandle);
			fileToLoad.load();
		}
		
		private function onErrorHandle(evt:*):void
		{
			fileToLoad.removeEventListener(Event.COMPLETE,onloadComplete);
			fileToLoad.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandle);
			
			this.dispatchEvent(new Event(BROWSE_EVENT));
		}
		
		private function onloadComplete(evt:Event):void
		{
			fileToLoad.removeEventListener(Event.COMPLETE,onloadComplete);
			fileToLoad.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandle);
			browseData = fileToLoad.data;
			
			this.dispatchEvent(new Event(BROWSE_EVENT));
		}
		
		public function get browseByteArray():ByteArray
		{
			return browseData;
		}
		
		public function get browseXML():XML
		{
			if(browseData)
			{
				return new XML(browseData.toString());
			}
			return null;
		}
		
		public function get browseString():String
		{
			if(browseData)
			{
				return browseData.readMultiByte(browseData.length,"utf-8");
			}
			return null;
		}
		
	}
}
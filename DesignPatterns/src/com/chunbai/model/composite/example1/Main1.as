package com.chunbai.model.composite.example1
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Main1 extends Sprite
	{
		private var _fileSystem:Directory;
		private var _itemViews:Array;
		
		public function Main1()
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadXmlHandler);
			loader.load(new URLRequest("D:/workSpace/as3/ZzModel/src/com/chunbai/model/composite/example1/fileSystem.xml"));
			_fileSystem = new Directory();
			_fileSystem.setName("File System");
			_fileSystem.setParent(null);
			_itemViews = new Array();
		}
		
		private function onLoadXmlHandler(event:Event):void
		{
		    XML.ignoreWhitespace = true;
			var xml:XML = new XML(event.target.data);
			parseXmlToFileSystem(xml.children(), _fileSystem);
			updateView(_fileSystem);
		}
		
		private function updateView($directory:Directory):void
		{
		    var i:int = 0;
			var n:int = _itemViews.length;
			for(i; i < n; i++)
			{
			    this.removeChild(_itemViews[i]);
				delete _itemViews[i];
			}
			
			_itemViews = new Array();
			var iterator:IIterator = $directory.iterator();
			var itemY:Number = 0;
			var item:IFileSystemItem;
			var view:FileSystemItemView;
			if($directory.getParent() != null)
			{
			    view = new FileSystemItemView($directory.getParent());
				view.overrideLabel("Parent Directory");
				view.addEventListener(MouseEvent.CLICK, onClickHandler);
				this.addChild(view);
				_itemViews.push(view);
				itemY += view.height + 5;
			}
			while(iterator.hasNext())
			{
			    item = IFileSystemItem(iterator.next());
				view = new FileSystemItemView(item);
				view.y = itemY;
				itemY += view.height + 5;
				if(item is Directory)
				{
				    view.addEventListener(MouseEvent.CLICK, onClickHandler);
				}
				this.addChild(view);
				_itemViews.push(view);
			}
		}
		
		private function parseXmlToFileSystem($xml:XMLList, $directory:Directory):void
		{
		    var i:int = 0;
			var item:AbstractFileSystemItem;
			var n:int = $xml.length();
			for(i; i < n; i++)
			{
			    if($xml[i].@type == "Directory")
				{
				    item = new Directory();
					parseXmlToFileSystem($xml[i].children(), Directory(item));
				}
				else
				{
				    item = new File();
				}
				item.setParent($directory);
				item.setName($xml[i].@name);
				$directory.addItem(item);
			}
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
		    updateView(Directory(event.currentTarget.data));
		}
		
	}
}
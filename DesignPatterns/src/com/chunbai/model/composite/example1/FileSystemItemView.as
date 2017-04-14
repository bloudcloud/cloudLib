package com.chunbai.model.composite.example1
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class FileSystemItemView extends Sprite
	{
		private var _item:IFileSystemItem;
		private var _icon:Sprite;
		private var _label:TextField;
		
		public function FileSystemItemView($item:IFileSystemItem)
		{
			_item = $item;
			_icon = new Sprite();
			if($item is Directory)
			{
			    _icon.graphics.lineStyle();
				_icon.graphics.beginFill(0xFFFF00);
				_icon.graphics.drawRect(0, 10, 50, 30);
				_icon.graphics.endFill();
				_icon.graphics.beginFill(0xFFFF00);
				_icon.graphics.drawRoundRect(0, 0, 25, 15, 5, 5);
				_icon.graphics.endFill();
				_icon.filters = [new BevelFilter];
			}
			else
			{
			    _icon.graphics.lineStyle(0, 0x000000, 1);
				_icon.graphics.beginFill(0xFFFFFF);
				_icon.graphics.drawRect(0, 0, 40, 50);
				_icon.graphics.endFill();
			}
			this.addChild(_icon);
			
			_label = new TextField();
			_label.text = _item.getName();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.x = 50;
			this.addChild(_label);
		}
		
		public function get data():IFileSystemItem
		{
		    return _item;
		}
		
		public function overrideLabel($value:String):void
		{
		    _label.text = $value;
		}
		
	}
}
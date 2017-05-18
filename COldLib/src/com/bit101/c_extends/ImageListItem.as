package com.bit101.c_extends
{
	/**
	 * ClassName: package com.bit101.charts::ImageListItem
	 *
	 * Intro:
	 *
	 * @date: 2014-8-12
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	import com.bit101.components.ListItem;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	public class ImageListItem extends ListItem
	{
		private var _image:Bitmap;
		private var _path:String;
		private var _imageSize:int;
		
		public function ImageListItem(imageSize:int,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object=null)
		{
			_imageSize = imageSize;
			_path = data.path;
			super(parent, xpos, ypos, data);
		}
		override protected function init():void
		{
			super.init();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			//			setSize(100+_imageSize, _imageSize);
		}
		override protected function addChildren():void
		{
			super.addChildren();
			_label.textField.autoSize = TextFieldAutoSize.CENTER;
			loadImage();
		}
		
		private function loadImage():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(evt:Event):void
			{
				evt.currentTarget.removeEventListener(evt.type,arguments.callee);
				_image = evt.currentTarget.content;
				_image.scaleX = _imageSize / _image.width;
				_image.scaleY = _imageSize / _image.height;
				_image.x = _width-_imageSize;
				addChild(_image);
				loader.unload();
			});
			loader.load(new URLRequest(_path));
		}
		override public function draw():void
		{
			super.draw();
			if(_path != _data.path)
			{
				if(_image.parent)
					removeChild(_image);
				_path = _data.path;
				loadImage();
			}
			
			
		}
		public function setLabelSize(width:Number,height:Number):void
		{
			_label.width = width;
			_label.height = height;
		}
	}
}
import com.bit101.charts;


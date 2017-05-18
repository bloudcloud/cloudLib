package com.cloud.c2d.cBitmapEngine.elements
{
	/**
	 * Classname : public class CDisplay extends EventDispatcher implements IDisplay
	 * 
	 * Date : 2013-8-23
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	import com.cloud.c2d.cBitmapEngine.interfaces.IDisplay;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 实现功能: 
	 * 
	 */
	public class CDisplay extends EventDispatcher implements IDisplay
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		protected var _parent:CDisplayContainer;
		protected var _mouseEnabled:Boolean;
		protected var _alpha:Number;
		protected var _viewBitmap:Bitmap;
		private var _bitmapInfo:BitmapFrameInfo;
		
		public function CDisplay($bitmapInfo:BitmapFrameInfo, $width:int, $height:int, $target:IEventDispatcher=null)
		{
			_bitmapInfo = $bitmapInfo;
			_width = $width;
			_height = $height;
			super($target);
			_viewBitmap = new Bitmap();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		protected function onAdded(evt:Event = null):void
		{
			
		}
		protected function onRemoved(evt:Event = null):void
		{
			dispose();
		}
		/**
		 * 渲染 
		 * 
		 */		
		public function render():void
		{
			if(_bitmapInfo)
			{
				_viewBitmap.bitmapData = bitmapInfo.bitmapData;
				_width = _viewBitmap.width;
				_height = _viewBitmap.height;
				x = bitmapInfo.x;
				y = bitmapInfo.y;
			}
		}
		/**
		 * 释放 
		 * 
		 */		
		public function dispose():void
		{
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			_viewBitmap.x = _x;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			_viewBitmap.y = _y;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get parent():CDisplayContainer
		{
			return _parent;
		}

		public function set parent(value:CDisplayContainer):void
		{
			_parent = value;
		}

		public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}

		public function set mouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get bitmapInfo():BitmapFrameInfo
		{
			return _bitmapInfo;
		}
		
		public function set bitmapInfo(value:BitmapFrameInfo):void
		{
			if(value == _bitmapInfo) return;
			_bitmapInfo = value;
			render();
		}

	}
}
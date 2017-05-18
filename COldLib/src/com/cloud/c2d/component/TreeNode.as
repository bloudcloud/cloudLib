package com.cloud.c2d.component
{
	/**
	 * ClassName: package com.bit101.c_extends::TreeNode
	 *
	 * Intro:	树组件节点
	 *
	 * @date: 2014-6-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TreeNode extends Component
	{
		protected var _title:String;
		protected var _titleBar:Panel;
		protected var _titleLabel:Label;
		protected var _panel:Panel;
		protected var _nextNode:TreeNode;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _tweenTime:int;
		/**
		 * 展开按钮样式 
		 */		
		protected var _minimizeButton:Sprite;
		/**
		 * 当前节点是否展开 
		 */		
		protected var _minimized:Boolean = false;
		
		public function TreeNode(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="")
		{
			_title = title;
			super(parent, xpos, ypos);
		}
		
		override protected function addChildren():void
		{
			_titleBar = new Panel();
			_titleBar.filters = [];
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_titleBar.height = 20;
			super.addChild(_titleBar);
			_titleLabel = new Label(_titleBar.content, 5, 1, _title);
			
			_panel = new Panel(null, 0, 20);
			_panel.visible = !_minimized;
			super.addChild(_panel);
			
			_minimizeButton = new Sprite();
			_minimizeButton.graphics.beginFill(0, 0);
			_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
			_minimizeButton.graphics.endFill();
			_minimizeButton.graphics.beginFill(0, .35);
			_minimizeButton.graphics.moveTo(-5, -3);
			_minimizeButton.graphics.lineTo(5, -3);
			_minimizeButton.graphics.lineTo(0, 4);
			_minimizeButton.graphics.lineTo(-5, -3);
			_minimizeButton.graphics.endFill();
			_minimizeButton.x = 10;
			_minimizeButton.y = 10;
			_minimizeButton.useHandCursor = true;
			_minimizeButton.buttonMode = true;
			_titleBar.addChild(_minimizeButton);
			
			filters = [getShadow(4, false)];
			
			setSize(100,100);
		}
		protected function onMouseGoDown(event:MouseEvent):void
		{
			minimized = !minimized;
			dispatchEvent(new Event(Event.SELECT));
		}

		/**
		 * 将对象添加到面板中
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			_panel.content.addChild(child);
			return child;
		}
		
		/**
		 * 将对象添加到面板外
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		/**
		 * 渲染 
		 * 
		 */		
		override public function draw():void
		{
			super.draw();
			_titleBar.color = _color;
			_panel.color = _color;
			_titleBar.width = width;
			_titleBar.draw();
			_titleLabel.x = 20;
			_panel.setSize(_width, _height - 20);
			_panel.draw();
		}
		
		/**
		 * 设置投影
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(4, false)];
			}
			else
			{
				filters = [];
			}
		}
		/**
		 * 获取投影 
		 * @return Boolean
		 * 
		 */		
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/**
		 * 获取/设置背景和面板的颜色
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}
		
		/**
		 * 获取面板实例
		 * @return Sprite
		 * 
		 */		
		public function get content():Sprite
		{
			return _panel.content;
		}
		
		/**
		 * 获取/设置标题
		 */
		public function set title(t:String):void
		{
			_title = t;
			_titleLabel.text = _title;
		}
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * 获取/设置节点是否展开
		 */
		public function set minimized(value:Boolean):void
		{
			if(_minimized == value) return;
			_minimized = value;
			if(_minimized)
			{
				if(_panel.parent) removeChild(_panel);
				_minimizeButton.rotation = -90;
			}
			else
			{
				if(!contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get minimized():Boolean
		{
			return _minimized;
		}
		
		/**
		 *  获取节点的高度
		 */
		override public function get height():Number
		{
			if(_panel.parent)
			{
				return super.height;
			}
			else
			{
				return 20;
			}
		}
		
		/**
		 * 获取/设置标题面板实例
		 */
		public function get titleBar():Panel
		{
			return _titleBar;
		}
		public function set titleBar(value:Panel):void
		{
			_titleBar = value;
		}
	}
}
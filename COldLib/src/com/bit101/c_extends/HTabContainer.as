package com.bit101.c_extends
{
	/**
	 * ClassName: package com.bit101.c_extends::HTabContainer
	 *
	 * Intro:
	 *
	 * @date: 2014-8-18
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="changeTab", type="flash.events.Event")]
	public class HTabContainer extends Component
	{
		private var _contentPanel:Panel;
		private var _tabs:Vector.<TabButton>;
		private var _datas:Array;
		private var _spacing:Number = 0;
		private var _currentTab:TabButton;
		private var _components:Array;
		
		public function get index():int
		{
			return _currentTab.index;
		}
		
		public function get spacing():Number
		{
			return _spacing;
		}
		public function set spacing(value:Number):void
		{
			_spacing = value;
			invalidate();
		}

		override public function set width(w:Number):void
		{
			_contentPanel.width = w;
			super.width = w;
		}
		
		override public function set height(h:Number):void
		{
			_contentPanel.height = h;
			super.height = h;
		}
		
		public function HTabContainer(datas:Array,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			_datas = datas;
			_tabs = new Vector.<TabButton>(_datas.length);
			_components = new Array(_datas.length);
			for(var i:int=0; i<_components.length; i++)
			{
				_components[i] = new Array();
			}
			super(parent, xpos, ypos);
			
		}

		private function changeTabHandler(evt:MouseEvent):void
		{
			if(evt.currentTarget == _currentTab) return;
			_currentTab.selected = false;
			changeDisplay(false,_currentTab.index);
			_currentTab = evt.currentTarget as TabButton;
			changeDisplay(true,_currentTab.index);
			dispatchEvent(new Event("changeTab"));
		}
		
		private function changeDisplay(display:Boolean,index:int):void
		{
			for(var i:int=0; i<_components[index].length; i++)
			{
				if(display)
					_contentPanel.addRawChild(_components[index][i]);
				else
					_contentPanel.removeChild(_components[index][i]);
			}
		}
		override protected function addChildren():void
		{
			_contentPanel = new Panel(this,0,0);
			
			var label:TabButton;
			for(var i:int=0; i<_datas.length; i++)
			{
				label = new TabButton(_contentPanel,0,0,_datas[i],changeTabHandler);
				label.index = i;
				_tabs[i] = label;
			}
			_currentTab = _tabs[0];
			_currentTab.selected = true;
		}
		
		public function addComponent(component:Component,index:int):void
		{
//			if(_components[index] == null)
//				_components[index] = new Array();
			_components[index].push(component);
			_contentPanel.addRawChild(component);
		}
		
		public function removeComponent(component:Component):void
		{
			_contentPanel.removeChild(component);
			var index:int;
			for(var i:int=0; i<_components.length; i++)
			{
				index = _components[i].indexOf(component);
				if(index > -1) break;
			}
			_components[i].splice(index,1);
		}
		
		public function invalidate():void
		{
			for(var i:int=0; i<_components.length; i++)
			{
				if(i != _currentTab.index)
				{
					changeDisplay(false,i);
				}
			}
		}
		override public function draw() : void
		{
			var xpos:Number = 0;
			var tab:TabButton;
			var num:int = _tabs.length;
			for(var i:int = 0; i < num; i++)
			{
				_tabs[i].width = int(_width/num)-_spacing;
				_tabs[i].x = xpos;
				xpos += _tabs[i].width;
				xpos += _spacing;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			_contentPanel.setSize(w,h);
			super.setSize(w,h);
		}
	}
}

package com.bit101.c_extends
{
	/**
	 * ClassName: package ui::HPropertySetComponent
	 *
	 * Intro:	水平属性设置控件
	 *
	 * @date: 2014-7-16
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	[Event(name="inputChange", type="flash.events.Event")]
	public final class HPropertySetComponent extends Component
	{
		private var _label:Label;
		/**
		 * 属性值输入栏 
		 */		
		private var _input:InputText;
		private var _up:PushButton;
		private var _down:PushButton;
		/**
		 * 属性名 
		 */		
		private var _text:String;
		private var _isUp:Boolean;
		private var _isDown:Boolean;

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if(_text == value) return;
			_text = value;
			_label.text = value;
		}
		/**
		 * 数值改变的步长 
		 */		
		private var _numStep:Number;

		public function get numStep():Number
		{
			return _numStep;
		}

		public function set numStep(value:Number):void
		{
			_numStep = value;
		}
		
		private var _value:Number;
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			_value = v;
			_input.text = v.toFixed(_fixNum);
		}
		
		private var _fixNum:int;
		
		public function HPropertySetComponent(nstr:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,fixNum:int=3)
		{
			_text = nstr;
			_numStep = 0;
			_fixNum = fixNum;
			super(parent, xpos, ypos);
		}
		
		private function onKeyUp(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.ENTER:
					_input.text = _value.toFixed(_fixNum);
					this.dispatchEvent(new Event("inputChange"));
					break;
			}
		}
		
		private function upMouseDown(evt:MouseEvent):void
		{
			_isUp = true;
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		private function upMouseUp(evt:MouseEvent):void
		{
			_isUp = false;
			this.removeEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		private function downMouseDown(evt:MouseEvent):void
		{
			_isDown = true;
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		private function dowMouseUp(evt:MouseEvent):void
		{
			_isDown = false;
			this.removeEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		private function onUpdate(evt:Event):void
		{
			if(_isUp)
			{
				_value+=numStep;
				_input.text = _value.toFixed(_fixNum);
				this.dispatchEvent(new Event("inputChange"));
			}
			else if(_isDown)
			{
				_value-=numStep;
				_input.text = _value.toFixed(_fixNum);
				this.dispatchEvent(new Event("inputChange"));
			}
		}
		
		private function onInputChange(evt:Event):void
		{
			_value = Number(_input.text);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			_label = new Label(this,0,0,_text);
			_label.width = _label.textField.textWidth+4;
			_input = new InputText(this,_label.x+_label.width+5,_label.y,"",onInputChange);
			_input.width = 60;
			_input.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(Style.DROPSHADOW, 0.5);
			shape.graphics.moveTo(5, 3);
			shape.graphics.lineTo(7, 6);
			shape.graphics.lineTo(3, 6);
			shape.graphics.endFill();
			_up = new PushButton(this,_input.x+_input.width+5,_input.y,"");
			_up.setSize(10,10);
			_up.addChild(shape);
			_up.addEventListener(MouseEvent.MOUSE_DOWN,upMouseDown);
			_up.addEventListener(MouseEvent.MOUSE_UP,upMouseUp);
			
			shape = new Shape();
			shape.graphics.beginFill(Style.DROPSHADOW, 0.5);
			shape.graphics.moveTo(5, 7);
			shape.graphics.lineTo(7, 4);
			shape.graphics.lineTo(3, 4);
			shape.graphics.endFill();
			_down = new PushButton(this,_up.x,_up.y+_up.height,"");
			_down.setSize(10,10);
			_down.addChild(shape);
			_down.addEventListener(MouseEvent.MOUSE_DOWN,downMouseDown);
			_down.addEventListener(MouseEvent.MOUSE_UP,dowMouseUp);
			
			height = 20;
		}
		
	}
}
package com.bit101.c_extends
{
	/**
	 * ClassName: package com.bit101.c_extends::TabButton
	 *
	 * Intro:
	 *
	 * @date: 2014-8-18
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public final class TabButton extends PushButton
	{
		private var _index:int;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

	
		public function TabButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
			_toggle = true;
		}
		
		override protected function onMouseGoDown(event:MouseEvent):void
		{
			if(!_down)
			{
				_down = true;
				_selected = true;
				drawFace();
				_face.filters = [getShadow(1, true)];
			}
		}
	}
}
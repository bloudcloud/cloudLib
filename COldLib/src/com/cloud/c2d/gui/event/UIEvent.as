package com.cloud.c2d.gui.event
{
	/**
	 * ClassName: package com.cloud.c2d.gui.event::UIEvent
	 *
	 * Intro:
	 *
	 * @date: 2014-5-16
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	import flash.events.Event;
	
	public final class UIEvent extends Event
	{
		public static const RENDER_COMPLETE:String = "renderComplete";
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}
		
		public function UIEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
	}
}
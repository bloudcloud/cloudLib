package com.cloud.c2d.gui.event
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * ClassName: package com.cloud.c2d.gui.event::EventFactory
	 *
	 * Intro:
	 *
	 * @date: 2014-5-29
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public class EventFactory
	{
		private static const _eventDic:Dictionary = new Dictionary();
		
		public static function getEventInstance(key:String):Event
		{
			return _eventDic[key] ||= new Event(key);
		}
		public function EventFactory()
		{
		}
	}
}
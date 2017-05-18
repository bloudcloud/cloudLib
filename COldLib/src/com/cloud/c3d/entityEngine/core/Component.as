package com.cloud.c3d.entityEngine.core
{
	import flash.events.EventDispatcher;

	/**
	 * ClassName: package com.cloud.entityEngine.core::Component
	 *
	 * Intro:
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class Component extends EventDispatcher implements IComponent
	{
		protected var _owners:Vector.<Entity>;
		
		protected var _name:String;
		public function get name():String
		{
			return _name;
		}

		
		public function Component(name:String,owner:Entity)
		{
			_owners = new Vector.<Entity>();
			_owners.push(owner);
			_name = name;
			
		}
		
		public function excute():void
		{
			
		}
	}
}
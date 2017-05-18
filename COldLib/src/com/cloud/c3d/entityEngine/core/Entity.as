package com.cloud.c3d.entityEngine.core
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * ClassName: package com.cloud.entityEngine.core::Entity
	 *
	 * Intro:
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class Entity extends EventDispatcher implements IEntity
	{
		protected var _id:uint;
		protected var _type:uint;
		protected var _componentType:uint;
		protected var _properties:Dictionary;
		protected var _components:Vector.<IComponent>;
		
		
		public function Entity()
		{
			_id=_type=_componentType=0;
			
			_properties = new Dictionary();
			_components = new Vector.<IComponent>();
		}
		
		public function addComponent(component:IComponent):void
		{
			_components.push(component);
		}
		
		public function addProperty(key:String,value:*):void
		{
			_properties[key] = value;
		}
		
		public function getProperty(key:String):*
		{
			return _properties[key];
		}
		
		public function update():void
		{
			
		}
	}
}
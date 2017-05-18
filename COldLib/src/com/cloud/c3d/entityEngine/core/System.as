package com.cloud.c3d.entityEngine.core
{
	/**
	 * ClassName: package com.cloud.entityEngine.core::System
	 *
	 * Intro:
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class System implements ISystem
	{
		protected var _entities:Vector.<IEntity>;
		
		public function System()
		{
			_entities = new Vector.<IEntity>();
			init();
		}
		
		protected function init():void
		{
			
		}
		
		public function addEntity(entity:IEntity):void
		{
			_entities.push(entity);
		}
		
		public function start():void
		{
		}
		
		public function stop():void
		{
		}
		
		public function update():void
		{
			for(var i:int=0; i<_entities.length;i++)
			{
				_entities[i].update();
			}
		}
	}
}
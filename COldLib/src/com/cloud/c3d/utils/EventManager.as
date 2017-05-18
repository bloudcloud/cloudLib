package com.cloud.c3d.utils
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * ClassName: package::EventManager
	 *
	 * Intro:事件管理器
	 *
	 * @date: 2014-8-8
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public final class EventManager
	{
		private static var _instance:EventManager;
		public static function get instance():EventManager
		{
			return _instance ||= new EventManager(new SingletonEnforce());
		}
		
		private var _pool:EventPool;
		private var _dispatcherDic:Dictionary;

		public function EventManager(enforcer:SingletonEnforce)
		{
			_pool = new EventPool();
			_dispatcherDic = new Dictionary();
		}

		public function addListener(dispatcher:EventDispatcher,type:String,func:Function):void
		{
			dispatcher.addEventListener(type,func);
			var obj:Object = _pool.pop();
			obj.type = type;
			obj.func = func;
			if(_dispatcherDic[dispatcher] == null)
			{
				_dispatcherDic[dispatcher] = new Vector.<Object>();
				_dispatcherDic[dispatcher].push(obj);
			}
		
		}
		
		public function removeListener(dispatcher:EventDispatcher,type:String,func:Function):void
		{
			dispatcher.removeEventListener(type,func);
			for(var i:int = 0; i < _dispatcherDic[dispatcher].length; i++)
			{
				if(_dispatcherDic[dispatcher][i].type == type)
				{
					_pool.push(_dispatcherDic[dispatcher][i]);
					_dispatcherDic[dispatcher].splice(i,1);
					break;
				}
			}
		}

		public function removeDispatcherListener(dispatcher:EventDispatcher):void
		{
			for(var i:int=0; i<_dispatcherDic[dispatcher].length; i++)
			{
				dispatcher.removeEventListener(_dispatcherDic[dispatcher][i].type,_dispatcherDic[dispatcher][i].func);
				_pool.push(_dispatcherDic[dispatcher][i]);
			}			
			_dispatcherDic[dispatcher].length = 0;
		}

		public function addLoop():void
		{
			
		}
	}
}
class EventPool
{
	private var _evtObjs:Array = new Array();
	
	public function pop():Object
	{
		var obj:Object;
		if(!_evtObjs.length)
		{
			obj = new Object();
			obj.type = null;
			obj.func = null;
		}
		else 
		{
			obj = _evtObjs.pop();
		}
		return obj;
	}
	
	public function push(obj:Object):void
	{
		obj.type = null;
		obj.func = null;
		_evtObjs.push(obj);
	}
}
class SingletonEnforce{}
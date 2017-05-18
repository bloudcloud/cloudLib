package com.cloud.c2d.utils
{
	/**
	 * Classname : public dynamic class CDictionary extends Proxy
	 * 
	 * Date : 2013-9-12
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * 实现功能: 字典类
	 * 
	 */
	public dynamic class CDictionary extends Proxy
	{
		private var _dic:Dictionary;
		private var _revDic:Dictionary;
		
		public function CDictionary(weakKeys:Boolean = true)
		{
			_dic = new Dictionary(weakKeys);
			_revDic = new Dictionary(weakKeys);
		}
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return _dic[name] ? true : false;
		}
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_dic[name] = value;
			_revDic[value] = name;
		}
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			delete _revDic[_dic[name]];
			delete _dic[name];
			return true;
		}
		override flash_proxy function getProperty(name:*):*
		{
			return _dic[name];
		}
		/**
		 * 遍历数据并执行方法 
		 * @param func 
		 * 
		 */		
		public function traversalGetValue(func:Function):void
		{
			var index:*;
			for(index in _revDic)
			{
				func(index);
			}
			index = undefined;
		}
		/**
		 * 遍历数据，为回调函数传递键值 
		 * @param func
		 * 
		 */	
		public function traversalGetKey(func:Function):void
		{
			var index:Object;
			for(index in _dic)
			{
				func(index);
			}
			index = undefined;
		}
		/**
		 * 清空数据 
		 * 
		 */	
		public function clearAll():void
		{
			for (var key:* in _dic)
			{
				delete _revDic[_dic[key]];
				delete _dic[key];
			}
		}
		/**
		 * 获取取反字典的值 
		 * @param name
		 * @return *
		 * 
		 */		
		public function getRevValue(name:*):*
		{
			return _revDic[name];
		}
	}
}
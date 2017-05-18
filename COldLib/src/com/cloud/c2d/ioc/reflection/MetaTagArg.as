package com.cloud.c2d.ioc.reflection
{
	/**
	 * ClassName: package com.cloud.c2d.ioc.reflection::MetaTagArg
	 *
	 * Intro:meta标签类得参数类
	 *
	 * @date: 2014-5-22
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public final class MetaTagArg
	{
		/**
		 * meta标签类的主键
		 */
		public var key:String;
		/**
		 * meta标签类的键值
		 */
		public var value:String;
		
		public function MetaTagArg(key:String,value:String)
		{
			this.key = key;
			this.value = value;
		}
		
		public function toString():String
		{
			return "MetaTagArg{ key:" + key + ",value:" + value + " }";
		}
	}
}
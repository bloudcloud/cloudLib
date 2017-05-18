package com.cloud.c2d.ioc.reflection
{
	import com.creativebottle.starlingmvc.reflection.MetaTagArg;

	/**
	 * ClassName: package com.cloud.c2d.ioc.reflection::MetaTag
	 *
	 * Intro:	meta标签类
	 *
	 * @date: 2014-5-22
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public final class MetaTag
	{
		/**
		 * 标签内的参数队列
		 */
		public const args:Array = [];
		/**
		 * 标签的名字
		 */
		public var name:String;
		
		public function MetaTag(name:String,xml:XMLList)
		{
			this.name = name;
			
			for each(var argXml:XML in xml)
			{
				args.push(new MetaTagArg(argXml.@key, argXml.@value));
			}
		}
		/**
		 * 通过名字返回标签的参数队列 
		 * @param key
		 * @return MetaTagArg
		 * 
		 */
		public function argByKey(key:String):MetaTagArg
		{
			for each(var arg:MetaTagArg in args)
			{
				if (arg.key == key)
					return arg;
			}
			
			return null;
		}

		public function toString():String
		{
			return "MetaTag{ name:" + name + ",args:" + args + " }";
		}
	}
}
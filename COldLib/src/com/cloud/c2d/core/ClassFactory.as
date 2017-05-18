package com.cloud.c2d.core
{
	import flash.utils.getDefinitionByName;

	/**
	 * ClassName: package com.cloud.c2d.core::ClassFactory
	 * Intro:	类工厂，负责创建类对象
	 *
	 * @date: 2014-3-18
	 *
	 * @autor: cloud
	 *
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer12
	 * @sdkVersion: AIR4.0
	 */
	public final class ClassFactory
	{
		private static const funcs:Array =
			[
				function(K:*, a:*):* { return new K(a[0]); },
				function(K:*, a:*):* { return new K(a[0], a[1]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14] },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14]; a[15] },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14]; a[15]; a[16] },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14]; a[15]; a[16]; a[17] },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14]; a[15]; a[16]; a[17]; a[18] },
				function(K:*, a:*):* { return new K(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); a[12]; a[13]; a[14]; a[15]; a[16]; a[17]; a[18]; a[19] }
			];
		/**
		 * 创建一个类，支持构造方法和属性赋值
		 * @param generator	目标类，可以是String，也可以是Class
		 * @param constructors	构造方法的参数，参数顺序遵循构造方法参数顺序
		 * @param properties	类属性，可以有一个或多个键值对组成
		 * @return object 返回创建并赋值相关属性后的对象
		 * 
		 */		
		public static function apply(generator:*, constructors:Array = null, properties:Array = null):*
		{
			var K:Class;
				
			if (generator is String)
				K = getDefinitionByName(generator) as Class;
			else if (generator is Class)
				K = Class(generator);
			if (!K) return null;
			
			var o:* = undefined;
			if (!constructors || constructors.length == 0)
				o = new K();
			else
				o = funcs[constructors.length - 1].apply(null, [K, constructors]);
			if (!o) return null;
			
			o = ObjectUtil.apply(o, properties);
			return o;
		}
		public function ClassFactory()
		{
		}
	}
}
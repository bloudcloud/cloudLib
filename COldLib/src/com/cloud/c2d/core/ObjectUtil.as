package com.cloud.c2d.core
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * ClassName: package com.cloud.c2d.core::ObjectUtil
	 * Intro:
	 *
	 * @date: 2014-3-19
	 *
	 * @autor: cloud
	 *
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer12
	 * @sdkVersion: AIR4.0
	 */
	public class ObjectUtil
	{
		/**
		 * 为对象的属性赋值 
		 * @param object	目标对象
		 * @param properties	属性数组，由一个或多个键值对组成
		 * @return object 返回赋值后的目标对象
		 * 
		 */		
		public static function apply(object:*, properties:Array):*
		{
			if (!object) return null;
			
			var t:Object, a:Array = properties ? properties.concat() : [];
			while (a.length > 0)
			{
				t = a.shift();
				for (var k:* in t)
				{
					if (object.hasOwnProperty(k))
					{
						if (object[k] is Function) object[k].apply(null, t[k]);
						else object[k] = t[k];
					}
				}
			}
			return object;
		}
		/**
		 * 数据对象深复制(不能复制显示对象DisplayObject) 
		 * @param o	 源对象
		 * @return object 复制后的对象
		 * 
		 */		
		public static function clone(o:*):*
		{
			var name:String = getQualifiedClassName(o);
			registerClassAlias(name.replace("::", "."), getDefinitionByName(name) as Class);
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(o);
			buffer.position = 0;
			return buffer.readObject();
		}
		public function ObjectUtil()
		{
		}
	}
}
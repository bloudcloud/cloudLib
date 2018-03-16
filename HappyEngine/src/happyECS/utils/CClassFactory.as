package happyECS.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import happyECS.ns.happy_ecs;
	
	use namespace happy_ecs;
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
	public final class CClassFactory
	{
		private static var _Instance:CClassFactory;
		
		happy_ecs static function get Instance():CClassFactory
		{
			return _Instance ||= new CClassFactory();
		}
			
		public const funcs:Vector.<Function> =Vector.<Function>(
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
			]
			);
		
		public function CClassFactory()
		{
		}
		/**
		 * 创建一个类，支持构造方法和属性赋值
		 * @param generator	目标类，可以是String，也可以是Class
		 * @param constructors	构造方法的参数，参数顺序遵循构造方法参数顺序
		 * @param properties	类属性，可以有一个或多个键值对组成
		 * @return object 返回创建并赋值相关属性后的对象
		 * 
		 */		
		public function constructAndApply(generator:*, constructors:Array = null, properties:Array = null):*
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
			
			o = applyProperties(o, properties);
			return o;
		}
		/**
		 * 为对象的属性赋值 
		 * @param object	目标对象
		 * @param properties	属性数组，由一个或多个键值对组成
		 * @return object 返回赋值后的目标对象
		 * 
		 */		
		public function applyProperties(object:*, properties:Array):*
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
		public function clone(o:*):*
		{
			var name:String = getQualifiedClassName(o);
			registerClassAlias(name.replace("::", "."), getDefinitionByName(name) as Class);
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(o);
			buffer.position = 0;
			return buffer.readObject();
		}
	}
}
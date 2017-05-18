package com.cloud.c2d.ioc.reflection
{
	import com.creativebottle.starlingmvc.errors.UndefinedMemberKindError;
	import com.creativebottle.starlingmvc.reflection.Accessor;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.MemberKind;
	import com.creativebottle.starlingmvc.reflection.MetaTag;
	import com.creativebottle.starlingmvc.reflection.Method;
	import com.creativebottle.starlingmvc.reflection.Variable;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * ClassName: package com.cloud.c2d.ioc::ClassDescriptor
	 *
	 * Intro:	mata描述解析类
	 *
	 * @date: 2014-5-21
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public final class ClassDescriptor
	{
		private static const classDescriptorCache:Dictionary = new Dictionary();
		/**
		 *	获取mataClass描述对象的实例
		 * @param object	描述的源对象
		 * @return 
		 * 
		 */		
		public static function getClassDescriptorForInstance(object:Object):ClassDescriptor
		{
			var classDescriptor:ClassDescriptor;
			
			if (classDescriptorCache[object.constructor])
			{
				classDescriptor = classDescriptorCache[object.constructor];
			}
			else
			{
				classDescriptor = new ClassDescriptor(object);
				
				classDescriptorCache[object.constructor] = classDescriptor;
			}
			return classDescriptor;
		}
		/**
		 * mataClass描述对象里的所有get/set
		 */
		public const accessors:Array = [];
		/**
		 * mataClass描述对象里的所有变量
		 */
		public const variables:Array = [];
		/**
		 * mataClass描述对象的所有标签
		 */
		public var tags:Array = [];
		
		/**
		 * mataClass描述对象的所有函数
		 */
		public const methods:Array = [];
		
		public function ClassDescriptor(obj:Object)
		{
			var xml:XML = describeType(obj);
			
			for each(var tag:XML in xml.metadata)
			{
				tags.push(new MetaTag(tag.@name, tag..arg));
			}
			
			parse(xml..accessor, MemberKind.ACCESSOR);
			parse(xml..variable, MemberKind.VARIABLE);
			parse(xml..method, MemberKind.METHOD);
		}
		private function parse(xmlList:XMLList, kind:MemberKind):void
		{
			for each(var itemXml:XML in xmlList)
			{
				switch (kind)
				{
					case MemberKind.ACCESSOR:
						accessors.push(new Accessor(itemXml));
						break;
					case MemberKind.METHOD:
						methods.push(new Method(itemXml));
						break;
					case MemberKind.VARIABLE:
						variables.push(new Variable(itemXml));
						break;
					default:
						throw new UndefinedMemberKindError(kind);
						break;
				}
			}
		}
	}
}
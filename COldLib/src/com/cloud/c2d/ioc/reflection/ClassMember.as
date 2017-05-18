package com.cloud.c2d.ioc.reflection
{
	import com.creativebottle.starlingmvc.reflection.MetaTag;

	/**
	 * ClassName: package com.cloud.c2d.ioc.reflection::ClassMember
	 *
	 * Intro:	描述类的成员类
	 *
	 * @date: 2014-5-22
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public class ClassMember
	{
		/**
		 * 标签对象队列
		 */
		public const tags:Array = [];
		/**
		 * 成员的名字
		 */
		public var name:String;
		/**
		 * 成员的类名
		 */
		public var classname:String;
		
		public function ClassMember(xml:XMLList)
		{
			parse(xml);
		}
		
		protected function parse(xml:XMLList):void
		{
			name = xml.@name;
			classname = xml.@type;
			
			for each(var metaDataXml:XML in xml.metadata)
			{
				tags.push(new MetaTag(metaDataXml.@name, metaDataXml..arg));
			}
		}
	}
}
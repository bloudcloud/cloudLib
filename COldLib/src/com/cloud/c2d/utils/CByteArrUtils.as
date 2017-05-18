package com.cloud.c2d.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Classname : public class CByteArrUtils
	 * 
	 * Date : 2013-9-10
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 
	 * 
	 */
	public class CByteArrUtils
	{
		public function CByteArrUtils()
		{
		}
		/**
		 * 克隆对象 
		 * @param $object
		 * @return Object
		 * 
		 */		
		public static function clone($object:Object):*
		{
			var typeName:String = getQualifiedClassName($object);
			var packName:String = typeName.split("::")[0];
			var typeClass:Class = getDefinitionByName(typeName) as Class;
			registerClassAlias(packName,typeClass);
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeObject($object);
			byteArr.position = 0;
			return byteArr.readObject();
		}
	}
}
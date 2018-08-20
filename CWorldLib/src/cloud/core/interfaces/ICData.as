package cloud.core.interfaces
{
	/**
	 *  基础对象数据接口
	 * @author cloud
	 */
	public interface ICData
	{
		/**
		 * 获取唯一ID 
		 * @return String
		 * 
		 */		
		function get uniqueID():String;
//		/**
//		 * 设置唯一ID 
//		 * @param value
//		 * 
//		 */		
//		function set uniqueID(value:String):void;
//		/**
//		 * 获取父数据对象的唯一ID
//		 * @return String
//		 * 
//		 */		
//		function get parentID():String;
//		/**
//		 * 设置父数据对象的唯一ID
//		 * @param value
//		 * 
//		 */		
//		function set parentID(value:String):void;
//		/**
//		 * 获取父数据对象的类型 
//		 * @return uint
//		 * 
//		 */		
//		function get parentType():uint;
//		/**
//		 * 设置父数据对象的类型 
//		 * @param value
//		 * 
//		 */		
//		function set parentType(value:uint):void;
		/**
		 * 获取对象数据类型属性 
		 * @return uint
		 * 
		 */		
		function get type():uint;
		/**
		 * 设置对象数据类型属性 
		 * @param value
		 * 
		 */		
		function set type(value:uint):void;
		
		/**
		 * 输出字符串格式 
		 * @return String
		 * 
		 */		
		function toString():String;
		/**
		 * 克隆 
		 * @return ICData
		 * 
		 */	
		function clone():ICData;
	}
}
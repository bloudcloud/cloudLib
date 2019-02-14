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
package cloud.core.interfaces
{
	/**
	 *  基础对象数据接口
	 * @author cloud
	 */
	public interface ICData extends ICResource
	{
		/**
		 * 获取唯一ID 
		 * @return String
		 * 
		 */		
		function get uniqueID():String;
		/**
		 * 设置唯一ID 
		 * @param value
		 * 
		 */		
		function set uniqueID(value:String):void;
		/**
		 * 获取父数据对象的唯一ID
		 * @return String
		 * 
		 */		
		function get parentID():String;
		/**
		 * 设置父数据对象的唯一ID
		 * @param value
		 * 
		 */		
		function set parentID(value:String):void;
		/**
		 * 获取父数据对象的类型 
		 * @return uint
		 * 
		 */		
		function get parentType():uint;
		/**
		 * 设置父数据对象的类型 
		 * @param value
		 * 
		 */		
		function set parentType(value:uint):void;
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
		 * 获取名字 
		 * @return String
		 * 
		 */		
		function get name():String;
		/**
		 * 设置名字 
		 * @param value
		 * 
		 */		
		function set name(value:String):void;
		/**
		 * 获取数据是否生存
		 * @return Boolean
		 * 
		 */		
		function get isLife():Boolean;
		/**
		 * 设置数据是否生存 
		 * @param value
		 * 
		 */		
		function set isLife(value:Boolean):void;
		/**
		 * 比较大小 
		 * @param source
		 * @return Number 如果大于0，当前对象比source对象大，如果小于0，当前对象比source对象小，如果相等就等于0
		 * 
		 */		
		function compare(source:ICData):Number;
		/**
		 * 输出字符串格式 
		 * @return String
		 * 
		 */		
		function toString():String;

	}
}
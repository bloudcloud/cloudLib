package interfaces
{
	/**
	 * 乐家业务模型数据
	 * @author cloud
	 */
	public interface IL3DBaseData
	{
		/**
		 * 获取唯一ID
		 * @return String
		 * 
		 */		
		function get id():String;
		/**
		 * 设置唯一ID 
		 * @param value
		 * 
		 */		
		function set id(value:String):void;
		/**
		 *  获取类型
		 * @return uint
		 * 
		 */		
		function get type():uint;
		/**
		 * 设置类型 
		 * @param value
		 * 
		 */		
		function set type(value:uint):void;
		/**
		 * 获取名称 
		 * @return String
		 * 
		 */		
		function get name():String;
		/**
		 * 设置名称 
		 * @param value
		 * 
		 */		
		function set name(value:String):void;
		/**
		 * 获取类名 
		 * @return String
		 * 
		 */		
		function get classRefName():String;
		/**
		 * 销毁
		 * @param isRealDispose	是否释放内部链接的资源,默认是false，表示只清除内部的引用，不销毁引用对象资源
		 * @return Boolean
		 * 
		 */		
		function dispose(isRealDispose:Boolean=false):Boolean;
		/**
		 * 创建拷贝
		 * @return IL3DModelData
		 * 
		 */		
		function clone():IL3DBaseData;
	}
}
package core.a3d
{

	/**
	 * 带名称的资源接口
	 * @author cloud
	 */
	public interface ICNameResource
	{
		/**
		 * 获取资源名称 
		 * @return String
		 * 
		 */		
		function get name():String;
		/**
		 * 设置资源名称 
		 * @param value
		 * 
		 */		
		function set name(value:String):void;
		/**
		 * 获取唯一标记 
		 * @return String
		 * 
		 */		
		function get mark():String;
		/**
		 * 设置唯一标记 
		 * @param value
		 * 
		 */		
		function set mark(value:String):void;
		/**
		 * 获取引用计数  
		 * @return uint
		 * 
		 */			
		function get refCount():int;
		/**
		 * 设置引用计数 
		 * @param value
		 * 
		 */		
		function set refCount(value:int):void;
		/**
		 * 清理资源对象
		 * 
		 */		
		function clear():void;
	}

}
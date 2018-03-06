package cloud.core.interfaces
{
	/**
	 * 资源接口
	 * @author cloud
	 */
	public interface ICResource
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
		 * 获取引用计数  
		 * @return uint
		 * 
		 */			
		function get refCount():uint;
		/**
		 * 设置引用计数 
		 * @param value
		 * 
		 */		
		function set refCount(value:uint):void;
		/**
		 * 清理资源对象
		 * 
		 */		
		function clear():void;
	}
}
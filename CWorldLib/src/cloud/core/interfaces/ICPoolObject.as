package cloud.core.interfaces
{
	/**
	 * 池数据接口
	 * @author cloud
	 */
	public interface ICPoolObject
	{
		/**
		 * 是否是在池内
		 * @return Boolean
		 * 
		 */		
		function get isInPool():Boolean;
		/**
		 * 初始化池数据对象 
		 * 
		 */		
		function initObject(...params):void;
		/**
		 * 获取一个池对象的拷贝 
		 * @return ICPoolObject
		 * 
		 */		
		function clone():ICPoolObject;
		/**
		 * 返回池中 
		 * 
		 */	
		function back():void;
		/**
		 * 释放池数据对象 
		 * 
		 */		
		function dispose():void;
	}
}
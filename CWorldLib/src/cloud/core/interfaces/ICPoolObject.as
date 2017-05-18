package cloud.core.interfaces
{
	/**
	 * 池数据接口
	 * @author cloud
	 */
	public interface ICPoolObject
	{
		
		/**
		 * 初始化池数据对象 
		 * 
		 */		
		function initObject(initParam:Object=null):void;
		/**
		 * 释放池数据对象 
		 * 
		 */		
		function dispose():void;
	}
}
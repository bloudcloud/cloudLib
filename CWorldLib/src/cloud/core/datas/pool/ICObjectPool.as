package cloud.core.datas.pool
{
	import cloud.core.interfaces.ICPoolObject;

	/**
	 * 缓冲池接口
	 * @author cloud
	 */
	public interface ICObjectPool
	{
		function get name():String;
		/**
		 * 缓冲池的尺寸 
		 * @return int
		 * 
		 */		
		function get size():int;
		/**
		 * 获取一个池对象
		 * @return ICPoolObject
		 * 
		 */		
		function pop():ICPoolObject
		/**
		 * 返回一个池对象 
		 * @param obj
		 * 
		 */		
		function push(obj:ICPoolObject):void;
		/**
		 * 重置缓冲池 
		 * 
		 */		
		function flush():void;
		/**
		 * 销毁缓冲池 
		 * 
		 */		
		function dispose():void;
	}
}
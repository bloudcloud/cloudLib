package happyECS.resources.pool
{
	/**
	 * 缓存池接口
	 * @author cloud
	 * @2018-3-9
	 */
	public interface ICPool
	{
		/**
		 * 缓存对象入池 
		 * @param o	入池对象
		 * 
		 */		
		function push(o:ICPoolObject):void;
		/**
		 * 缓存对象出池 
		 * @return ICPoolObject
		 * 
		 */		
		function pop():ICPoolObject;
		/**
		 * 清空缓存池
		 * 
		 */		
		function clear():void;
	}
}
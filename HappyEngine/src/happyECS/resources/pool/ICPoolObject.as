package happyECS.resources.pool
{
	/**
	 * 缓存池对象接口
	 * @author cloud
	 * @2018-3-8
	 */
	public interface ICPoolObject
	{
		/**
		 * 获取池对象是否失效
		 * @return Boolean
		 * 
		 */		
		function get invalid():Boolean;
		/**
		 * 回到缓存池 
		 * 
		 */		
		function backToPool():void;
		
		function fromToPool():void;
	}
}
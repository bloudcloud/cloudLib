package cloud.core.interfaces
{
	/**
	 * 数据结构-图的接口
	 * @author cloud
	 */
	public interface ICMap
	{	
		/**
		 * 图的大小 
		 * @return Number
		 * 
		 */		
		function get size():int;
		/**
		 * 是否是空的 
		 * @return Boolean
		 * 
		 */		
		function get isEmpty():Boolean;
		/**
		 * 获取所有的键 
		 * @return Array
		 * 
		 */		
		function get values():Array;
		/**
		 * 获取所有的值 
		 * @return Array
		 * 
		 */		
		function get keys():Array;
		/**
		 * 清理缓存 
		 * 
		 */		
		function clear():void;
		/**
		 * 是否含有该键 
		 * @param key
		 * @return Boolean
		 * 
		 */		
		function containsKey(key:*):Boolean;
		/**
		 * 是否含有该值 
		 * @param value
		 * @return Boolean
		 * 
		 */		
		function containsValue(value:*):Boolean;
		/**
		 * 根据键获取值 
		 * @param key
		 * @return Object
		 * 
		 */		
		function get(key:*):Object;
		/**
		 * 添加一个键值对 
		 * @param key	键
		 * @param value	值
		 * @return Object
		 * 
		 */		
		function put(key:*,value:*):Object;
		/**
		 * 移除一个键值对 
		 * @param key	键
		 * @return Object
		 * 
		 */		
		function remove(key:*):Object;
		/**
		 *  合并一个图中所有的键值对
		 * @param map
		 * 
		 */		
		function putAll(map:ICMap):void;
	}
}
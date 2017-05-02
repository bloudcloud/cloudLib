package cloud.core.interfaces
{
	/**
	 * 序列化接口
	 * @author cloud
	 */
	public interface ICSerialization
	{
		/**
		 * 反序列化 
		 * @param source
		 * 
		 */		
		function deserialize(source:*):void;
		/**
		 * 序列化 
		 * @return 
		 * 
		 */		
		function serialize():*;
	}
}
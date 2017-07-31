package cloud.core.interfaces
{
	/**
	 * 序列化接口
	 * @author cloud
	 */
	public interface ICSerialization
	{
		/**
		 * 获取对象类名 
		 * @return String
		 * 
		 */		
		function get className():String;
		/**
		 * 反序列化 
		 * @param source
		 * 
		 */		
		function deserialize(source:*):void;
		/**
		 * 序列化  
		 * @param formate	序列化方式
		 * @return 序列化方式对应的对象
		 * 
		 */			
		function serialize(formate:String):*;
	}
}
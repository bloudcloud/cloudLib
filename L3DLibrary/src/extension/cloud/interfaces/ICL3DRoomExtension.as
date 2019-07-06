package extension.cloud.interfaces
{
	/**
	 * 房间扩展接口
	 * @author	cloud
	 * @date	2018-11-24
	 */
	public interface ICL3DRoomExtension
	{
		/**
		 * 获取房间类型 
		 * @return int
		 * 
		 */		
		function get roomType():int;
		/**
		 * 获取屋顶类型 
		 * @return int
		 * 
		 */		
		function get roofType():int;
		
		
	}
}
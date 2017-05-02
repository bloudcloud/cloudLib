package cloud.core.interfaces
{
	import flash.geom.Vector3D;
	
	/**
	 *  家具列表数据类
	 * @author cloud
	 */
	public interface ICObject3DList
	{
		/**
		 * 获取链表尾部位置坐标 
		 * @return Vector3D
		 * 
		 */		
		function get endPos():Vector3D;
		function set endPos(value:Vector3D):void;
		/**
		 * 获取链表头部位置坐标
		 * @return Vector3D
		 * 
		 */		
		function get startPos():Vector3D;
		function set startPos(value:Vector3D):void;
	}
}
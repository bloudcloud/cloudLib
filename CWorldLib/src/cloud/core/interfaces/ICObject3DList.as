package cloud.core.interfaces
{
	import cloud.core.datas.base.CVector;
	
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
		function get endPos():CVector;
		function set endPos(value:CVector):void;
		/**
		 * 获取链表头部位置坐标
		 * @return Vector3D
		 * 
		 */		
		function get startPos():CVector;
		function set startPos(value:CVector):void;
	}
}
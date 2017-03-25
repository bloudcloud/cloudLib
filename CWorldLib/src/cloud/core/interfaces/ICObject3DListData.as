package cloud.core.interfaces
{
	import flash.geom.Vector3D;
	
	/**
	 *  家具列表数据类
	 * @author cloud
	 */
	public interface ICObject3DListData extends ICData
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
		function get headPos():Vector3D;
		function set headPos(value:Vector3D):void;
		/**
		 * 获取方向 
		 * @return int
		 * 
		 */		
		function get direction():int;
		/**
		 * 设置方向 
		 * @param value
		 * 
		 */		
		function set direction(value:int):void;
		/**
		 * 获取长度 
		 * @return 
		 * 
		 */		
		function get length():Number;
		/**
		 * 设置长度 
		 * @param value
		 * 
		 */		
		function set length(value:Number):void;
		/**
		 * 获取宽度 
		 * @return Number
		 * 
		 */		
		function get width():Number;
		/**
		 * 设置宽度 
		 * @param value
		 * 
		 */		
		function set width(value:Number):void;
		/**
		 *  获取高度
		 * @return Number
		 * 
		 */
		function get height():Number;
		/**
		 * 设置高度 
		 * @param value
		 * 
		 */		
		function set height(value:Number):void;
	}
}
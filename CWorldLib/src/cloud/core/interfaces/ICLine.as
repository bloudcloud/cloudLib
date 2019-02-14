package cloud.core.interfaces
{
	import flash.geom.Vector3D;

	/**
	 * 线段接口
	 * @author	cloud
	 * @date	2018-9-1
	 */
	public interface ICLine
	{
		/**
		 * 获取线段长度 
		 * @return Number
		 * 
		 */		
		function get length():Number;
		/**
		 * 获取线段起始点 
		 * @return Vector3D
		 * 
		 */		
		function get start():Vector3D;
		/**
		 * 设置线段起点
		 * @param value
		 * 
		 */		
		function set start(value:Vector3D):void;
		/**
		 * 获取线段终点 
		 * @return Vector3D
		 * 
		 */		
		function get end():Vector3D;
		/**
		 * 设置线段终点 
		 * @param value
		 * 
		 */		
		function set end(value:Vector3D):void;
		/**
		 * 获取线段方向
		 * @return Vector3D
		 * 
		 */		
		function get direction():Vector3D;
		/**
		 *	获取线段中心点 
		 * @return Vector3D
		 * 
		 */		
		function get center():Vector3D;
		
	}
}
package extension.cloud.interfaces
{
	import flash.geom.Vector3D;
	

	/**
	 * 地面扩展接口
	 * @author	cloud
	 * @date	2018-11-5
	 */
	public interface ICL3DFloorExtension
	{
		/**
		 * 获取地面的唯一ID 
		 * @return String
		 * 
		 */		
		function get floorID():String;
		/**
		 * 获取地面所属房间的ID 
		 * @return String
		 * 
		 */		
		function get roomID():String;
		/**
		 * 获取中线围点坐标集合 
		 * @return Vector.<Number>
		 * 
		 */		
		function get center3DRoundPoints():Vector.<Number>;
		/**
		 * 设置中线围点坐标集合 
		 * @param value	Vector.<Number>
		 * 
		 */		
		function set center3DRoundPoints(value:Vector.<Number>):void;
		/**
		 * 获取内围点坐标集合 
		 * @return Vector.<Number>
		 * 
		 */		
		function get inner3DRoundPoints():Vector.<Number>;
		/**
		 * 设置内围点坐标集合 
		 * @param value	Vector.<Number>
		 * 
		 */		
		function set inner3DRoundPoints(value:Vector.<Number>):void;
		/**
		 * 获取外围点坐标集合 
		 * @return Vector.<Number>
		 * 
		 */		
		function get outter3DRoundPoints():Vector.<Number>;
		/**
		 * 设置外围点坐标集合 
		 * @param value	Vector.<Number>
		 * 
		 */		
		function set outter3DRoundPoints(value:Vector.<Number>):void;
		/**
		 * 获取中心点位置对象 
		 * @return Vector3D
		 * 
		 */		
		function get centerPosition():Vector3D;
		/**
		 * 获取地面2D图片的地址 
		 * @return String
		 * 
		 */		
		function get url():String;
		/**
		 * 设置地面2D图片的地址 
		 * @param value String
		 * 
		 */		
		function set url(value:String):void;
		/**
		 * 更新房间的名称
		 * 
		 */		
		function updateFloorName():void;
		/**
		 * 检测2D原点是否是地面范围内一点 
		 * @param originPos
		 * @return Boolean
		 * 
		 */	
		function onPickedByPosition2D(originPos:Vector3D):Boolean;
		/**
		 * 检测3D原点是否是地面范围内一点 
		 * @param originPos
		 * @return Boolean
		 * 
		 */		
		function onPickedByPosition3D(originPos:Vector3D):Boolean;
		/**
		 *  绘制地面 
		 * @param triangle3DVertices	绘制的平面三角形点集合
		 * @param start	起点坐标
		 * @param ulength	U单位长度
		 * @param vlength	V单位长度
		 * 
		 */
		function drawFloor(triangle3DVertices:Vector.<Number>,start:Vector3D,ulength:Number,vlength:Number):void;
	}
}
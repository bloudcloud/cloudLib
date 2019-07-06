package extension.cloud.interfaces
{
	import flash.display.Stage3D;
	import flash.geom.Vector3D;
	
	import cloud.core.datas.maps.CHashMap;
	
	import pl.bmnet.gpcas.geometry.Poly;

	/**
	 * 业务场景扩展接口
	 * @author	cloud
	 * @date	2018-7-5
	 */
	public interface ICL3DSceneExtension
	{
		/**
		 * 获取3D舞台对象 
		 * @return Stage3D
		 * 
		 */		
		function get stage3d():Stage3D;
		/**
		 * 获取场景中所有联合房间的多边形集合二维数组 
		 * @return Array
		 * 
		 */		
		function get unitFloorPolys():Vector.<Poly>;
		/**
		 * 获取场景中的墙体数据集合（起始点坐标值做索引）
		 * @return CHashMap
		 * 
		 */		
		function get wallMap():CHashMap;
		/**
		 * 添加房间对象 
		 * @param floor
		 * @return Boolean
		 * 
		 */		
		function addFloor(floor:ICL3DFloorExtension):Boolean;
		/**
		 * 根据房间ID,移除房间 
		 * @param centerPos
		 * @param isDispose	是否清理地面
		 * @return Boolean
		 * 
		 */		
		function removeFloor(centerPos:Vector3D,isDispose:Boolean=true):Boolean;
		/**
		 * 更新地面 
		 * @param floor
		 * 
		 */	
		function updateFloor(floor:ICL3DFloorExtension):Boolean;
		
	}
}
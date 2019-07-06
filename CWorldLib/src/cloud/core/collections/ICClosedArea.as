package cloud.core.collections
{
	import flash.geom.Vector3D;
	
	import cloud.core.interfaces.ICLine;

	/**
	 * 平面闭合区域结构接口
	 * @author	cloud
	 * @date	2018-8-17
	 */
	public interface ICClosedArea
	{
		/**
		 * 获取当前闭合区域面积 
		 * @return Number
		 * 
		 */		
		function get area():Number;
		/**
		 * 获取闭合区域围点坐标值集合 
		 * @return Vector.<Number>
		 * 
		 */		
		function get roundPoints():Vector.<Number>;
		/**
		 * 获取闭合区域法线向量 
		 * @return Vector3D
		 * 
		 */		
		function get normal():Vector3D;
		/**
		 * 获取是否是负向区域 
		 * @return Boolean
		 * 
		 */		
		function get isNegtive():Boolean;
		/**
		 * 获取中心点位置对象 
		 * @return Vector3D
		 * 
		 */		
		function get center():Vector3D;
		/**
		 * 初始化闭合区域结构 
		 * @param lineDatas 区域边线集合
		 * 
		 */		
		function initArea(lineDatas:Vector.<ICLine>):void
	}
}
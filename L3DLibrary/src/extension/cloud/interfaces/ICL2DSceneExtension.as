package extension.cloud.interfaces
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	/**
	 * 
	 * @author	cloud
	 * @date	2018-7-14
	 */
	public interface ICL2DSceneExtension
	{
		/**
		 * 获取墙体2D显示容器组件 
		 * @return UIComponent
		 * 
		 */		
		function get WallLayer():UIComponent;
		/**
		 * 刷新2D墙体 
		 * 
		 */		
		function RefreshWalls2D():void;
		/**
		 *  在2D主场景中拣选类型
		 * @param point
		 * @return int
		 * 
		 */		
		function pickTypeOnScene2D(point:Point):int;
		/**
		 * 绘制2D坐标 
		 * @param x	
		 * @param y
		 * @param type
		 * 
		 */		
		function renderCoordination2D(x:Number,y:Number,type:int):void;
		/**
		 * 清除2D坐标的显示 
		 * 
		 */		
		function ClearCoordination2D():void;
		/**
		 * 根据起始点和终点，画出尺寸标注线 
		 * @param start	2D起始点
		 * @param end		2D终点
		 * 
		 */		
		function drawDimension(start:Point, end:Point):void;
	}
}
package prefabs.components
{
	import flash.geom.Point;
	
	import happyECS.ecs.component.BaseHComponent;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 区域组件类
	 * @author cloud
	 * @2018-3-13
	 */
	public class RegionComponent extends BaseHComponent
	{
		/**
		 * 围点数组 
		 */		
		private var _points:Array;
		/**
		 * 中心点坐标 
		 */		
		private var _mPoint:Point;
		
		public function RegionComponent()
		{
			super(PrefabTypeDict.REGION_COMPONENT_CLSNAME);
		}
		/**
		 * 更新组件时执行该方法
		 * 
		 */		
		override protected function doUpdateComponent():void
		{
			_points=_resource.points;
			_mPoint=_resource.mPoint;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_points=null;
			_mPoint=null;
		}
	}
}
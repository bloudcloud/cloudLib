package prefabs.components
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import happyECS.ecs.component.BaseHComponent;
	
	import dict.PrefabTypeDict;
	
	public class CommodityModelComponent extends BaseHComponent
	{
		/**
		 * 围点数据集合 
		 */		
		public var points:Array;
		/**
		 * 2d包围框 
		 */		
		public var box2d:Rectangle;
		/**
		 * 中心点坐标
		 */
		public var position:Vector3D;
		
		public function CommodityModelComponent()
		{
			super(PrefabTypeDict.COMMODITY_MODEL_COMPONENT_CLSNAME);
		}
		override protected function doInitialization():void
		{
			box2d=new Rectangle();
			position=new Vector3D();
		}
		override protected function doUpdateComponent():void
		{
			points=_resource.points;
			box2d=_resource.box2d;
			position=_resource.vec;
		}
		
		
	}
}
package prefabs.components
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import happyECS.ecs.component.BaseHComponent;
	
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
		
		public function CommodityModelComponent(refName:String="BaseHComponent")
		{
			super(refName);
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
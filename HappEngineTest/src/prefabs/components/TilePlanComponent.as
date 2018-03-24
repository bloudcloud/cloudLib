package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 砖块计划组件类
	 * @author cloud
	 */
	public class TilePlanComponent extends BaseHComponent
	{
		/**
		 * 方案组合砖的数据集合 
		 */		
		private var _combineTiles:Vector.<Object>;
		/**
		 * 计划主体砖对应的code 
		 */	
		public var code:String;
		/**
		 * 计划主体砖对应的 
		 */
		public var url:String;
		/**
		 * 计划名称 
		 */	
		public var name:String;
		/**
		 * 起铺定位点（0：中心，1：左上，2：中上，3：右上，4：左中，5：右中，6：左下，7：中下，8：右下） 
		 */	
		public var locate:int;
		/**
		 * 砖缝宽度 
		 */		
		public var gapWidth:Number;
		/**
		 * 砖缝颜色 
		 */		
		public var gapColor:uint;
		/**
		 * u方向的偏移值 
		 */		
		public var uOffset:int;
		/**
		 * v方向的偏移值 
		 */		
		public var vOffset:int;
		/**
		 * 厚度方向的偏移值 
		 */		
		public var wOffset:int;
		
		public function TilePlanComponent()
		{
			super(PrefabTypeDict.TILEPLAN_COMPONENT_CLSNAME);
		}
		override protected function doInitialization():void
		{
			_combineTiles=new Vector.<Object>();
		}
		override protected function doUpdateComponent():void
		{
			_combineTiles=_resource.tiles;
			code=_resource,code;
			url=_resource.url;
			name=_resource.name;
			locate=_resource.locate;
			gapWidth=_resource.gapWidth;
			gapColor=_resource.gapColor;
			uOffset=_resource.uOffset;
			vOffset=_resource.vOffset;
			wOffset=_resource.wOffset;
		}
	}
}
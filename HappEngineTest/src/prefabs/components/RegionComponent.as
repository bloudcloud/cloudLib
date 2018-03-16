package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
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
		public var points:Array;
		
		
		public function RegionComponent()
		{
			super(TypeDict.REGION_COMPONENT_CLSNAME);
		}
	}
}
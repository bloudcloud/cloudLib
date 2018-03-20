package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
	/**
	 * 统计组件类
	 * @author cloud
	 * @2018-3-16
	 */
	public class CauclateComponent extends BaseHComponent
	{
		
		public function CauclateComponent()
		{
			super(TypeDict.CAUCLATE_COMPONENT_CLSNAME);
		}
		
		override protected function doInitialization():void
		{
		}
	}
}
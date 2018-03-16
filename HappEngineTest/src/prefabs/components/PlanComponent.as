package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
	/**
	 * 计划组件类
	 * @author cloud
	 * @2018-3-13
	 */
	public class PlanComponent extends BaseHComponent
	{
		public function PlanComponent()
		{
			super(TypeDict.PLAN_COMPONENT_CLSNAME);
		}
	}
}
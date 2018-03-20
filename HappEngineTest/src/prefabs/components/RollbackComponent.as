package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
	/**
	 * 回退组件类
	 * @author cloud
	 * @2018-3-16
	 */
	public class RollbackComponent extends BaseHComponent
	{
		public function RollbackComponent()
		{
			super(TypeDict.ROLLBACK_COMPONENT_CLSNAME);
		}
	}
}
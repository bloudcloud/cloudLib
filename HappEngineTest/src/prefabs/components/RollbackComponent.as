package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 回退组件类
	 * @author cloud
	 * @2018-3-16
	 */
	public class RollbackComponent extends BaseHComponent
	{
		public function RollbackComponent()
		{
			super(PrefabTypeDict.ROLLBACK_COMPONENT_CLSNAME);
		}
	}
}
package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 回退系统类
	 * @author cloud
	 * @2018-3-16
	 */
	public class RollbackSystem extends BaseHSystem
	{
		public function RollbackSystem()
		{
			super(PrefabTypeDict.ROLLBACK_SYSTEM_CLSNAME);
		}
	}
}
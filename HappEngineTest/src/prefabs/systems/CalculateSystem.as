package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 统计系统类
	 * @author cloud
	 * @2018-3-16
	 */
	public class CalculateSystem extends BaseHSystem
	{
		public function CalculateSystem()
		{
			super(PrefabTypeDict.CALCULATE_SYSTEM_CLSNAME);
		}
	}
}
package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 2D显示系统类
	 * @author cloud
	 * @2018-3-14
	 */
	public class Show2DSystem extends BaseHSystem
	{
		
		public function Show2DSystem()
		{
			super(PrefabTypeDict.SHOW2D_SYSTEM_CLSNAME);
		}
	}
}
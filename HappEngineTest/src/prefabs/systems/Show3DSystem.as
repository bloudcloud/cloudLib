package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 3D显示系统类
	 * @author cloud
	 * @2018-3-14
	 */
	public class Show3DSystem extends BaseHSystem
	{
		
		public function Show3DSystem()
		{
			super(PrefabTypeDict.SHOW3D_SYSTEM_CLSNAME);
		}
	}
}
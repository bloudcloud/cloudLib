package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import prefabs.TypeDict;
	
	/**
	 * 3D编辑系统类
	 * @author cloud
	 * @2018-3-16
	 */
	public class Edit3DSystem extends BaseHSystem
	{
		public function Edit3DSystem()
		{
			super(TypeDict.EDIT3D_SYSTEM_CLSNAME);
		}
	}
}
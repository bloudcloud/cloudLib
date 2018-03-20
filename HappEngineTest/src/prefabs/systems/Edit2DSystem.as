package prefabs.systems
{
	import happyECS.ecs.system.BaseHSystem;
	
	import prefabs.TypeDict;
	
	/**
	 * 2D编辑系统类
	 * @author cloud
	 * @2018-3-14
	 */
	public class Edit2DSystem extends BaseHSystem
	{
		public function Edit2DSystem()
		{
			super(TypeDict.EDIT2D_SYSTEM_CLSNAME);
		}
	}
}
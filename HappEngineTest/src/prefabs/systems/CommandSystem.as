package prefabs.systems
{
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.system.BaseHSystem;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 命令系统类
	 * @author cloud
	 * @2018-3-14
	 */
	public class CommandSystem extends BaseHSystem
	{
		public function CommandSystem()
		{
			super(PrefabTypeDict.COMMAND_SYSTEM_CLSNAME);
		}
		
		public function postAsynRequest(commandComponent:IHComponent):void
		{
		}
		
		
	}
}
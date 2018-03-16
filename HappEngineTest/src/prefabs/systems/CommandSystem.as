package prefabs.systems
{
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.system.BaseHSystem;
	
	/**
	 * 命令系统
	 * @author cloud
	 * @2018-3-14
	 */
	public class CommandSystem extends BaseHSystem
	{
		public function CommandSystem()
		{
			super();
		}
		
		public function postAsynRequest(commandComponent:IHComponent):void
		{
		}
	}
}
package extension.cloud.mvcs.scene.command
{
	import extension.cloud.mvcs.scene.service.CSceneService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * 业务场景服务启动命令
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CSceneServiceStartCommand implements ICommand
	{
		[Inject]
		public var sceneService:CSceneService;
		
		public function CSceneServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			sceneService.start();
		}
	}
}
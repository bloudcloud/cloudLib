package extension.cloud.mvcs.wall.command
{
	import extension.cloud.mvcs.wall.service.CWallService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * 业务墙体服务启动命令
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CWallServiceStartCommand implements ICommand
	{
		[Inject]
		public var wallService:CWallService;
		
		public function CWallServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			wallService.start();
		}
	}
}
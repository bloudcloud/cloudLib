package extension.cloud.mvcs.floor.command
{
	import extension.cloud.mvcs.floor.service.CFloorService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * 地面服务启动命令
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CFloorServiceStartCommand implements ICommand
	{
		[Inject]		
		public var floorService:CFloorService;
		
		public function CFloorServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			floorService.start();
		}
	}
}
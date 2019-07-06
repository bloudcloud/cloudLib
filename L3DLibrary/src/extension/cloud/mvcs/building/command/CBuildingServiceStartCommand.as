package extension.cloud.mvcs.building.command
{
	import extension.cloud.mvcs.building.service.CBuildingService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	/**
	 * 建筑服务启动命令
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CBuildingServiceStartCommand implements ICommand
	{
		[Inject]		
		public var buildingService:CBuildingService;
		
		public function CBuildingServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			buildingService.start();
		}
	}
}

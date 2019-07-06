package extension.cloud.mvcs.ceiling.command
{
	import extension.cloud.mvcs.ceiling.service.CCeilingService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * 业务天花服务启动命令
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CCeilingServiceStartCommand implements ICommand
	{
		[Inject]
		public var ceilingService:CCeilingService;
		
		public function CCeilingServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			ceilingService.start();
		}
	}
}
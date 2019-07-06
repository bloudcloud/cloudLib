package extension.cloud.mvcs.base.command
{
	import extension.cloud.mvcs.base.service.CKeyboardService;
	import extension.cloud.mvcs.base.service.CMouseService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * MVCS框架中的基础服务启动命令
	 * @author	cloud
	 * @date	2018-7-6
	 */
	public class CMVCSServiceStartCommand implements ICommand
	{
		[Inject]
		public var mouseService:CMouseService;
		[Inject]
		public var keyboardService:CKeyboardService;
		
		public function CMVCSServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			mouseService.start();
			keyboardService.start();
		}
	}
}
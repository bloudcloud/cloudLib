package extension.cloud.mvcs.room.command
{
	import extension.cloud.mvcs.room.service.CRoomService;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	
	/**
	 * 业务房间服务启动命令
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CRoomServiceStartCommand implements ICommand
	{
		[Inject]
		public var roomService:CRoomService;
		
		public function CRoomServiceStartCommand()
		{
		}
		
		public function execute():void
		{
			roomService.start();
		}
	}
}
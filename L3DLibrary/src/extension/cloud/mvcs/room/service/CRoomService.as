package extension.cloud.mvcs.room.service
{
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.room.model.CRoomModel;
	
	/**
	 * 房间服务类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CRoomService extends CBaseL3DService
	{
		[Inject]
		public var roomModel:CRoomModel;
		
		public function CRoomService()
		{
		}
		
		override protected function doStart():void
		{
			context.addEventListener(CL3DCommandEvent.EVENT_CREATE_ROOMDATA,onCreateRoomData);
		}

		override protected function doStop():void
		{
			context.removeEventListener(CL3DCommandEvent.EVENT_CREATE_ROOMDATA,onCreateRoomData);
			roomModel=null;
		}
		
		private function onCreateRoomData(evt:CL3DCommandEvent):void
		{
			
		}
	}
}
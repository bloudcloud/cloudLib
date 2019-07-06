package extension.cloud.mvcs.floor.service
{
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.floor.model.CFloorModel;
	
	/**
	 *	业务地面服务类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CFloorService extends CBaseL3DService
	{
		[Inject]
		public var floorModel:CFloorModel;
		
		public function CFloorService()
		{
			super();
		}
		override protected function doStart():void
		{
			context.addEventListener(CL3DCommandEvent.EVENT_CREATE_FLOORDATA,onCreateRoomData);
		}
		
		override protected function doStop():void
		{
			context.removeEventListener(CL3DCommandEvent.EVENT_CREATE_FLOORDATA,onCreateRoomData);
			floorModel=null;
		}
		
		private function onCreateRoomData(evt:CL3DCommandEvent):void
		{
			
		}
	}
}
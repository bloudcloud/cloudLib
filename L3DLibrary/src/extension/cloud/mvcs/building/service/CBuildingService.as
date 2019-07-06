package extension.cloud.mvcs.building.service
{
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.building.model.CBuildingModel;
	import extension.cloud.mvcs.room.model.CRoomModel;
	
	/**
	 *	业务建筑服务类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CBuildingService extends CBaseL3DService
	{
		[Inject]
		public var buildingModel:CBuildingModel;

		public function CBuildingService()
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
			buildingModel=null;
		}
		
		private function onCreateRoomData(evt:CL3DCommandEvent):void
		{
			
		}
	}
}
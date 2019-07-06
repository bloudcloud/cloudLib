package extension.cloud.mvcs.wall.service
{
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.wall.model.CWallModel;
	
	/**
	 * 业务墙体服务类
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CWallService extends CBaseL3DService
	{
		[Inject]
		public var wallModel:CWallModel;
		
		public function CWallService()
		{
			super();
		}
		
		override protected function doStart():void
		{
			context.addEventListener(CL3DCommandEvent.EVENT_CREATE_WALLDATA,onCreateWallData);
		}
		
		override protected function doStop():void
		{
			context.removeEventListener(CL3DCommandEvent.EVENT_CREATE_WALLDATA,onCreateWallData);
			wallModel=null;
		}
		
		private function onCreateWallData(evt:CL3DCommandEvent):void
		{
			
		}
	}
}
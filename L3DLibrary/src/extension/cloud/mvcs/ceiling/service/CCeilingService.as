package extension.cloud.mvcs.ceiling.service
{
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.ceiling.model.CCeilingModel;
	
	/**
	 * 业务天花服务类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CCeilingService extends CBaseL3DService
	{
		[Inject]
		public var ceilingModel:CCeilingModel;
		
		public function CCeilingService()
		{
			super();
		}
		override protected function doStart():void
		{
			context.addEventListener(CL3DCommandEvent.EVENT_CREATE_CEILINGDATA,onCreateCeilingData);
		}
		override protected function doStop():void
		{
			context.removeEventListener(CL3DCommandEvent.EVENT_CREATE_CEILINGDATA,onCreateCeilingData);
			ceilingModel=null;
		}
		
		private function onCreateCeilingData(evt:CL3DCommandEvent):void
		{
			
		}
	}
}
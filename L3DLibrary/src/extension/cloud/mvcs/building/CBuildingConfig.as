package extension.cloud.mvcs.building
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.building.command.CBuildingServiceStartCommand;
	import extension.cloud.mvcs.building.model.CBuildingModel;
	import extension.cloud.mvcs.building.model.data.CBuildingData;
	import extension.cloud.mvcs.building.service.CBuildingService;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务地面配置类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CBuildingConfig extends CBaseL3DConfig
	{
		public function CBuildingConfig()
		{
			super();
		}
		
		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_BUILDING_DATA,CBuildingData);
			injector.map(CBuildingModel).asSingleton();
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CBuildingServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CBuildingService).asSingleton();
		}
	}
}
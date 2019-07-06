package extension.cloud.mvcs.floor
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.floor.command.CFloorServiceStartCommand;
	import extension.cloud.mvcs.floor.model.CFloorModel;
	import extension.cloud.mvcs.floor.model.data.CFloorData;
	import extension.cloud.mvcs.floor.service.CFloorService;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务地面配置类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CFloorConfig extends CBaseL3DConfig
	{
		public function CFloorConfig()
		{
			super();
		}
		
		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_FLOOR_DATA,CFloorData);
			injector.map(CFloorModel).asSingleton();
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CFloorServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CFloorService).asSingleton();
		}
	}
}
package extension.cloud.mvcs.ceiling
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.ceiling.command.CCeilingServiceStartCommand;
	import extension.cloud.mvcs.ceiling.model.CCeilingModel;
	import extension.cloud.mvcs.ceiling.model.data.CCeilingData;
	import extension.cloud.mvcs.ceiling.service.CCeilingService;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务天花配置类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CCeilingConfig extends CBaseL3DConfig
	{
		public function CCeilingConfig()
		{
			super();
		}
		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_CEILING_DATA,CCeilingData);
			injector.map(CCeilingModel).asSingleton();
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CCeilingServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CCeilingService).asSingleton();
		}
	}
}
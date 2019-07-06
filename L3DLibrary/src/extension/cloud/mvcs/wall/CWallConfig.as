package extension.cloud.mvcs.wall
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.wall.command.CWallServiceStartCommand;
	import extension.cloud.mvcs.wall.model.CWallModel;
	import extension.cloud.mvcs.wall.model.data.CWallData;
	import extension.cloud.mvcs.wall.service.CWallService;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务墙体配置类
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CWallConfig extends CBaseL3DConfig
	{
		public function CWallConfig()
		{
		}
		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_WALL_DATA,CWallData);
			injector.map(CWallModel).asSingleton();
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CWallServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CWallService).asSingleton();
		}
		override protected function doAfterConfig():void
		{

		}
		override protected function doDestroyServices():void
		{
			
		}
	}
}
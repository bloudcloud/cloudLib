package extension.cloud.mvcs.scene
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.scene.command.CSceneServiceStartCommand;
	import extension.cloud.mvcs.scene.model.CSceneModel;
	import extension.cloud.mvcs.scene.model.data.CSceneSpaceData;
	import extension.cloud.mvcs.scene.service.CSceneService;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务房间配置类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CSceneConfig extends CBaseL3DConfig 
	{

		public function CSceneConfig()
		{
			super();
		}

		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_SCENESPACE_DATA,CSceneSpaceData);
			injector.map(CSceneModel).asSingleton();
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CSceneServiceStartCommand);
		}
		
		override protected function doConfigServices():void
		{
			injector.map(CSceneService).asSingleton();
		}
		
	}
}
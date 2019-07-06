package extension.cloud.mvcs.base
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.command.CMVCSServiceStartCommand;
	import extension.cloud.mvcs.base.model.CBaseEntity3DData;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	import extension.cloud.mvcs.base.service.CKeyboardService;
	import extension.cloud.mvcs.base.service.CMouseService;
	import extension.cloud.mvcs.base.view.CBaseL3DViewComponent;
	import extension.cloud.mvcs.base.view.CBaseL3DViewMediator;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.singles.CL3DClassFactory;

	/**
	 * 
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CMVCSGlobalConfig extends CBaseL3DConfig
	{
		
		public function CMVCSGlobalConfig()
		{
		}
		
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CMVCSServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CMouseService).asSingleton();
			injector.map(CKeyboardService).asSingleton();
		}
		override protected function doAfterConfig():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_BASEL3D_DATA,CBaseL3DData);
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_BASEENTITY_DATA,CBaseEntity3DData);
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_BASEL3D_VIEWCOMPONENT,CBaseL3DViewComponent);
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_BASEL3D_VIEW_MEDIATOR,CBaseL3DViewMediator);
			context.afterInitializing(init);
		}
		private function init():void
		{
			dispatcher.dispatchEvent(new Event(Event.INIT));
		}
	}
}
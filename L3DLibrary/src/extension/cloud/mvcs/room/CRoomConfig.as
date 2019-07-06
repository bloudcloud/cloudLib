package extension.cloud.mvcs.room
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.room.command.CRoomServiceStartCommand;
	import extension.cloud.mvcs.room.model.CRoomModel;
	import extension.cloud.mvcs.room.model.data.CRoomData;
	import extension.cloud.mvcs.room.service.CRoomService;
	import extension.cloud.mvcs.room.view.CRoomViewComponent;
	import extension.cloud.mvcs.room.view.CRoomViewComponentMediator;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 业务房间配置类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CRoomConfig extends CBaseL3DConfig
	{

		public function CRoomConfig()
		{
			super();
		}

		override protected function doConfigModels():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_ROOM_DATA,CRoomData);
			injector.map(CRoomModel).asSingleton();
			
		}
		override protected function doConfigMediators():void
		{
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_ROOM_VIEWCOMPONENT,CRoomViewComponent);
			CL3DClassFactory.Instance.registClassRef(CMVCSClassDic.CLASSNAME_ROOM_VIEWCOMPONENT_MEDIATOR,CRoomViewComponentMediator);
			mediatorMap.map(CRoomViewComponent).toMediator(CRoomViewComponentMediator);
		}
		override protected function doConfigCommands():void
		{
			commandMap.map(Event.INIT).toCommand(CRoomServiceStartCommand);
		}
		override protected function doConfigServices():void
		{
			injector.map(CRoomService).asSingleton();
		}
	}
}
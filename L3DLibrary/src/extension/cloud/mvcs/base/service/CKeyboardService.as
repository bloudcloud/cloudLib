package extension.cloud.mvcs.base.service
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import extension.cloud.mvcs.building.model.CBuildingModel;
	import extension.cloud.mvcs.room.model.CRoomModel;

	/**
	 * 业务键盘服务类
	 * @author	cloud
	 * @date	2018-7-6
	 */
	public class CKeyboardService extends CBaseL3DService
	{
		[Inject]
		public var buildingModel:CBuildingModel;
		[Inject]
		public var roomModel:CRoomModel;
		
		public function CKeyboardService()
		{
			super();
		}
		
		override protected function doStart():void
		{
			context.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			context.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		override protected function doStop():void
		{
			context.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			context.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		private function onKeyDown(evt:KeyboardEvent):void
		{
			if(evt.ctrlKey && evt.keyCode==Keyboard.A)
			{
				//将选中的房间添加到当前操作的建筑中
//				buildingModel.addRoom(roomModel.currentRoom.uniqueID);
			}
		}
		private function onKeyUp(evt:KeyboardEvent):void
		{
			
		}
	}
}
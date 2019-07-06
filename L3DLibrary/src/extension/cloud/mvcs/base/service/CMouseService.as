package extension.cloud.mvcs.base.service
{
	import flash.events.MouseEvent;
	
	import extension.cloud.mvcs.room.model.CRoomModel;

	/**
	 * 业务鼠标服务类
	 * @author	cloud
	 * @date	2018-7-6
	 */
	public class CMouseService extends CBaseL3DService
	{
		[Inject]
		public var roomModel:CRoomModel;
		
		public function CMouseService()
		{
			super();
		}
		
		override protected function doStart():void
		{
			context.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			context.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		override protected function doStop():void
		{
			context.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			context.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private function onMouseDown(evt:MouseEvent):void
		{
//			roomModel.updateCurrentRoom(evt.localX,evt.localY);
		}
		private function onMouseUp(evt:MouseEvent):void
		{
			
		}
	}
}
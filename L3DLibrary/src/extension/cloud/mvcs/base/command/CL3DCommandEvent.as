package extension.cloud.mvcs.base.command
{
	import flash.events.Event;
	
	/**
	 * 业务命令事件类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CL3DCommandEvent extends Event
	{
		public static const EVENT_CREATE_FLOORDATA:String="createFloorData";
		public static const EVENT_CREATE_WALLDATA:String="createWallData";
		public static const EVENT_CREATE_CEILINGDATA:String="createCeilingData";
		public static const EVENT_CREATE_ROOMDATA:String="createRoomData";
		public static const EVENT_CREATE_SCENEDATA:String="createSceneData";
		public static const EVENT_UPDATE_WALLINE:String="updateWallLine";
		public static const EVENT_DRAW_WALLLINE:String="drawWallLine";
		public static const EVENT_DRAW_ROOM:String="drawRoom";
		public static const EVENT_REMOVE_FLOORDATA:String="removeFloorData";
		public static const EVENT_REMOVE_WALLDATA:String="removeWallData";
		public static const EVENT_DRAW_SCENEPOLY:String="drawScenePoly";
		public static const EVENT_CLEAR_SCENE:String="clearcene";
		public static const EVENT_SEND_LINEMARK:String="sendLineMark";
		/**S
		 * 通知闭合区域发生改变 
		 */		
		public static const NOTIFY_CLOSEDAREA_CHANGED:String="closedAreaChanged";
		/**
		 * 通知获取的线条数据 
		 */		
		public static const NOTIFY_GET_LINEUNIQUEID:String="getLineUniqueID";
		/**
		 * 通知墙线发生改变 
		 */		
		public static const NOTIFY_LINE_CHANGED:String="lineChanged";
		
		private var _l3dData:*;
		
		public function get l3dData():*
		{
			return _l3dData;
		}
		public function CL3DCommandEvent(type:String, data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_l3dData=data;
		}
		override public function clone():Event
		{
			return new CL3DCommandEvent(type,_l3dData);
		}
	}
}
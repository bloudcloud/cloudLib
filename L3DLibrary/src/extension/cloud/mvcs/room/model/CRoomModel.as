package extension.cloud.mvcs.room.model
{
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseL3DModel;
	import extension.cloud.mvcs.room.model.data.CRoomData;
	import extension.cloud.singles.CL3DModuleUtil;

	/**
	 * 业务房间数据模型
	 * @author cloud
	 * @date	2018-6-25
	 */
	public class CRoomModel extends CBaseL3DModel
	{
			
		public function CRoomModel()
		{
			super();
		}
		/**
		 * 创建房间数据 
		 * @param roomPoint3DValues	房间围点坐标值集合
		 * @param area	房间面积
		 * @param offGround		房间的离地高	
		 * @param className		房间数据类定义名
		 * @param ownerID		房间所属数据的唯一ID
		 * @param uniqueID		房间的唯一ID
		 * @param name		房间名
		 * @param type		房间的类型
		 * 
		 */		
		public function createRoomData(roomPoint3DValues:Vector.<Number>,area:Number,offGround:Number,className:String,ownerID:String,uniqueID:String,name:String=null,type:int=0):void
		{
			var roomData:CRoomData;
			
			roomData=CL3DModuleUtil.Instance.createL3DData(className,ownerID,uniqueID,name,type) as CRoomData;
			roomData.roomPoint3DValues=roomPoint3DValues;
			roomData.area=area;
			roomData.offGround=offGround;
			doAddBaseData(roomData);
		}
		/**
		 * 更新房间数据 
		 * @param roomPoint3DValues	房间围点坐标值集合
		 * @param area	房间面积
		 * @param offGround	离地高
		 * @param roomID	房间ID
		 * 
		 */		
		public function updateRoomData(roomPoint3DValues:Vector.<Number>,area:Number,offGround:Number,roomID:String):void
		{
			var roomData:CRoomData;
			roomData=doGetBaseDataFromID(roomID) as CRoomData;
			roomData.roomPoint3DValues=roomPoint3DValues;
			roomData.area=area;
			roomData.offGround=offGround;
		}
		/**
		 * 删除房间数据，之前生成的房间数据销毁 
		 * @param areaID		闭合区域ID
		 * @return String
		 * 
		 */		
		public function removeRoomData(roomID:String):void
		{
			doRemoveBaseData(roomID);
		}
	}
}
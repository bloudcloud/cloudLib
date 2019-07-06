package extension.cloud.mvcs.building.model
{
	import extension.cloud.mvcs.base.model.CBaseL3DModel;
	import extension.cloud.mvcs.building.model.data.CBuildingData;
	
	/**
	 * 业务建筑数据模型类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CBuildingModel extends CBaseL3DModel
	{
		private var _currentBuilding:CBuildingData;
		
		public function CBuildingModel()
		{
			super();
		}
		/**
		 * 添加一个房间 
		 * @param roomID
		 * 
		 */		
		public function addRoom(roomID:String):void
		{
			if(_currentBuilding.roomIDs.indexOf(roomID)<0)
			{
				_currentBuilding.roomIDs.push(roomID);
			}
		}
	}
}
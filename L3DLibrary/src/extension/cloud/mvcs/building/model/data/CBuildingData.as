package extension.cloud.mvcs.building.model.data
{
	import extension.cloud.mvcs.base.model.CBaseEntity3DData;
	
	/**
	 * 业务建筑数据类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CBuildingData extends CBaseEntity3DData
	{
		public var roomIDs:Array;
		
		public function CBuildingData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID);
			roomIDs=[];
		}
	}
}
package extension.cloud.mvcs.floor.model.data
{
	import extension.cloud.mvcs.base.model.CBaseEntity3DData;
	
	/**
	 * 业务地面数据类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CFloorData extends CBaseEntity3DData
	{
		public var url:String;
		
		public function CFloorData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID);
		}
	}
}
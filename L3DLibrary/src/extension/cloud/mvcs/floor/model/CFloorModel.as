package extension.cloud.mvcs.floor.model
{
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.utils.CMathUtilForAS;
	
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseL3DModel;
	import extension.cloud.mvcs.floor.model.data.CFloorData;
	import extension.cloud.singles.CL3DModuleUtil;
	
	import ns.cloud_lejia;
	
	use namespace cloud_lejia;
	/**
	 * 业务地面数据模型类
	 * @author	cloud
	 * @date	2018-7-3
	 */
	public class CFloorModel extends CBaseL3DModel
	{
		
		public function CFloorModel()
		{
			super();
		}
		/**
		 * 创建地面数据
		 * @param floorUrl
		 * @param point3DValues
		 * @param transform
		 * @param className
		 * @param ownerID
		 * @param uniqueID
		 * @param floorUrl
		 * @param name
		 * @param type
		 * 
		 */		
		public function createFloorData(floorUrl:String,point3DValues:Vector.<Number>, transform:CTransform3D, className:String, ownerID:String, uniqueID:String,name:String=null,type:int=0):void
		{
			var floorData:CFloorData;
			
			floorData=CL3DModuleUtil.Instance.createEntity3DData(point3DValues,transform,className,ownerID,uniqueID,name,type) as CFloorData;
			floorData.url=floorUrl;
			floorData.outline3DBox=CMathUtilForAS.Instance.calculateCBoundBox3D(point3DValues,transform);
			doAddBaseData(floorData);
		}
		/**
		 * 更新地面数据
		 * @param point3DValues
		 * @param ownerID
		 * @param name
		 * @param type
		 * 
		 */	
		public function updateFloorData(point3DValues:Vector.<Number>, areaID:String, ownerID:String, name:String=null,type:int=0):void
		{
			var floorData:CFloorData=doGetBaseDatasFromOwnerID(ownerID)[0] as CFloorData;
			doRemoveBaseData(floorData.uniqueID);
			floorData.uniqueID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.FLOOR_SYMBOL,areaID);
			floorData.ownerID=ownerID;
			floorData.outline3DBox=CMathUtilForAS.Instance.calculateCBoundBox3D(point3DValues,floorData.transform);
			doAddBaseData(floorData);
		}
		/**
		 * 移除地面数据 
		 * @param floorID
		 * 
		 */		
		public function removeFloorData(floorID:String):void
		{
			doRemoveBaseData(floorID);
		}
		public function searchFloorData(ownerID:String):Boolean
		{
			var floorData:CFloorData=doGetBaseDatasFromOwnerID(ownerID)[0] as CFloorData;
			return floorData!=null;
		}
	}
}
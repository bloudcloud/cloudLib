package extension.cloud.mvcs.wall.model
{
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.utils.CMathUtilForAS;
	
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	import extension.cloud.mvcs.base.model.CBaseL3DModel;
	import extension.cloud.mvcs.wall.model.data.CWallData;
	import extension.cloud.singles.CL3DModuleUtil;
	
	/**
	 * 业务墙体数据模型类
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CWallModel extends CBaseL3DModel
	{
			
		public function CWallModel()
		{
			super();
		}
		/**
		 * 创建墙体数据
		 * @param point3DValues
		 * @param transform
		 * @param className
		 * @param ownerID
		 * @param uniqueID
		 * @param name
		 * @param type
		 * 
		 */		
		public function createWallData(startPos:Vector3D,endPos:Vector3D,transform:CTransform3D, className:String, ownerID:String, uniqueID:String, name:String=null, type:int=0):void
		{
			var wallData:CWallData;
			var wallRoundPoints:Vector.<Number>;
			
			wallRoundPoints=new Vector.<Number>();
			wallRoundPoints.push(startPos.x,startPos.y,startPos.z);
			wallRoundPoints.push(endPos.x,endPos.y,endPos.z);
			wallRoundPoints.push(endPos.x,endPos.y,endPos.z+CL3DConstDict.DEFAULT_WALL_HEIGHT);
			wallRoundPoints.push(startPos.x,startPos.y,startPos.z+CL3DConstDict.DEFAULT_WALL_HEIGHT);
			wallData=CL3DModuleUtil.Instance.createEntity3DData(wallRoundPoints,transform,className,ownerID,uniqueID,name,type) as CWallData;
			wallData.outline3DBox=CMathUtilForAS.Instance.calculateCBoundBox3D(wallRoundPoints,transform);
			wallData.start=startPos;
			wallData.end=endPos;
			doAddBaseData(wallData);
		}
		
		public function updateWallData(wallData:CWallData,wallRoundPoints:Vector.<Number>,startPos:Vector3D,endPos:Vector3D,transform:CTransform3D,ownerID:String,name:String=null,type:int=0):void
		{
			wallData.ownerID=ownerID;
			wallData.name=name;
			wallData.type=type;
			wallData.roundPoint3DValues=wallRoundPoints;
			wallData.transform=transform;
			wallData.outline3DBox=CMathUtilForAS.Instance.calculateCBoundBox3D(wallRoundPoints,transform);
			wallData.start=startPos;
			wallData.end=endPos;
		}
		public function removeWalls(roomID:String):void
		{
			doRemoveBaseDatasByOwnerID(roomID);
		}
		private function doRemoveWallData(wallData:CWallData,start3D:Vector3D,end3D:Vector3D):Boolean
		{
			if(CMathUtilForAS.Instance.isEqualVector3D(wallData.start,start3D) && 
				CMathUtilForAS.Instance.isEqualVector3D(wallData.end,end3D))
			{
				doRemoveBaseData(wallData.uniqueID);
				return true;
			}
			return false;
		}
		/**
		 * 移除墙体数据 
		 * @param start3D
		 * @param end3D
		 * @return Boolean	是否成功移除
		 * 
		 */		
		public function removeWallData(start3D:Vector3D,end3D:Vector3D):Boolean
		{
			return doMapBaseData(doRemoveWallData,start3D,end3D);
		}
//		/**
//		 * 通过房间区域创建墙体数据对象集合
//		 * @param point3DValues		房间围点坐标值集合
//		 * @param transform	房间的线性变换对象
//		 * @param className	墙体类型定义名
//		 * @param ownerID		墙体所有者的唯一ID（房间的唯一ID）
//		 * @param uniqueID		墙体的唯一ID
//		 * @param name	墙体的名称
//		 * @param type	墙体的类型
//		 * 
//		 */		
//		public function createWallDatasFromClosedArea(point3DValues:Vector.<Number>, transform:CTransform3D, className:String, ownerID:String, uniqueID:String, name:String=null, type:int=0):void
//		{
//			var i:int,len:int,next:int;
//			var outLinePointValues:Vector.<Number>;
//			var cross:Vector3D,dir:Vector3D,center:Vector3D;
//			
//			outLinePointValues=new Vector.<Number>();
//			cross=new Vector3D();
//			dir=new Vector3D();
//			center=new Vector3D();
//			len=point3DValues.length/3;
//			for(i=0; i<len; i++)
//			{
//				outLinePointValues.length=0;
//				next=i==len-1?0:i+1;
//				dir.setTo(point3DValues[next*3]-point3DValues[i*3],point3DValues[next*3+1]-point3DValues[i*3+1],point3DValues[next*3+2]-point3DValues[i*3+2]);
//				dir.normalize(); 
//				center.setTo((point3DValues[next*3]+point3DValues[i*3])*.5,(point3DValues[next*3+1]+point3DValues[i*3+1])*.5,(point3DValues[next*3+2]+point3DValues[i*3+2])*.5);
//				outLinePointValues.push(point3DValues[i*3],point3DValues[i*3+1],point3DValues[i*3+2]);
//				outLinePointValues.push(point3DValues[next*3],point3DValues[next*3+1],point3DValues[next*3+2]);
//				outLinePointValues.push(point3DValues[next*3],point3DValues[next*3+1],point3DValues[next*3+2]+CL3DConstDict.DEFAULT_WALL_HEIGHT*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
//				outLinePointValues.push(point3DValues[i*3],point3DValues[i*3+1],point3DValues[i*3+2]+CL3DConstDict.DEFAULT_WALL_HEIGHT*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
//
//				CMathUtil.Instance.calculateCrossVector3D(dir,Vector3D.Z_AXIS,cross);
//				CMathUtil.Instance.calculateTransform3D(transform,dir,cross,Vector3D.Z_AXIS,center);
//				doCreateWallData(point3DValues,transform,CMVCSClassDic.CLASSNAME_WALL_DATA,ownerID,CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.WALL_SYMBOL));
//			}
//		}
		
	}
}
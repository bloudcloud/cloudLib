package extension.cloud.mvcs.scene.service
{
	import flash.geom.Vector3D;
	
	import cloud.core.collections.ICDoubleNode;
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.datas.CClosedLine3DArea;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.service.CBaseL3DService;
	import extension.cloud.mvcs.ceiling.model.CCeilingModel;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.floor.model.CFloorModel;
	import extension.cloud.mvcs.room.model.CRoomModel;
	import extension.cloud.mvcs.scene.model.CSceneModel;
	import extension.cloud.mvcs.wall.model.CWallModel;
	import extension.cloud.singles.CL3DModuleUtil;
	
	import ns.cloud_lejia;
	
	use namespace cloud_lejia;
	/**
	 * 业务场景服务类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CSceneService extends CBaseL3DService
	{
		[Inject]
		public var sceneModel:CSceneModel;
		[Inject]
		public var wallModel:CWallModel;
		[Inject]
		public var roomModel:CRoomModel;
		[Inject]
		public var floorModel:CFloorModel;
		[Inject]
		public var ceilingModel:CCeilingModel;
		
		public function CSceneService()
		{
			super();
		}
		override protected function doStart():void
		{
			context.addEventListener(CL3DCommandEvent.EVENT_CREATE_SCENEDATA,onCreateSceneData);
			context.addEventListener(CL3DCommandEvent.EVENT_DRAW_WALLLINE,onDrawWallLine);
			context.addEventListener(CL3DCommandEvent.EVENT_DRAW_ROOM,onDrawRoom);
			context.addEventListener(CL3DCommandEvent.EVENT_UPDATE_WALLINE,onUpdateWallLines);
			context.addEventListener(CL3DCommandEvent.EVENT_SEND_LINEMARK,onSendLineMark);
			context.addEventListener(CL3DCommandEvent.EVENT_CLEAR_SCENE,onClearScene);
//			context.addEventListener(CL3DCommandEvent.EVENT_DRAW_SCENEPOLY,onDrawScenePoly);
			context.addEventListener(CL3DCommandEvent.EVENT_REMOVE_FLOORDATA,onRemoveFloorData);
			context.addEventListener(CL3DCommandEvent.EVENT_REMOVE_WALLDATA,onRemoveWallData);
		}
		
		override protected function doStop():void
		{
			context.removeEventListener(CL3DCommandEvent.EVENT_CREATE_SCENEDATA,onCreateSceneData);
			context.removeEventListener(CL3DCommandEvent.EVENT_DRAW_WALLLINE,onDrawWallLine);
			context.removeEventListener(CL3DCommandEvent.EVENT_UPDATE_WALLINE,onUpdateWallLines);
			context.removeEventListener(CL3DCommandEvent.EVENT_CLEAR_SCENE,onClearScene);
			context.removeEventListener(CL3DCommandEvent.EVENT_DRAW_SCENEPOLY,onDrawScenePoly);
			context.removeEventListener(CL3DCommandEvent.EVENT_REMOVE_FLOORDATA,onRemoveFloorData);
			context.removeEventListener(CL3DCommandEvent.EVENT_REMOVE_WALLDATA,onRemoveWallData);
			sceneModel=null;
		}
		
		private function onClearScene(evt:CL3DCommandEvent):void
		{
			print("执行CSceneService->clearScene()",evt.toString());
			sceneModel.clearAllCache();
			wallModel.clearAllCache();
			floorModel.clearAllCache();
			ceilingModel.clearAllCache();
			roomModel.clearAllCache();
		}
		private function onRemoveWallData(evt:CL3DCommandEvent):void
		{
			sceneModel.setCurrentSceneSpaceData(evt.l3dData.sceneKey);
			sceneModel.removeWallLine(evt.l3dData.start3D,evt.l3dData.end3D);
			wallModel.removeWallData(evt.l3dData.start3D,evt.l3dData.end3D);
		}
		private function onRemoveFloorData(evt:CL3DCommandEvent):void
		{
			var areaID:String;
			var floorID:String;
			var roomID:String;
			var sceneKey:String=evt.l3dData.sceneKey;
			floorID=evt.l3dData.floorID;
			roomID=evt.l3dData.roomID;
			
			sceneModel.setCurrentSceneSpaceData(sceneKey);
			areaID=floorID.split(CL3DConstDict.STRING_LINKSYMBOL)[1];
			if(evt.l3dData.isClearWall)
			{
				wallModel.removeWalls(roomID);
			}
			sceneModel.removeAreaCacheNode(areaID);
			floorModel.removeFloorData(floorID);
			roomModel.removeRoomData(roomID);
		}
		private function onCreateSceneData(evt:CL3DCommandEvent):void
		{
			print("执行CSceneService->onCreateSceneData()",evt.toString());
		}
		private function onSendLineMark(evt:CL3DCommandEvent):void
		{
			var start3D:Vector3D=evt.l3dData.start3D;
			var end3D:Vector3D=evt.l3dData.end3D;
			var lineDataID:String=sceneModel.getCurrentSceneLineID(start3D,end3D);
			dispatchEventForProxy(new CL3DCommandEvent(CL3DCommandEvent.NOTIFY_GET_LINEUNIQUEID,{id:lineDataID,start3D:start3D,end3D:end3D}));
		}
		private function onUpdateWallLines(evt:CL3DCommandEvent):void
		{
			var oStart3D:Vector3D,oEnd3D:Vector3D,start3D:Vector3D,end3D:Vector3D,prevPos:Vector3D,nextPos:Vector3D;
			var sceneKey:String;
			var roomOffGround:Number;
			var floorUrl:String;
			var obj:Object;
			var i:int;
			
			sceneKey=evt.l3dData.sceneKey;
			roomOffGround=Number(sceneKey);
			sceneModel.setCurrentSceneSpaceData(sceneKey);
			sceneModel.changedWallLines.length=0;
			for(i=evt.l3dData.line3DDatas.length-1;i>=0;i--)
			{
				obj=evt.l3dData.line3DDatas[i];
				oStart3D=obj.oStart3D;
				oEnd3D=obj.oEnd3D;
				start3D=obj.start3D;
				end3D=obj.end3D;
				floorUrl=obj.floorUrl;
				if(obj.prev3DPos)
				{
					prevPos=obj.prev3DPos;
				}
				if(obj.next3DPos)
				{
					nextPos=obj.next3DPos;
				}
				sceneModel.addUpdatedWallLine(oStart3D,oEnd3D,start3D,end3D,prevPos,nextPos);
			}
			var lines:Array=[];
			for(i=sceneModel.changedWallLines.length-1; i>=0; i--)
			{
				lines.push(sceneModel.changedWallLines[i]);
			}
			dispatchEventForProxy(new CL3DCommandEvent(CL3DCommandEvent.NOTIFY_LINE_CHANGED,lines));
			//查找生成闭合区域
			sceneModel.searchClosedAreas(true);
			if(sceneModel.areaCacheNode && (sceneModel.areaCacheNode.nodeData as CClosedLine3DArea).isExit)
			{
				//根据缓存的区域状态，处理相关数据更新或者创建
				var changedArr:Array=[];
				doUpdateSceneDataByAreaData(sceneModel.areaCacheNode,changedArr,roomOffGround,floorUrl);
			}
		}

		private function onDrawWallLine(evt:CL3DCommandEvent):void
		{
			//添加墙线
			var start3D:Vector3D,end3D:Vector3D;
			var sceneKey:String;
			var newRoomID:String,floorUrl:String;
			
			sceneKey=evt.l3dData.sceneKey;
			floorUrl=evt.l3dData.floorUrl;
			newRoomID=evt.l3dData.roomID;
			start3D=CL3DModuleUtil.Instance.amendPosition3DByVector3D(evt.l3dData.start2D,CL3DConstDict.POSITIONMODE_SCENE2D,CL3DConstDict.POSITIONMODE_SCENE3D);
			end3D=CL3DModuleUtil.Instance.amendPosition3DByVector3D(evt.l3dData.end2D,CL3DConstDict.POSITIONMODE_SCENE2D,CL3DConstDict.POSITIONMODE_SCENE3D);
			sceneModel.addSceneLine(sceneKey,start3D,end3D,true);
			var lines:Array=[];
			for(var i:int=sceneModel.changedWallLines.length-1; i>=0; i--)
			{
				lines.push(sceneModel.changedWallLines[i]);
			}
			dispatchEventForProxy(new CL3DCommandEvent(CL3DCommandEvent.NOTIFY_LINE_CHANGED,lines));
			if(sceneModel.areaCacheNode && (sceneModel.areaCacheNode.nodeData as CClosedLine3DArea).isExit)
			{
				//根据缓存的区域状态，处理相关数据更新或者创建
				var changedArr:Array=[];
				doUpdateSceneDataByAreaData(sceneModel.areaCacheNode,changedArr,Number(sceneKey),floorUrl,newRoomID);
			}
		}
		
		private function onDrawRoom(evt:CL3DCommandEvent):void
		{
			var roundPoints:Vector.<Number>;
			var roomID:String,floorID:String,areaID:String;
			var roomType:int;
			var sceneKey:String,floorUrl:String;
			var areaData:CClosedLine3DArea;
			var roomOffGround:Number;
			var newRoundPoints:Vector.<Number>;
			var i:int;

			roundPoints=evt.l3dData.roundPoints;
			sceneKey=evt.l3dData.sceneKey;
			floorUrl=evt.l3dData.floorUrl;
			roomType=evt.l3dData.roomType;
			floorID=evt.l3dData.floorID;
			roomID=evt.l3dData.roomID;
			roomOffGround=Number(sceneKey);
			if(floorID)
			{
				var arr:Array=floorID.split(CL3DConstDict.STRING_LINKSYMBOL);
				areaID=arr[1];
				if(areaID==null)
				{
					areaID=CUtil.Instance.createUID();
					floorID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.FLOOR_SYMBOL,CUtil.Instance.createUID());
				}
			}
			else
			{
				areaID=CUtil.Instance.createUID();
				floorID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.FLOOR_SYMBOL,CUtil.Instance.createUID());
			}
			if(!roomID)
			{
				roomID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.ROOM_SYMBOL,areaID);
			}
			sceneModel.addScene3DLinesByRoundPoints(roundPoints,areaID,sceneKey);
			var lines:Array=[];
			for(i=sceneModel.changedWallLines.length-1; i>=0; i--)
			{
				lines.push(sceneModel.changedWallLines[i]);
			}
			dispatchEventForProxy(new CL3DCommandEvent(CL3DCommandEvent.NOTIFY_LINE_CHANGED,lines));
			//查找生成闭合区域
			sceneModel.searchClosedAreas();
			if(sceneModel.areaCacheNode && (sceneModel.areaCacheNode.nodeData as CClosedLine3DArea).isExit)
			{
				//根据缓存的区域状态，处理相关数据更新或者创建
				var changedArr:Array=[];
				doUpdateSceneDataByAreaData(sceneModel.areaCacheNode,changedArr,roomOffGround,floorUrl,roomID);
			}
		}
		private function onDrawScenePoly(evt:CL3DCommandEvent):void
		{
//			sceneModel.addPoly(evt.l3dData as Array);
		}
		private function doUpdateSceneDataByAreaData(areaNode:ICDoubleNode,changedAreas:Array,offGround:Number,floorUrl:String,newRoomID:String=null):void
		{
			if(!changedAreas)
			{
				return;
			}
			var roomID:String;
			if(!areaNode)
			{
				if(changedAreas.length)
				{
					var changedArr:Array=[];
					for each(var area:CClosedLine3DArea in changedAreas)
					{
						roomID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.ROOM_SYMBOL,area.uniqueID);
						changedArr.push({floors:floorModel.doGetBaseDatasFromOwnerID(roomID),walls:wallModel.doGetBaseDatasFromOwnerID(roomID),rooms:roomModel.doGetBaseDataByUniqueID(roomID)});
					}
					dispatchEventForProxy(new CL3DCommandEvent(CL3DCommandEvent.NOTIFY_CLOSEDAREA_CHANGED,changedArr));
					changedAreas.length=0;
				}
				return;
			}
			var areaData:CClosedLine3DArea=areaNode.nodeData as CClosedLine3DArea;
			switch(areaData.stateType)
			{
				case CClosedLine3DArea.CREATE:
					if(newRoomID)
					{
						roomID=newRoomID;
						(areaData as CClosedLine3DArea).updateAreaID(roomID.split(CL3DConstDict.STRING_LINKSYMBOL)[1]);
					}
					else
					{
						roomID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.ROOM_SYMBOL,areaData.uniqueID);
					}
					doCreateWallDatasByAreaData(areaData.roundPoints,roomID);
					floorModel.createFloorData(floorUrl,areaData.roundPoints,CTransform3D.CreateOneInstance(),CMVCSClassDic.CLASSNAME_FLOOR_DATA,roomID,CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.FLOOR_SYMBOL,areaData.uniqueID));
					roomModel.createRoomData(areaData.roundPoints,areaData.area,offGround,CMVCSClassDic.CLASSNAME_ROOM_DATA,null,roomID);
					changedAreas.push(areaData);
					areaData.stateType=CClosedLine3DArea.NORMAL;
					break;
				case CClosedLine3DArea.UPDATE:
					//更新房间
					roomID=CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.ROOM_SYMBOL,areaData.uniqueID);
					doCreateWallDatasByAreaData(areaData.roundPoints,roomID);
					floorModel.updateFloorData(areaData.roundPoints,areaData.uniqueID,roomID);
					roomModel.updateRoomData(areaData.roundPoints,areaData.area,offGround,roomID);
					changedAreas.push(areaData);
					areaData.stateType=CClosedLine3DArea.NORMAL;
					break;
			}
			doUpdateSceneDataByAreaData(areaNode.next,changedAreas,offGround,floorUrl,newRoomID);
		}
		private function doCreateWallDatasByAreaData(roundPoints:Vector.<Number>,ownerID:String):void
		{
			var i:int,len:int,next:int;
			var start3D:Vector3D,end3D:Vector3D,center:Vector3D,dir:Vector3D,cross:Vector3D;
			var tmpTransform:CTransform3D;
			var wallID:String;
			
			start3D=new Vector3D();
			end3D=new Vector3D();
			center=new Vector3D();
			dir=new Vector3D();
			cross=new Vector3D();
			tmpTransform=CTransform3D.CreateOneInstance();
			wallModel.removeWalls(ownerID);
			len=roundPoints.length/3;
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				start3D.setTo(roundPoints[i*3],roundPoints[i*3+1],roundPoints[i*3+2]);
				end3D.setTo(roundPoints[next*3],roundPoints[next*3+1],roundPoints[next*3+2]);
				wallID=sceneModel.getCurrentSceneLineID(start3D,end3D);
				dir.setTo(end3D.x-start3D.x,end3D.y-start3D.y,end3D.z-start3D.z);
				dir.normalize();
				center.setTo((end3D.x+start3D.x)*.5,(end3D.y+start3D.y)*.5,(end3D.z+start3D.z)*.5);
				CMathUtil.Instance.calculateCrossVector3D(dir,Vector3D.Z_AXIS,cross);
				CMathUtil.Instance.calculateTransform3D(tmpTransform,dir,cross,Vector3D.Z_AXIS,center);
				wallModel.createWallData(start3D,end3D,tmpTransform,CMVCSClassDic.CLASSNAME_WALL_DATA,ownerID,wallID);
			}
			tmpTransform.back();
		}
		
	}
}
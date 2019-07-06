package extension.cloud.mvcs.scene.model
{
	import flash.geom.Vector3D;
	
	import cloud.core.collections.CDoubleNode;
	import cloud.core.collections.CTreeNode;
	import cloud.core.collections.ICClosedArea;
	import cloud.core.collections.ICDoubleNode;
	import cloud.core.datas.maps.CHashMap;
	import cloud.core.interfaces.ICLine;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CMathUtilForAS;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.datas.CClosedLine3DArea;
	import extension.cloud.datas.CWallLineData;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	import extension.cloud.mvcs.base.model.CBaseL3DModel;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.mvcs.scene.model.data.CSceneSpaceData;
	import extension.cloud.singles.CL3DModuleUtil;
	
	import ns.cloud_lejia;
	
	use namespace cloud_lejia;
	/**
	 * 业务场景数据模型类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CSceneModel extends CBaseL3DModel
	{
		/**
		 * 场景数据集合 
		 */		
		private var _sceneDataMap:CHashMap;
		private var _currentSceneData:CSceneSpaceData;
		/**
		 * 发生改变的墙线数据集合
		 */		
		private var _changedWallLines:Array;
		private var _changedAreaDatas:Array;

		public function get changedWallLines():Array
		{
			return _changedWallLines;
		}
		
		public function get areaCacheNode():ICDoubleNode
		{
//			if(_currentSceneData.areaCacheNode && _currentSceneData.areaCacheNode.nodeLength==1)
//			{
//				_currentSceneData.areaCacheNode=null;
//			}
			return _currentSceneData.areaCacheNode;
		}

		public function CSceneModel()
		{
			super();
			_changedWallLines=[];
			_changedAreaDatas=[];
			_sceneDataMap=new CHashMap();
		}
		
		public function setCurrentSceneSpaceData(sceneKey:String):void
		{
			_currentSceneData=_sceneDataMap.get(sceneKey) as CSceneSpaceData;
			if(_currentSceneData==null)
			{
				_currentSceneData=new CSceneSpaceData(CMVCSClassDic.CLASSNAME_SCENESPACE_DATA,CUtil.Instance.createUID());
				_sceneDataMap.put(sceneKey,_currentSceneData);
			}
		}
		
		public function addSceneLine(sceneKey:String,start3D:Vector3D,end3D:Vector3D,isClearChanged:Boolean):void
		{
			setCurrentSceneSpaceData(sceneKey);
			addWallLineBySegment(start3D,end3D,isClearChanged);
			//搜索闭合区间，过滤掉负旋转方向的闭合区间
			searchClosedAreas(true);
		}
		private function doTravelLine(lineTreeNode:CTreeNode):Boolean
		{
			var lineData:CWallLineData;
			var key:String;
			var curDir:Vector3D,targetDir:Vector3D;
			var group:Vector.<CTreeNode>;
			var i:int,glen:int;
			var tmpLineData:CWallLineData;
			var traveledMarkMap:CHashMap;
			var rootLineNode:CTreeNode;
			var searchedLineDatas:Vector.<ICLine>;
			
			lineData=lineTreeNode.nodeData as CWallLineData;
			if(!lineData)
			{
				return false;
			}
			traveledMarkMap=_currentSceneData.traveledMarkMap;
			key=lineData.end.toString();
			if(traveledMarkMap.containsKey(key))
			{
				rootLineNode=_currentSceneData.rootLineNode;
				if(key!=(rootLineNode.nodeData as CWallLineData).start.toString())
				{
					//找到已标记过访问的点,当前查找失败，返回false
					return false;
				}
				else
				{
					//找回到起始点，闭合区域搜索完成，结束搜索
					searchedLineDatas=_currentSceneData.searchedLineDatas;
					var func:Function=function(node:CTreeNode):void
					{
						node.isMarked=true;
						searchedLineDatas.unshift(node.nodeData as ICLine);
						if(node.parent)
						{
							func(node.parent);
						}
					}
					func(lineTreeNode);
					func=null;
					return true;
				}
			}
			//遍历将当前线条终点作为起点的所有线条，默认遍历正向
			group=_currentSceneData.getSceneLineGroup(key);
			if(!group)
			{
				return false;
			}
			//记录当前访问标记
			traveledMarkMap.put(lineData.start.toString(),true);
			curDir=new Vector3D();
			targetDir=new Vector3D();
			curDir.copyFrom(lineData.direction);
			glen=group.length;
			var posArr:Array=[];
			var negArr:Array=[];
			//创建遍历树
			for(i=0; i<glen; i++)
			{
				tmpLineData=group[i].nodeData as CWallLineData;
				if(group[i].isMarked)
				{
					//使用过的不再使用
					continue;
				}
				targetDir.setTo(-tmpLineData.direction.x,-tmpLineData.direction.y,-tmpLineData.direction.z);
				if(CMathUtilForAS.Instance.isEqualVector3D(curDir,targetDir))
				{
					//如果找到反向线条
					continue;
				}
				if(CMathUtilForAS.Instance.is2DPositiveRotation(lineData.direction.x,lineData.direction.y,tmpLineData.direction.x,tmpLineData.direction.y))
				{
					posArr.push([lineData.direction.dotProduct(tmpLineData.direction),i]);
				}
				else
				{
					negArr.push([lineData.direction.dotProduct(tmpLineData.direction),i]);
				}
			}
			//执行最优遍历排序
			posArr.sort(doCompareDotValue);
			negArr.sort(doCompareDotValue);
			for(i=negArr.length-1; i>=0; i--)
			{
				lineTreeNode.addChild(group[negArr[i][1]]);
			}
			for(i=posArr.length-1; i>=0; i--)
			{
				lineTreeNode.addChild(group[posArr[i][1]]);
			}
			return false;
		}
		
		private function doCompareDotValue(a:Array,b:Array):int
		{
			if(a[0]>b[0])
			{
				return 1;
			}
			if(a[0]<b[0])
			{
				return -1;
			}
			return 0;
		}
		/**
		 * 根据闭合围点坐标集合，创建一组3D场景线 
		 * @param roundPoints	闭合围点坐标集合
		 * @param areaID		闭合区域的ID
		 * @param sceneKey	场景标记
		 * 
		 */		
		public function addScene3DLinesByRoundPoints(roundPoints:Vector.<Number>,areaID:String,sceneKey:String):void
		{
			var i:int,len:int,next:int;
			var start:Vector3D,end:Vector3D;
			
			start=new Vector3D();
			end=new Vector3D();
			_changedWallLines.length=0;
			setCurrentSceneSpaceData(sceneKey);
			len=roundPoints.length/3;
			for(i=0;i<len;i++)
			{
				next=i==len-1?0:i+1;
				start.setTo(roundPoints[i*3],roundPoints[i*3+1],roundPoints[i*3+2]);
				end.setTo(roundPoints[next*3],roundPoints[next*3+1],roundPoints[next*3+2]);
				addWallLineBySegment(start,end);
			}
		}
		public function createNewClosedAreaByRoundPoints(roundPoints:Vector.<Number>,areaID:String,offGround:Number):void
		{
			var closeArea:CClosedLine3DArea;
			var curAreaNode:ICDoubleNode;
			var closedLineDatas:Vector.<ICLine>;
			var i:int,next:int,len:int;
			var start:Vector3D,end:Vector3D;
			var tmpLine:ICLine;

			_changedWallLines.length=0;
			closedLineDatas=new Vector.<ICLine>();
			start=new Vector3D();
			end=new Vector3D();
			len=roundPoints.length/3;
			for(i=0;i<len;i++)
			{
				next=i==len-1?0:i+1;
				start.setTo(roundPoints[i*3],roundPoints[i*3+1],roundPoints[i*3+2]);
				end.setTo(roundPoints[next*3],roundPoints[next*3+1],roundPoints[next*3+2]);
				_currentSceneData.addSceneLineNode(start,end);
				tmpLine=_currentSceneData.getSceneLineData(start,end);
				closedLineDatas.push(tmpLine);
				_changedWallLines.push(tmpLine,_currentSceneData.getSceneLineData(end,start));
			}
			closeArea=new CClosedLine3DArea(closedLineDatas,areaID);
			closeArea.stateType=CClosedLine3DArea.CREATE;
			curAreaNode=new CDoubleNode(closeArea);
			if(!_currentSceneData.areaCacheNode)
			{
				_currentSceneData.areaCacheNode=curAreaNode;
			}
			else
			{
				if(!_currentSceneData.areaCacheNode.mapDoubleNode(judgeEqualArea,curAreaNode))
				{
					_currentSceneData.areaCacheNode.addAfter(curAreaNode);
				}
			}
		}
		private function doSearchClosedAreasByMapLine(lineNode:CTreeNode,newAreaDataGroup:Vector.<CClosedLine3DArea>):Boolean
		{
			//开始搜索一个闭合区域
			var searchedLineDatas:Vector.<ICLine>;
			var searchResult:CTreeNode;
			var traveledMarkMap:CHashMap;
			var areaCacheNode:ICDoubleNode;
			var areaData:CClosedLine3DArea;
			var i:int,len:int;
			
			if(lineNode.isMarked)
			{
				return false;
			}
			_currentSceneData.rootLineNode=lineNode;
			searchedLineDatas=_currentSceneData.searchedLineDatas;
			traveledMarkMap=_currentSceneData.traveledMarkMap;
			searchedLineDatas.length=0;
			searchResult=_currentSceneData.rootLineNode.foreachChildren(doTravelLine);
			_currentSceneData.rootLineNode.foreachChildren(CMathUtilForAS.Instance.removeAllTreeNode);
			//清除访问记录
			traveledMarkMap.clear();
			if(!searchResult)
			{
				//没有找到闭合区间
				return false;
			}
			areaData=new CClosedLine3DArea(searchedLineDatas);
			if(!areaData)
			{
				//没有搜索到闭合区域，移除树遍历结构，跳转一下层循环
				return false;
			}
			if(areaData.isNegtive)
			{
				//区域是负向旋转，符合筛选条件，跳转到下一循环
				areaData.dispose();
				return false;
			}
			if(areaCacheNode)
			{
				//遍历缓存的旧区域数据，进行比对，确定是否有新区域需要创建
				var isSameArea:Boolean;
				var curAreaData:CClosedLine3DArea;
				var sameAreaNodes:Vector.<ICDoubleNode>;
				
				for(var curAreaNode:ICDoubleNode=areaCacheNode; curAreaNode; curAreaNode=curAreaNode.next)
				{
					curAreaData=curAreaNode.nodeData as CClosedLine3DArea;
					//找到相同区域
					if(CL3DModuleUtil.Instance.isCloseLine3DAreaSame(areaData,curAreaData))
					{
						if(curAreaData.roundPoints.length!=areaData.roundPoints.length || !CMathUtilForAS.Instance.isEqualVector3D(curAreaData.center,areaData.center))
						{
							//墙体有打断或合并等操作，数据发生改变
							sameAreaNodes||=new Vector.<ICDoubleNode>();
							sameAreaNodes.push(curAreaNode);
						}
						else
						{
							isSameArea=true;
							break;
						}
					}
				}
				if(isSameArea)
				{
					//当前区域已经生成过了，跳转到下一循环
					isSameArea=false;
					areaData.dispose();
					return false;
				}
				if(sameAreaNodes && sameAreaNodes.length==1)
				{
					//修改原先的闭合区域，不需要重新创建闭合区域，跳转到下一循环
					(sameAreaNodes[0].nodeData as CClosedLine3DArea).initArea(searchedLineDatas);
					(sameAreaNodes[0].nodeData as CClosedLine3DArea).stateType=CClosedLine3DArea.UPDATE;
					sameAreaNodes.length=0;
					return false;
				}
				if(sameAreaNodes)
				{
					//新闭合区域与2个及以上区域相关，属于区域合并，删除旧区域
					for(i=sameAreaNodes.length-1; i>=0; i--)
					{
						(sameAreaNodes[i].nodeData as CClosedLine3DArea).dispose();
						sameAreaNodes[i].unlink();
					}
					sameAreaNodes.length=0;
				}
			}
			//创建新区域，并添加到待缓存队列中
			areaData.stateType=CClosedLine3DArea.CREATE;
			newAreaDataGroup.push(areaData);
			_currentSceneData.rootLineNode=null;
			return false;
		}
		private function judgeEqualArea(areaNode:ICDoubleNode,targetAreaNode:ICDoubleNode):Boolean
		{
			var areaData:CClosedLine3DArea,targetAreaData:CClosedLine3DArea;
			var result:Boolean;
			
			areaData=areaNode.nodeData as CClosedLine3DArea;
			targetAreaData=targetAreaNode.nodeData as CClosedLine3DArea;
			if(CL3DModuleUtil.Instance.isCloseLine3DAreaSame(areaData,targetAreaData))
			{
				//重合区域
				areaData.initAreaByRound3DPoints(targetAreaData.roundPoints);
				(areaNode.nodeData as CClosedLine3DArea).stateType=CClosedLine3DArea.UPDATE;
				result=true;
			}
			else if(CMathUtilForAS.Instance.isSimilarRoundPoints(areaData.roundPoints,targetAreaData.roundPoints))
			{
				//相似区域
				areaData.initAreaByRound3DPoints(targetAreaData.roundPoints);
				(areaNode.nodeData as CClosedLine3DArea).stateType=CClosedLine3DArea.UPDATE;
				result=true;
			}
			else
			{
				result=false;
			}
			return result;
		}
		/**
		 * 移除区域节点 
		 * @param areaNode
		 * @param areaID
		 * @return 
		 * 
		 */		
		public function removeAreaCacheNode(areaID:String):void
		{
			var node:ICDoubleNode=CL3DModuleUtil.Instance.searchDoubleNodeByDataID(areaCacheNode,areaID);
			if(node==areaCacheNode && node.next)
			{
				_currentSceneData.areaCacheNode=node.next;
			}
			if(node)
			{
				(node.nodeData as CClosedLine3DArea).dispose();
				node.unlink();
			}
		}
		/**
		 * 搜索闭合区域，并返回新的闭合区域
		 * @param isFilterNegativeArea
		 * @return ICDoubleNode
		 * 
		 */		
		public function searchClosedAreas(isFilterNegativeArea:Boolean=true):void
		{
			var i:int;
			var newAreaDataGroup:Vector.<CClosedLine3DArea>;
			var curAreaNode:ICDoubleNode;
			
			newAreaDataGroup=new Vector.<CClosedLine3DArea>();
			CL3DModuleUtil.Instance.mapSceneLineNode(_currentSceneData.sceneLineNodeMap,doSearchClosedAreasByMapLine,newAreaDataGroup);
			//搜索完成，将待缓存区域集合，缓存起来
			if(newAreaDataGroup)
			{
				for(i=newAreaDataGroup.length-1; i>=0; i--)
				{
					curAreaNode=new CDoubleNode(newAreaDataGroup[i]);
					if(!_currentSceneData.areaCacheNode)
					{
						_currentSceneData.areaCacheNode=curAreaNode;
					}
					else
					{
						if(!_currentSceneData.areaCacheNode.mapDoubleNode(judgeEqualArea,curAreaNode))
						{
							_currentSceneData.areaCacheNode.addAfter(curAreaNode);
						}
					}
				}
			}
			//搜索完成，还原使用状态
			var markedFalse:Function = function(lineNode:CTreeNode):Boolean
			{
				lineNode.isMarked=false;
				return false;
			}
			CL3DModuleUtil.Instance.mapSceneLineNode(_currentSceneData.sceneLineNodeMap,markedFalse);
		}
//		public function updateLineData(oldPos:Vector3D,newPos:Vector3D):void
//		{
//			var i:int,j:int,k:int,len:int;
//			var key:String;
//			var groupLines:Vector.<CTreeNode>,tmpGroup:Vector.<CTreeNode>,keys:Array;
//			var lineNode:CTreeNode;
//			var lineData:CWallLineData,tmpLine:CWallLineData;
//			var cross:Vector3D,dir:Vector3D;
//			var isSearched:Boolean;
//			
//			dir=newPos.subtract(oldPos);
//			dir.normalize();
//			key=oldPos.toString();
//			groupLines=_wallLineNodeMap.get(key) as Vector.<CTreeNode>;
//			for(i=groupLines.length-1;i>=0;i--)
//			{
//				lineNode=groupLines[i] as CTreeNode;
//				lineData=lineNode.nodeData as CWallLineData;
//				cross=dir.crossProduct(lineData.direction);
//				if(!CMathUtilForAS.Instance.isEqualVector3D(CMathUtilForAS.ZERO,cross))
//				{
//					continue;
//				}
//				groupLines.removeAt(i);
//				if(groupLines.length==0)
//				{
//					_wallLineNodeMap.remove(key);
//				}
//				lineData.start=newPos;
//				tmpGroup=_wallLineNodeMap.get(newPos.toString()) as Vector.<CTreeNode>;
//				if(tmpGroup==null)
//				{
//					tmpGroup=new Vector.<CTreeNode>();
//					tmpGroup.push(lineNode);
//					_wallLineNodeMap.put(newPos.toString(),tmpGroup);
//				}
//				else if(tmpGroup.indexOf(lineNode)<0)
//				{
//					tmpGroup.push(lineNode);
//				}
//				//查找反向线条数据并更新
//				keys=_wallLineNodeMap.keys;
//				for(j=keys.length-1; j>=0; j--)
//				{
//					if(keys[j]==key)
//					{
//						continue;
//					}
//					tmpGroup=_wallLineNodeMap.get(keys[j]) as Vector.<CTreeNode>;
//					isSearched=false;
//					for(k=tmpGroup.length-1;k>=0;k--)
//					{
//						tmpLine=tmpGroup[k].nodeData as CWallLineData;
//						if(tmpLine.end.toString()==key)
//						{
//							//找到反向线条；
//							tmpLine.end=newPos;
//							break;
//						}
//					}
//				}
//			}
//		}
		public function removeWallLine(start3D:Vector3D,end3D:Vector3D):void
		{
			_currentSceneData.removeSceneLineNode(start3D,end3D);
		}
		public function addUpdatedWallLine(oStart3D:Vector3D,oEnd3D:Vector3D,start3D:Vector3D,end3D:Vector3D,prevPos:Vector3D,nextPos:Vector3D):void
		{
			var dir:Vector3D,tmpDir:Vector3D;
			var addedLinePosArr:Array;	//添加线条点

			addWallLineBySegment(start3D,end3D,false);
			dir=new Vector3D();
			tmpDir=new Vector3D();
			if(prevPos)
			{
				//处理起始点线条
				dir.setTo(start3D.x-oStart3D.x,start3D.y-oStart3D.y,start3D.z-oStart3D.z);
				dir.normalize();
				tmpDir.setTo(oStart3D.x-prevPos.x,oStart3D.y-prevPos.y,oStart3D.z-prevPos.z);
				tmpDir.normalize();
				if(!CMathUtil.Instance.isEqual(Math.abs(dir.dotProduct(tmpDir)),1))
				{
					addWallLineBySegment(oStart3D,start3D,false);
				}
				else if(!CMathUtilForAS.Instance.isEqualVector3D(prevPos,start3D))
				{
					addWallLineBySegment(prevPos,start3D,false);
				}
			}
			if(nextPos)
			{
				//处理终点线条
				dir=new Vector3D();
				dir.setTo(end3D.x-oEnd3D.x,end3D.y-oEnd3D.y,end3D.z-oEnd3D.z);
				dir.normalize();
				tmpDir.setTo(nextPos.x-oEnd3D.x,nextPos.y-oEnd3D.y,nextPos.z-oEnd3D.z);
				tmpDir.normalize();
				if(!CMathUtil.Instance.isEqual(Math.abs(dir.dotProduct(tmpDir)),1))
				{
					addWallLineBySegment(oEnd3D,end3D,false);
				}
				else if(!CMathUtilForAS.Instance.isEqualVector3D(end3D,nextPos))
				{
					addWallLineBySegment(end3D,nextPos,false);
				}
			}
		}
		/**
		 * 拆分需要创建的线条 
		 * @param lineNode		当前已有线条节点
		 * @param addedLinePoints		需要创建的线条端点集合
		 * @param start3D	需要创建的线条的起始点
		 * @param end3D		需要创建的线条的终点
		 * @return Boolean	是否发生中断
		 * 
		 */		
		private function doSpliteAddedLineCallback(lineNode:CTreeNode,addedLinePoints:Array,start3D:Vector3D,end3D:Vector3D):Boolean
		{
			var lineData:CWallLineData;
			var tmpResult:Array;
			var containedStart:Boolean,containedEnd:Boolean;
			
			lineData=lineNode.nodeData as CWallLineData;
			tmpResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(start3D,end3D,lineData.start,lineData.end);
			if(!tmpResult || !tmpResult.length)
			{
				//没有相交
				return false;
			}
			containedStart=CMathUtilForAS.Instance.dotByPosition3D(start3D,lineData.start,lineData.end)<=0;
			containedEnd=CMathUtilForAS.Instance.dotByPosition3D(end3D,lineData.start,lineData.end)<=0;
			if(tmpResult.length>2)
			{
				if(!containedStart)
				{
					//所画线包含已有线，需要添加2条线
					if(Vector3D.distance(start3D,lineData.start)<Vector3D.distance(start3D,lineData.end))
					{
						addedLinePoints.push(start3D,lineData.start);
					}
					else
					{
						addedLinePoints.push(start3D,lineData.end);
					}
				}
				if(!containedEnd)
				{
					if(Vector3D.distance(end3D,lineData.start)<Vector3D.distance(end3D,lineData.end))
					{
						addedLinePoints.push(lineData.start,end3D);
					}
					else
					{
						addedLinePoints.push(lineData.end,end3D);
					}
				}
				return true;
			}
			return false;
		}
		private function doSpliteCollinearLine(addedLinePoints:Array,start3D:Vector3D,end3D:Vector3D,outputArr:Array):Boolean
		{
			var isbroken:Boolean=CL3DModuleUtil.Instance.mapSceneLineNode(_currentSceneData.sceneLineNodeMap,doSpliteAddedLineCallback,addedLinePoints,start3D,end3D);
			if(!isbroken)
			{
				var hasAdded:Boolean;
				for(var i:int=outputArr.length-1;i>=0;i--)
				{
					if(CMathUtilForAS.Instance.isEqualVector3D(outputArr[i*2],start3D) &&
						CMathUtilForAS.Instance.isEqualVector3D(outputArr[i*2+1],end3D))
					{
						hasAdded=true;
						break;
					}
				}
				if(!hasAdded)
				{
					outputArr.push(start3D,end3D);
				}
			}
			if(addedLinePoints.length/2==0)
			{
				return isbroken;
			}
			var end:Vector3D=addedLinePoints.pop();
			var start:Vector3D=addedLinePoints.pop();
			return doSpliteCollinearLine(addedLinePoints,start,end,outputArr);
		}
		private function doSpliteIntersectedLineCallback(lineNode:CTreeNode,addedLinePoints:Array,start3D:Vector3D,end3D:Vector3D,outputArr:Array):Boolean
		{
			var lineData:CWallLineData;
			var tmpResult:Array;
			var i:int,len:int;
			var hasAdded:Boolean;
			
			lineData=lineNode.nodeData as CWallLineData;
			tmpResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(start3D,end3D,lineData.start,lineData.end);
			if(!tmpResult || !tmpResult.length)
			{
				//没有相交
				return false;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(tmpResult[1],lineData.start) && 
				!CMathUtilForAS.Instance.isEqualVector3D(tmpResult[1],lineData.end))
			{
				//修复原有线条
				_currentSceneData.removeSceneLineNode(lineData.start,lineData.end);
				outputArr.push(lineData.start,tmpResult[1]);
				outputArr.push(tmpResult[1],lineData.end);
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(tmpResult[1],start3D) && 
				!CMathUtilForAS.Instance.isEqualVector3D(tmpResult[1],end3D))
			{
				//切割线条
				len=addedLinePoints.length/2;
				for(i=0;i<len;i++)
				{
					if(CMathUtilForAS.Instance.isEqualVector3D(addedLinePoints[i*2],start3D) &&
						CMathUtilForAS.Instance.isEqualVector3D(addedLinePoints[i*2+1],end3D))
					{
						addedLinePoints.removeAt(i*2);
						addedLinePoints.removeAt(i*2);
					}
				}
				addedLinePoints.push(start3D,tmpResult[1]);
				addedLinePoints.push(tmpResult[1],end3D);
				return true;
			}
			return false;
		}
		private function doSpliteIntersectedLine(addedLinePoints:Array,start3D:Vector3D,end3D:Vector3D,outputArr:Array):void
		{
			var isbroken:Boolean=CL3DModuleUtil.Instance.mapSceneLineNode(_currentSceneData.sceneLineNodeMap,doSpliteIntersectedLineCallback,addedLinePoints,start3D,end3D,outputArr);
			if(!isbroken)
			{
				var hasAdded:Boolean;
				for(var i:int=outputArr.length-1;i>=0;i--)
				{
					if(CMathUtilForAS.Instance.isEqualVector3D(outputArr[i*2],start3D) &&
						CMathUtilForAS.Instance.isEqualVector3D(outputArr[i*2+1],end3D))
					{
						hasAdded=true;
						break;
					}
				}
				if(!hasAdded)
				{
					outputArr.push(start3D,end3D);
				}
			}
			if(addedLinePoints.length/2==0)
			{
				return;
			}
			var end:Vector3D=addedLinePoints.pop();
			var start:Vector3D=addedLinePoints.pop();
			doSpliteIntersectedLine(addedLinePoints,start,end,outputArr);
		}
		public function addWallLineByRoundPoints(roundPoints:Vector.<Number>,isClearChanged:Boolean=false):void
		{
			
		}
		/**
		 * 通过线段，添加墙线数据
		 * @param start2DPoint	线段的起点
		 * @param end2DPoint		线段的终点
		 * 
		 */		
		public function addWallLineBySegment(start3D:Vector3D,end3D:Vector3D,isClearChanged:Boolean=false):void
		{
			var i:int,j:int,len:int;
			var spliteLinePoints:Array,addedLinePoints:Array,tmpArr:Array;
			var hasOverride:Boolean;
			var addLine:ICLine;
			var intersectResult:Array;
			
			if(isClearChanged)
			{
				_changedWallLines.length=0;
			}
			//判断交点情况
			tmpArr=[];
			spliteLinePoints=[];
			addedLinePoints=[];

			//检测重合线条，分割需要创建的线条数据
			hasOverride=doSpliteCollinearLine(tmpArr,start3D,end3D,spliteLinePoints);
			if(spliteLinePoints.length==0)
			{
				if(hasOverride)
				{
					//有重合线条，但是没有分割点，直接返回，不添加该线条
					return;
				}
				spliteLinePoints.push(start3D,end3D);
			}
			//检测十字相交线条，分割需要创建的线条数据
			len=spliteLinePoints.length/2;
			for(i=0;i<len;i++)
			{
				doSpliteIntersectedLine(tmpArr,spliteLinePoints[i*2],spliteLinePoints[i*2+1],addedLinePoints);
			}
			//添加新线条数据
			len=addedLinePoints.length/2;
			for(i=len-1;i>=0;i--)
			{
				_currentSceneData.addSceneLineNode(addedLinePoints[i*2],addedLinePoints[i*2+1]);
			}
			for(i=len-1;i>=0;i--)
			{
				//修复需要重合的点
				addLine=_currentSceneData.amendCombineLine(addedLinePoints[i*2],addedLinePoints[i*2+1]);
				if(addLine)
				{
					addedLinePoints.removeAt(i*2);
					addedLinePoints.removeAt(i*2);
					for(j=addedLinePoints.length/2-1;j>=0;j--)
					{
						if(CMathUtilForAS.Instance.isEqualVector3D(addedLinePoints[j*2+1],addLine.start))
						{
							//存在需添加的重合线，删除
							addedLinePoints.removeAt(j*2);
							addedLinePoints.removeAt(j*2);
							break;
						}
					}
					_changedWallLines.push(addLine,_currentSceneData.getSceneLineData(addLine.end,addLine.start));
				}
				else
				{
					for(j=_changedWallLines.length/2-1;j>=0;j--)
					{
						//寻找需要剔除的墙线数据
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(_changedWallLines[j*2].start,_changedWallLines[j*2].end,addedLinePoints[i*2],addedLinePoints[i*2+1]);
						if(intersectResult && intersectResult.length>2)
						{
							//有2个交点，剔除墙线数据
							_changedWallLines.removeAt(j*2);
							_changedWallLines.removeAt(j*2);
							break;
						}
					}
					_changedWallLines.push(_currentSceneData.getSceneLineData(addedLinePoints[i*2],addedLinePoints[i*2+1]),_currentSceneData.getSceneLineData(addedLinePoints[i*2+1],addedLinePoints[i*2]));
				}
			}
		}
		/**
		 * 清除所有缓存
		 * 
		 */	
		override public function clearAllCache():void
		{
			super.clearAllCache();
			var sceneDatas:Array=_sceneDataMap.values;
			for(var i:int=sceneDatas.length-1;i>=0;i--)
			{
				sceneDatas[i].clear();
			}
			_sceneDataMap.clear();
		}
		/**
		 * 清除缓存的区域节点 
		 * 
		 */		
		private function clearSceneData():void
		{
			if(_currentSceneData)
			{
				_currentSceneData
			}
		}
		public function isChangedAreaData(areaData:ICClosedArea):Boolean
		{
			return _changedAreaDatas.indexOf(areaData)<0;
		}
		public function addChangedAreaData(areaData:ICClosedArea):void
		{
			_changedAreaDatas.push(areaData);
		}
		
//		public function addPoly(polyPoints:Array):void
//		{
//			var i:int,j:int,len:int;
//			var intersectResult:Array;
//			var poly:Poly,searchedPoly:Poly;
//			var pos3d:Vector3D,nextPos3d:Vector3D;
//			var intersectPoly:Poly,difference1:Poly,difference2:Poly;
//			
//			poly=new PolyDefault();
//			len=polyPoints.length;
//			for(i=0; i<len; i++)
//			{
//				pos3d=CL3DModuleUtil.Instance.amendPosition3DByVector3D(polyPoints[i],CL3DConstDict.POSITIONMODE_SCENE2D,CL3DConstDict.POSITIONMODE_SCENE3D);
//				poly.addPointXY(pos3d.x,pos3d.y);
////				if(i==0)
////				{
////					nextPos3d=CL3DModuleUtil.Instance.amendPosition3DByVector3D(polyPoints[1],CL3DConstDict.POSITIONMODE_SCENE2D,CL3DConstDict.POSITIONMODE_SCENE3D);
////					poly.addPointXY((pos3d.x+nextPos3d.x)*.5,(pos3d.y+nextPos3d.y)*.5);
////				}
//			}
//			//遍历多边形对象集合
//			len=_scenePolys.length;
//			for(i=len-1; i>=0; i--)
//			{
//				searchedPoly=_scenePolys[i];
//				intersectPoly=poly.intersection(searchedPoly);
//				if(intersectPoly.getNumInnerPoly())
//				{
//					//发生相交
//					var tmpPoints:Array;
//					var pnum:int;
//					difference1=poly.difference(searchedPoly);
//					difference2=searchedPoly.difference(poly);
//					doUpdatePoly(poly,difference1);
//					doUpdatePoly(searchedPoly,difference2);
//					//添加新的相交多边形
//					_scenePolys.push(intersectPoly);
//					break;
//				}
//			}
//			//添加新的多边形
//			_scenePolys.push(poly);
//		}
		
//		private function doUpdatePoly(sourcePoly:Poly,newPoly:Poly):void
//		{
//			var i:int,len:int;
//			
//			doClearPoly(sourcePoly);
//			len=newPoly.getNumInnerPoly();
//			for(i=0; i<len; i++)
//			{
//				sourcePoly.addPoly(newPoly.getInnerPoly(i));
//				//遍历所有边,添加线条数据
//				
//			}
//		}
//		private function doRemoveWallLineData(start:Vector3D,end:Vector3D):void
//		{
//			var lineGroup:Vector.<CTreeNode>;
//			var tmpLine:CWallLineData;
//			var i:int,len:int;
//			
//			lineGroup=_wallLineNodeMap.get(start.toString()) as Vector.<CTreeNode>;
//			len=lineGroup.length;
//			for(i=len-1; i>=0; i--)
//			{
//				tmpLine=lineGroup[i].nodeData as CWallLineData;
//				if(CMathUtilForAS.Instance.isEqualVector3D(tmpLine.end,end))
//				{
//					lineGroup.removeAt(i);
//					break;
//				}
//			}
//			lineGroup=_wallLineNodeMap.get(end.toString()) as Vector.<CTreeNode>;
//			len=lineGroup.length;
//			for(i=len-1; i>=0; i--)
//			{
//				tmpLine=lineGroup[i].nodeData as CWallLineData;
//				if(CMathUtilForAS.Instance.isEqualVector3D(tmpLine.end,start))
//				{
//					lineGroup.removeAt(i);
//					break;
//				}
//			}
//		}
		
//		private function doUpdateWallLineHashMap(start:Vector3D,end:Vector3D,isAdd:Boolean):void
//		{
//			var lineGroup:Vector.<CTreeNode>;
//			var startLine:CWallLineData,endLine:CWallLineData;
//			var i:int,j:int,slen:int,elen:int;
//			var isSearched:Boolean;
//			var dir:Vector3D;
//			
//			lineGroup=_wallLineNodeMap.get(start.toString()) as Vector.<CTreeNode>;
//			dir=new Vector3D(end.x-start.x,end.y-start.y,end.z-start.z);
//			dir.normalize();
//			slen=lineGroup.length;
//			for(i=0; i<slen; i++)
//			{
//				startLine=lineGroup[i].nodeData as CWallLineData;
//				if(CMathUtilForAS.Instance.isEqualVector3D(startLine.direction,dir))
//				{
//					isSearched=true;
//					lineGroup=_wallLineNodeMap.get(startLine.end.toString()) as Vector.<CTreeNode>;
//					for(j=0; j<elen; j++)
//					{
//						endLine=lineGroup[j].nodeData as CWallLineData;
//						if(CMathUtilForAS.Instance.isEqualVector3D(endLine.end,startLine.start))
//						{
//							break;
//						}
//					}
//					break;
//				}
//			}
//			if(isAdd)
//			{
//				if(isSearched)
//				{
//					if(CMathUtilForAS.Instance.dotByPosition3D(startLine.start,endLine.start,end)<0)
//					{
//						//原有线条分段
//						startLine.end=end;
//						endLine.end=end;
//						
//					}
//					
//				}
//			}
//			if(isSearched)
//			{
//				
//			}
//		}
		
//		private function doClearPoly(poly:Poly):void
//		{
//			var i:int,j:int,len:int,glen:int,prev:int,next:int;
//			var points:Array;
//			var lineGroup:Vector.<CTreeNode>;
//			var tmpPos:Vector3D;
//			var lineData:CWallLineData;
//			
//			tmpPos=new Vector3D();
//			//移除多边形对应的所有线条数据
//			points=poly.getPoints();
//			len=points.length;
//			for(i=0; i<len; i++)
//			{
////				prev=i==0?len-1:i-1;
//				next=i==len-1?0:i+1;
//				//移除第一条线
//				tmpPos.setTo(points[i].x,points[i].y,0);
//				lineGroup=_wallLineNodeMap.get(tmpPos.toString()) as Vector.<CTreeNode>;
//				tmpPos.setTo(points[next].x,points[next].y,0);
//				glen=lineGroup.length;
//				for(j=0; j<glen; j++)
//				{
//					lineData=lineGroup[j].nodeData as CWallLineData;
//					if(CMathUtilForAS.Instance.isEqualVector3D(lineData.end,tmpPos))
//					{
//						lineGroup[j].clearChildren();
//						lineGroup.removeAt(j);
//						break;
//					}
//				}
//				//移除第二条线
//				lineGroup=_wallLineNodeMap.get(tmpPos.toString()) as Vector.<CTreeNode>;
//				tmpPos.setTo(points[i].x,points[i].y,0);
//				glen=lineGroup.length;
//				for(j=0; j<glen; j++)
//				{
//					lineData=lineGroup[j].nodeData as CWallLineData;
//					if(CMathUtilForAS.Instance.isEqualVector3D(lineData.end,tmpPos))
//					{
//						lineGroup[j].clearChildren();
//						lineGroup.removeAt(j);
//						break;
//					}
//				}
//			}
//			poly.clear();
//		}
		/**
		 * 根据线条起点终点，获取当前场景中线条的ID 
		 * @param start
		 * @param end
		 * @return String
		 * 
		 */		
		public function getCurrentSceneLineID(start:Vector3D,end:Vector3D):String
		{
			return (_currentSceneData.getSceneLineData(start,end) as CBaseL3DData).uniqueID;
		}
	}
}
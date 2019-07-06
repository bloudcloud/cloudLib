package extension.cloud.mvcs.scene.model.data
{
	import flash.geom.Vector3D;
	
	import cloud.core.collections.CTreeNode;
	import cloud.core.collections.ICDoubleNode;
	import cloud.core.datas.maps.CHashMap;
	import cloud.core.interfaces.ICLine;
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CMathUtilForAS;
	
	import extension.cloud.datas.CClosedLine3DArea;
	import extension.cloud.datas.CWallLineData;
	import extension.cloud.mvcs.base.model.CBaseEntity3DData;
	
	import ns.cloud_lejia;
	use namespace cloud_lejia;
	/**
	 * 业务场景数据类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CSceneSpaceData extends CBaseEntity3DData
	{
		private var _sceneLineNodeMap:CHashMap;
		private var _rootLineNode:CTreeNode;
		private var _searchedLineDatas:Vector.<ICLine>;
		private var _traveledMarkMap:CHashMap;
		private var _areaCacheNode:ICDoubleNode;
		
		cloud_lejia function get sceneLineNodeMap():CHashMap
		{
			return _sceneLineNodeMap;
		}
		cloud_lejia function get rootLineNode():CTreeNode
		{
			return _rootLineNode;
		}
		cloud_lejia function set rootLineNode(value:CTreeNode):void
		{
			_rootLineNode=value;
		}
		cloud_lejia function get searchedLineDatas():Vector.<ICLine>
		{
			return _searchedLineDatas;
		}
		cloud_lejia function get traveledMarkMap():CHashMap
		{
			return _traveledMarkMap;
		}
		cloud_lejia function get areaCacheNode():ICDoubleNode
		{
			if(_areaCacheNode && _areaCacheNode.nodeData==null)
			{
				_areaCacheNode=null;
			}
			return _areaCacheNode;
		}
		cloud_lejia function set areaCacheNode(value:ICDoubleNode):void
		{
			_areaCacheNode=value;
		}
		
		public function CSceneSpaceData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID);
			_sceneLineNodeMap=new CHashMap();
			_searchedLineDatas=new Vector.<ICLine>();
			_traveledMarkMap=new CHashMap();
		}
		
		cloud_lejia function getSceneLineGroup(key:String):Vector.<CTreeNode>
		{
			return _sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
		}
//		public function searchSceneLineNode(func:Function,...params):CTreeNode
//		{
//			var i:int,j:int;
//			var keys:Array;
//			var groupLines:Vector.<CTreeNode>;
//			var callbackParams:Array;
//			var isSearched:Boolean;
//			var result:CTreeNode;
//			
//			callbackParams=params==null?[]:params.concat();
//			callbackParams.unshift(null);
//			keys=_sceneLineNodeMap.keys;
//			for(i=keys.length-1;i>=0;i--)
//			{
//				groupLines=_sceneLineNodeMap.get(keys[i]) as Vector.<CTreeNode>;
//				for(j=groupLines.length-1;j>=0;j--)
//				{
//					callbackParams[0]=groupLines[i];
//					if(func.apply(null,callbackParams))
//					{
//						isSearched=true;
//						break;
//					}
//				}
//				if(isSearched)
//				{
//					result=groupLines[j];
//					break;
//				}
//			}
//			return result;
//		}
		/**
		 * 移除场景线条节点 
		 * @param start
		 * @param end
		 * 
		 */		
		public function removeSceneLineNode(start:Vector3D,end:Vector3D):void
		{
			var key:String=start.toString();
			var groupLines:Vector.<CTreeNode>=_sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
			if(groupLines==null)
			{
				return;
			}
			for(var i:int=groupLines.length-1;i>=0;i--)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D((groupLines[i].nodeData as ICLine).end,end))
				{
					groupLines.removeAt(i);
					if(groupLines.length==0)
					{
						_sceneLineNodeMap.remove(key);
					}
					break;
				}
			}
			key=end.toString();
			groupLines=_sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
			if(groupLines==null)
			{
				return;
			}
			for(i=groupLines.length-1;i>=0;i--)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D((groupLines[i].nodeData as ICLine).end,start))
				{
					groupLines.removeAt(i);
					if(groupLines.length==0)
					{
						_sceneLineNodeMap.remove(key);
					}
					break;
				}
			}
		}
		public function amendCombineLine(start:Vector3D,end:Vector3D):ICLine
		{
			var result:ICLine;
			var lineNodeGroup:Vector.<CTreeNode>;
			var direction:Vector3D;
			
			direction=end.subtract(start);
			direction.normalize();
			lineNodeGroup=_sceneLineNodeMap.get(start.toString()) as Vector.<CTreeNode>;
			if(lineNodeGroup.length==2 && CMathUtil.Instance.isEqual((lineNodeGroup[0].nodeData as ICLine).direction.dotProduct((lineNodeGroup[1].nodeData as ICLine).direction),-1))
			{
				var newStart:Vector3D,newEnd:Vector3D;
				if(CMathUtilForAS.Instance.isEqualVector3D((lineNodeGroup[0].nodeData as ICLine).end,end))
				{
					newStart=(lineNodeGroup[1].nodeData as ICLine).end.clone();
					newEnd=end.clone();
					removeSceneLineNode((lineNodeGroup[1].nodeData as ICLine).start,(lineNodeGroup[1].nodeData as ICLine).end);
				}
				else
				{
					newStart=(lineNodeGroup[0].nodeData as ICLine).end.clone();
					newEnd=end.clone();
					removeSceneLineNode((lineNodeGroup[0].nodeData as ICLine).start,(lineNodeGroup[0].nodeData as ICLine).end);
				}
				removeSceneLineNode(start,end);
				addSceneLineNode(newStart,newEnd);
				result=getSceneLineData(newStart,newEnd);
			}
			return result;
		}
		/**
		 * 添加场景线条节点 
		 * @param start
		 * @param end
		 * 
		 */		
		public function addSceneLineNode(start:Vector3D,end:Vector3D):void
		{
			var key:String=start.toString();
			var groupLines:Vector.<CTreeNode>=_sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
			var hasAdded:Boolean;
			var lineData:CWallLineData;
			
			if(groupLines)
			{
				for(var i:int=groupLines.length-1;i>=0;i--)
				{
					if(CMathUtilForAS.Instance.isEqualVector3D((groupLines[i].nodeData as ICLine).start,start) &&
						CMathUtilForAS.Instance.isEqualVector3D((groupLines[i].nodeData as ICLine).end,end))
					{
						hasAdded=true;
						break;
					}
				}
				if(!hasAdded)
				{
					lineData=new CWallLineData();
					lineData.start=start;
					lineData.end=end;
					groupLines.push(new CTreeNode(lineData));
					key=end.toString();
					groupLines=_sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
					if(groupLines==null)
					{
						groupLines=new Vector.<CTreeNode>();
						_sceneLineNodeMap.put(key,groupLines);
					}
					lineData=new CWallLineData();
					lineData.start=end;
					lineData.end=start;
					groupLines.push(new CTreeNode(lineData));
				}
			}
			else
			{
				groupLines=new Vector.<CTreeNode>();
				_sceneLineNodeMap.put(key,groupLines);
				lineData=new CWallLineData();
				lineData.start=start;
				lineData.end=end;
				groupLines.push(new CTreeNode(lineData));
				key=end.toString();
				groupLines=_sceneLineNodeMap.get(key) as Vector.<CTreeNode>;
				if(groupLines==null)
				{
					groupLines=new Vector.<CTreeNode>();
					_sceneLineNodeMap.put(key,groupLines);
				}
				lineData=new CWallLineData();
				lineData.start=end;
				lineData.end=start;
				groupLines.push(new CTreeNode(lineData));
			}
		}
		/**
		 * 添加已有线上的一个点 
		 * @param pos		点的坐标
		 * @param lineData	已有线条
		 * 	
		 */		
		public function addLinePoint(pos:Vector3D,lineData:ICLine):void
		{
			var lineStart:Vector3D,lineEnd:Vector3D;
			var groupLines:Vector.<CTreeNode>;
			var newLine:ICLine;
			
			lineStart=lineData.start.clone();
			lineEnd=lineData.end.clone();
			lineData.end=pos;
			//修正反向线段
			groupLines=_sceneLineNodeMap.get(lineEnd.toString()) as Vector.<CTreeNode>;
			for(var i:int=groupLines.length-1; i>=0; i--)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D((groupLines[i].nodeData as ICLine).end,lineStart))
				{
					(groupLines[i].nodeData as ICLine).end=pos;
					break;
				}
			}
			//添加新的线条
			groupLines=_sceneLineNodeMap.get(pos.toString()) as Vector.<CTreeNode>;
			if(groupLines==null)
			{
				groupLines=new Vector.<CTreeNode>();
				_sceneLineNodeMap.put(pos.toString(),groupLines);
			}
			newLine=new CWallLineData();
			newLine.start=pos;
			newLine.end=lineStart;
			groupLines.push(new CTreeNode(newLine as ICNodeData));
			newLine=new CWallLineData();
			newLine.start=pos;
			newLine.end=lineEnd;
			groupLines.push(new CTreeNode(newLine as ICNodeData));
		}
		/**
		 * 获取场景线条数据对象 
		 * @param start	线条起点
		 * @param end		线条终点
		 * @return ICLine
		 * 
		 */		
		public function getSceneLineData(start:Vector3D,end:Vector3D):ICLine
		{
			var groupLines:Vector.<CTreeNode>=_sceneLineNodeMap.get(start.toString()) as Vector.<CTreeNode>;
			for each(var node:CTreeNode in groupLines)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D((node.nodeData as ICLine).end,end))
				{
					return node.nodeData as ICLine;
				}
			}
			return null;
		}
//		/**
//		 * 检查是否是有效的新添加线条 
//		 * @param start
//		 * @param end
//		 * @return Boolean
//		 * 
//		 */		
//		public function checkIsInvaildAddedLine(start:Vector3D,end:Vector3D):Boolean
//		{
//			var result:Boolean;
//			var lineNodeGroup:Vector.<CTreeNode>;
//			var direction:Vector3D;
//			
//			direction=end.subtract(start);
//			direction.normalize();
//			lineNodeGroup=_sceneLineNodeMap.get(start.toString()) as Vector.<CTreeNode>;
//			if(!lineNodeGroup.length==1 || !CMathUtil.Instance.isEqual((lineNodeGroup[0].nodeData as ICLine).direction.dotProduct(direction),-1))
//			{
//				result=true;
//			}
//			return result;
//		}
		override public function clear():void
		{
			_sceneLineNodeMap.clear();
			_rootLineNode=null;
			_searchedLineDatas.length=0;
			_traveledMarkMap.clear();
			if(areaCacheNode)
			{
				for(var node:ICDoubleNode=_areaCacheNode; node; node=node.next)
				{
					(node.nodeData as CClosedLine3DArea).dispose();
					node.unlink();
				}
				_areaCacheNode=null;
			}
		}
	}
}
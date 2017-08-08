package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	import cloud.core.utils.CDebug;
	
	import ns.cloudLib;

	use namespace cloudLib;
	/**
	 *  双向链表结构
	 * @author cloud
	 */
	public class DoubleList implements IDoubleList
	{
		protected var _invalidChildren:Boolean;
		protected var _isFullState:Boolean;
		
		protected var _currentNode:IDoubleNode;
		cloudLib var startNode:IDoubleNode;
		cloudLib var endNode:IDoubleNode;
		//需要更新的位置的节点数据集合
		cloudLib var changedVos:Vector.<ICData> = new Vector.<ICData>();
		
		private var _numberChildren:uint;

		public function DoubleList()
		{
		}
		
		protected function initList(nodeData:ICData):void
		{
			var node:IDoubleNode=createNode(nodeData);
			node.hasIn=true;
			startNode=node;
			endNode=node;
			_currentNode=node;
		}
		/**
		 * 添加发生改变的节点数据 
		 * @param vo		反生改变的节点数据
		 * 
		 */		
		cloudLib function addChangedVo(vo:ICData):void
		{
			if(changedVos.indexOf(vo)<0)
				changedVos.push(vo);
		}
		/**
		 * 初始化根节点 
		 * @param nodeData
		 * @return IDoubleNode
		 * 
		 */		
		protected function createNode(nodeData:ICData):IDoubleNode
		{
			return new DoubleNode(nodeData);
		}
		/**
		 * 将节点添加到当前节点之前 
		 * @param opreateData	要操作的节点数据
		 * @param node	找到的当前节点
		 * 
		 */			
		protected function addNodeBefore(opreateData:ICData,node:IDoubleNode):void
		{
			var opreateNode:IDoubleNode=createNode(opreateData);
			node.addBefore(opreateNode);
			_currentNode=opreateNode;
			if(node==startNode)
			{
				//变更头节点
				startNode=opreateNode;
			}
		}
		/**
		 * 将节点添加到当前节点之后 
		 * @param opreateData	要操作的节点数据
		 * @param node	找到的当前节点
		 * 
		 */				 
		protected function addNodeAfter(opreateData:ICData,node:IDoubleNode):void
		{
			var opreateNode:IDoubleNode=createNode(opreateData);
			node.addAfter(opreateNode);
			_currentNode=opreateNode;
			if(node==endNode)
			{
				//变更尾节点
				endNode=opreateNode;
			}
		}
		/**
		 * 执行添加节点操作 
		 * @param opreateData
		 * @param node
		 * @param isNext
		 * 
		 */
		protected function doAddNode(opreateData:ICData,node:IDoubleNode):Boolean
		{
			var isNext:Boolean;
			if(node==null)
			{
				initList(opreateData);
				isNext=true;
			}
			else if(opreateData.compare(node.nodeData)>0)
			{
				addNodeAfter(opreateData,node);
				isNext=true;
			}
			else
			{
				addNodeBefore(opreateData,node);
				isNext=false;
			}
			_numberChildren++;
			_invalidChildren=true;
			return isNext;
		}
		/**
		 * 执行删除节点操作 
		 * @param opreateData
		 * 
		 */
		protected function doRemoveNode(opreateData:ICData):void
		{
			removeNode(searchFromNowByCondition(opreateData,equalByIDCondition));
		}
		/**
		 * 移除节点 
		 * @param node
		 * 
		 */		
		protected function removeNode(node:IDoubleNode):void
		{
			if(node==null || node.nodeData==null) CDebug.instance.throwError("DoubleList","removeNode","node",String(node)+" 有问题！");
			var nextNode:IDoubleNode=node.next;
			var prevNode:IDoubleNode=node.prev;
			node.unlink();
			//更新节点
			if(_currentNode==node)
			{
				if(nextNode)
					_currentNode=nextNode;
				else
					_currentNode=prevNode;
			}
			if(startNode.nodeData==null)
				startNode=nextNode;
			if(endNode.nodeData==null)
				endNode=prevNode;
			_numberChildren--;
			_invalidChildren=true;
			_isFullState=false;
		}
		/**
		 * 更新链表 
		 * 
		 */		
		protected function updateList(isNext:Boolean=true):void
		{
		}
		
		public function clearCalculationData():void
		{
			changedVos.length=0;
		}
		
		public function get isFull():Boolean
		{
			return _isFullState;
		}
		public function get numberChildren():uint
		{
			return _numberChildren;
		}

		public function add(nodeData:ICData):Vector.<ICData>
		{
			var isNext:Boolean;
			if(_currentNode!=null)
			{
				var node:IDoubleNode=searchFromNowByCondition(nodeData,bestCondition);
				isNext=doAddNode(nodeData,node);
			}
			else
			{
				isNext=doAddNode(nodeData,null);
			}
			//TODO:
			updateList(isNext);
			return changedVos.length>0?changedVos:null;
		}
		public function remove(nodeData:ICData):Vector.<ICData>
		{
			var index:int=changedVos.indexOf(nodeData);
			if(index>=0)
				changedVos.splice(index,1);
			doRemoveNode(nodeData);
			updateList();
			return changedVos.length>0?changedVos:null;
		}
		
		public function getDataByID(uniqueID:String):ICData
		{
			for(var child:IDoubleNode=startNode; child!=null; child=child.next)
			{
				if(child.nodeData.uniqueID==uniqueID)
					return child.nodeData;
			}
			return null;
		}
		protected function mapFromNode(node:IDoubleNode,callback:Function,isNext:Boolean):void
		{
			for(var child:IDoubleNode=node; child!=null; child=isNext?child.next:child.prev)
			{
				if(callback!=null)
					callback.call(null,child);
			}
		}
		/**
		 * 根据源数据与节点数据的比较结果，返回最优节点
		 * @param currentNode	当前节点
		 * @param sourceData	源数据
		 * @param compareResult	上一次的比较结果
		 * @return IDoubleNode	最优节点对象
		 * 
		 */		
		protected function bestCondition(currentNode:IDoubleNode,sourceData:ICData,compareResult:Number):IDoubleNode
		{
			var targetNode:IDoubleNode
			var otherNode:IDoubleNode=compareResult>0?currentNode.next:currentNode.prev;
			var curDistance:Number=sourceData.compare(currentNode.nodeData);
			if(otherNode==null)
			{
				targetNode=currentNode;
			}
			else if(curDistance*compareResult<0)
			{
				//不同向
				if(Math.abs(curDistance)<Math.abs(compareResult))
					targetNode=currentNode;
				else 
					targetNode=compareResult>0?currentNode.prev:currentNode.next;
			}
			return targetNode;
		}
		/**
		 * 返回与源数据唯一ID相等的节点
		 * @param currentNode	当前节点
		 * @param sourceData	源数据 
		 * @param param
		 * @return IDoubleNode
		 * 
		 */		
		protected function equalByIDCondition(currentNode:IDoubleNode,sourceData:ICData,...param):IDoubleNode
		{
			var targetNode:IDoubleNode;
			if(currentNode.nodeData.uniqueID==sourceData.uniqueID)
				targetNode=currentNode;
			return targetNode;
		}
		/**
		 * 从当前节点开始遍历，根据条件选择目标节点 
		 * @param nodeData	源数据
		 * @param condition	遍历条件
		 * @return IDoubleNode	目标节点
		 * 
		 */		
		protected function searchFromNowByCondition(nodeData:ICData,condition:Function):IDoubleNode
		{
			if(condition==null) return _currentNode;
			var distance:Number;
			var targetNode:IDoubleNode;
			for(var child:IDoubleNode=_currentNode; child!=null; child=distance>0 ? child.next : child.prev)
			{
				distance=nodeData.compare(_currentNode.nodeData);
				targetNode=condition.call(null,child,nodeData,distance);
				if(targetNode!=null) return targetNode;
			}
			return null;
		}
		public function forEachNode(callback:Function,isNext:Boolean=true):void
		{
			mapFromNode(isNext?startNode:endNode,callback,isNext);
		}
		
		public function clear():void
		{
			clearCalculationData();
			forEachNode(removeNode);
		}
	}
}
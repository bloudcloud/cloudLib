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
		protected var _headNode:IDoubleNode;
		protected var _endNode:IDoubleNode;
		//需要更新的位置的节点数据集合
		cloudLib var _changedVos:Vector.<ICData> = new Vector.<ICData>();
		
		private var _numberChildren:uint;

		public function DoubleList()
		{
		}
		
		protected function initList(nodeData:ICData):void
		{
			var node:IDoubleNode=createNode(nodeData);
			node.hasIn=true;
			_headNode=node;
			_endNode=node;
			_currentNode=node;
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
			if(node==_headNode)
			{
				//变更头节点
				_headNode=opreateNode;
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
			if(node==_endNode)
			{
				//变更尾节点
				_endNode=opreateNode;
			}
		}
		/**
		 * 执行添加节点操作 
		 * @param opreateData
		 * @param node
		 * @param isNext
		 * 
		 */
		protected function doAddNode(opreateData:ICData,node:IDoubleNode,isNext:Boolean):Boolean
		{
			if(node==null)
			{
				initList(opreateData);
			}
			else if(isNext)
			{
				addNodeAfter(opreateData,node);
			}
			else
			{
				addNodeBefore(opreateData,node);
			}
			_numberChildren++;
			_invalidChildren=true;
			return true;
		}
		/**
		 * 执行删除节点操作 
		 * @param opreateData
		 * 
		 */
		protected function doRemoveNode(opreateData:ICData):void
		{
			searchFromNow(opreateData,removeNode);
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
			if(_headNode.nodeData==null)
				_headNode=nextNode;
			if(_endNode.nodeData==null)
				_endNode=prevNode;
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
			var isNext:Boolean=true;
			if(_currentNode!=null)
			{
				isNext=nodeData.compare(_currentNode.nodeData)<0;
				compareFromNow(nodeData,doAddNode,isNext);
			}
			else
			{
				doAddNode(nodeData,null,isNext);
			}
			updateList(isNext);
			return _changedVos.length>0?_changedVos:null;
		}
		public function remove(nodeData:ICData):Vector.<ICData>
		{
			doRemoveNode(nodeData);
			updateList();
			return _changedVos.length>0?_changedVos:null;
		}
		
		public function getDataByID(uniqueID:String):ICData
		{
			for(var child:IDoubleNode=_headNode; child!=null; child=child.next)
			{
				if(child.nodeData.uniqueID==uniqueID)
					return child.nodeData;
			}
			return null;
		}
		protected function mapNode(node:IDoubleNode,callback:Function,isNext:Boolean):void
		{
			for(var child:IDoubleNode=node; child!=null; child=isNext?child.next:child.prev)
			{
				if(callback.call(null,child,isNext))
					break;
			}
		}
		/**
		 * 根据遍历顺序，比较源节点数据与当前节点数据，根据结果执行回调，返回回调的结果  
		 * @param nodeData
		 * @param callback
		 * @param isNext
		 * @return 
		 * 
		 */				
		protected function compareFromNow(nodeData:ICData,callback:Function,isNext:Boolean):*
		{
			var otherNode:IDoubleNode;
			var lastChild:IDoubleNode;
			var isResult:Boolean;
			var reciprocalDistance:Number;
			var child:IDoubleNode=_currentNode;
			for(;child!=null;child=otherNode)
			{
				reciprocalDistance=nodeData.compare(child.nodeData);
				if(isNext)
				{
					otherNode=child.next;
					isResult=reciprocalDistance>=0;
					lastChild=child.prev;
				}
				else
				{
					otherNode=child.prev;
					isResult=reciprocalDistance<0;
					lastChild=child.next;
				}
				if(isResult)
				{
					//当前节点在两个节点之间,选择最优节点
					var reciprocalDistance_last:Number=nodeData.compare(lastChild.nodeData);
					if(Math.abs(reciprocalDistance)>Math.abs(reciprocalDistance_last))
					{
						//最优节点
						lastChild=child;
					}
					else
					{
						reciprocalDistance=reciprocalDistance_last;
					}
					return callback.call(null,nodeData,lastChild,reciprocalDistance<0);
				}
				else if(otherNode==null)
					return callback.call(null,nodeData,child,isNext);
			}
			return null;
		}
		protected function searchFromNow(nodeData:ICData,callback:Function):Boolean
		{
			var compareEnd:Number=nodeData.compare(_currentNode.nodeData);
			var child:IDoubleNode
			if(compareEnd<0)
			{
				for(child=_currentNode; child!=null; child=child.next)
				{
					if(child.nodeData.uniqueID==nodeData.uniqueID)
					{
						if(callback!=null) 
							callback.call(null,child);
							return true;
					}		
				}
			}
			else if(compareEnd>0)
			{
				for(child=_currentNode; child!=null; child=child.prev)
				{
					if(child.nodeData.uniqueID==nodeData.uniqueID)
					{
						if(callback!=null) 
							callback.call(null,child);
						return true;
					}		
				}
			}
			else
			{
				if(callback!=null) 
					callback.call(null,_currentNode);
				return true;
			}
			return false;
		}
		
		public function forEachNode(callback:Function,isNext:Boolean=true):void
		{
			var child:IDoubleNode;
			for(child=isNext?_headNode:_endNode; child!=null; child=isNext?child.next:child.prev)
			{
				callback.call(null,child.nodeData);
			}
		}

		

	}
}
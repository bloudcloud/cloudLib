package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	/**
	 *  双向链表结构
	 * @author cloud
	 */
	public class DoubleList implements IDoubleList
	{
		protected var _currentNode:IDoubleNode;
		private var _rootNode:IDoubleNode;
		private var _endNode:IDoubleNode;
		private var _numberChildren:uint=0;
		
		public function DoubleList()
		{
		}
		
		private function initList(nodeData:ICData):void
		{
			var node:IDoubleNode=createNode(nodeData);
			node.hasIn=true;
			_rootNode=node;
			_endNode=node;
			_currentNode=node;
			_numberChildren++;
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
		 * @param node
		 * 
		 */		
		protected function addNodeBefore(sourceData:ICData,targetNode:IDoubleNode):Boolean
		{
			if(_endNode != targetNode || sourceData.compare(targetNode.nodeData)<0) return false;
			
			++_numberChildren;
			if(node==null)
			{
				//变更根节点
				_rootNode=_currentNode;
				
			}
			node.addBefore(_currentNode);
			return true;
		}
		/**
		 * 将节点添加到当前节点之后 
		 * @param node
		 * 
		 */		 
		protected function addNodeAfter(node:IDoubleNode):void
		{
			++_numberChildren;
			_currentNode.addAfter(node);
			if(_currentNode==_endNode)
			{
				//变更根节点
				_endNode=node;
				_currentNode=node;
			}
		}
		/**
		 * 移除节点 
		 * @param node
		 * 
		 */		
		protected function removeNode(node:IDoubleNode):void
		{
			node.unlink();
			--_numberChildren;
		}
		/**
		 * 更新坐标 
		 * 
		 */		
		protected function updateList():void
		{
		}
		public function get rootNode():IDoubleNode
		{
			return _rootNode;
		}
		
		public function set rootNode(value:IDoubleNode):void
		{
			_rootNode=value;
		}
		
		public function get endNode():IDoubleNode
		{
			return _endNode;
		}
		
		public function set endNode(value:IDoubleNode):void
		{
			_endNode=value;
		}
		public function get numberChildren():uint
		{
			return _numberChildren;
		}
		public function add(nodeData:ICData):Boolean
		{
			var node:IDoubleNode=createNode(nodeData);
			if(nodeData.compare(_currentNode.nodeData)<0)
			{
				mapNextFromNow();
			}
			if(_currentNode!=null)
			{
				mapFromNow(nodeData,);
			}
			else
			{
				initList(nodeData);
			}
			updateList();
			return true;
		}
		public function remove(nodeData:ICData):Boolean
		{
			searchFromNow(nodeData,removeNode);
			updateList();
			return true;
		}
		
		public function getDataByID(uniqueID:String):ICData
		{
			for(var child:IDoubleNode=_rootNode; child!=null; child=child.next)
			{
				if(child.nodeData.uniqueID==uniqueID)
					return child.nodeData;
			}
			return null;
		}
		/**
		 * 从当前节点向下遍历搜索 
		 * @param nodeData
		 * @param callback
		 * @return Boolean
		 * 
		 */
		public function mapNextFromNow(nodeData:ICData,callback:Function):Boolean
		{
			for(var child:IDoubleNode=_currentNode; child!=null; child=child.next)
			{
				if(child.next==null && (callback.call(null,nodeData,child))) return true;
				if(nodeData.compare(child.nodeData)>=0 && callback.call(null,nodeData,child)) return true;
			}
			return false;
		}
		/**
		 * 从当前节点向上遍历搜索 
		 * @param nodeData
		 * @param callback
		 * @return Boolean
		 * 
		 */		
		public function mapPrevFromNow(nodeData:ICData,callback:Function):Boolean
		{
			for(var child:IDoubleNode=_currentNode; child!=null; child=child.prev)
			{
				if(callback.call(null,child)) return true;
			}
			return false;
		}
		
		public function mapFromNow(source:ICData,callback:Function):Boolean
		{
			var child:IDoubleNode;
			if(source.compare(_currentNode.nodeData)<0)
			{
				for(child=_currentNode; child!=null; child=child.next)
				{
					if(callback.call(null,source,child)) return true;
				}
			}
			else
			{
				for(child=_currentNode; child!=null; child=child.prev)
				{
					if(callback.call(null,source,child)) return true;
				}
			}
			return false;
		}
		public function forEach(callback:Function):void
		{
			for(var child:IDoubleNode=_rootNode; child!=null; child=child.next)
			{
				callback.call(null,child.nodeData);
			}
		}
	}
}
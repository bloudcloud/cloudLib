package cloud.core.collections
{
	import cloud.core.interfaces.ICData;

	/**
	 *  双向链表结构
	 * @author cloud
	 */
	public class DoubleList implements IDoubleList
	{
		private var _currentNode:IDoubleNode;
		private var _rootNode:IDoubleNode;
		private var _endNode:IDoubleNode;
		private var _length:uint=0;
		
		public function DoubleList()
		{
		}
		
		private function initList(nodeData:ICData):void
		{
			var node:DoubleNode=new DoubleNode(nodeData);
			node.hasIn=true;
			_rootNode=node;
			_endNode=node;
			_currentNode=node;
			_length++;
		}
		/**
		 * 将节点添加到当前节点之前 
		 * @param node
		 * 
		 */		
		protected function addNodeBefore(node:IDoubleNode):void
		{
			++_length;
			_currentNode.addBefore(node);
			if(_currentNode==_rootNode)
			{
				//变更根节点
				_rootNode=node;
				_currentNode=node;
			}
		}
		/**
		 * 将节点添加到当前节点之后 
		 * @param node
		 * 
		 */		 
		protected function addNodeAfter(node:IDoubleNode):void
		{
			++_length;
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
			--_length;
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
		public function get length():uint
		{
			return _length;
		}
		public function add(nodeData:ICData):void
		{
			var node:DoubleNode=new DoubleNode(nodeData);
			if(_currentNode!=null)
			{
				if(nodeData.compare(_currentNode.nodeData)>0)
					addNodeBefore(node);
				else
					addNodeAfter(node);
			}
			else
			{
				initList(nodeData);
			}
		}
		public function remove(nodeData:ICData):void
		{
			mapFromNow(nodeData,removeNode);
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

		public function mapFromNow(nodeData:ICData,callback:Function):Boolean
		{
			var child:IDoubleNode;
			if(nodeData.compare(_currentNode.nodeData)>0)
			{
				for(child=_currentNode; child!=null; child=child.prev)
				{
					if(nodeData==child.nodeData)
					{
						callback.call(null,child);
						return true;
					}
				}
			}
			else
			{
				for(child=_currentNode; child!=null; child=child.next)
				{
					if(nodeData==child.nodeData)
					{
						callback.call(null,child);
						return true;
					}
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
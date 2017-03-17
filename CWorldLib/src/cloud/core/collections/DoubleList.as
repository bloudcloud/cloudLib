package cloud.core.collections
{
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
		
		private function initList(node:IDoubleNode):void
		{
			node.hasIn=true;
			_rootNode=node;
			_endNode=node;
			_currentNode=node;
			_length++;
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
		
		public function addBefore(node:IDoubleNode):void
		{
			++_length;
			if(_currentNode!=null)
			{
				_currentNode.addBefore(node);
				if(_currentNode==_rootNode)
				{
					//变更根节点
					_rootNode=node;
					_currentNode=node;
				}
			}
			else
			{
				initList(node);
			}
			
		}
		
		public function addAfter(node:IDoubleNode):void
		{
			++_length;
			if(_currentNode!=null)
			{
				_currentNode.addAfter(node);
				if(_currentNode==_endNode)
				{
					//变更根节点
					_endNode=node;
					_currentNode=node;
				}
			}
			else
			{
				initList(node);
			}
		}
		
		public function remove(node:IDoubleNode):void
		{
			node.unlink();
			--_length;
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
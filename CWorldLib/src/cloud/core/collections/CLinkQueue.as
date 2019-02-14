package cloud.core.collections
{
	/**
	 * 
	 * @author	cloud
	 * @date	2018-8-31
	 */
	public class CLinkQueue
	{
		private var _rootNode:ICDoubleNode;
		private var _currentNode:ICDoubleNode;
		private var _length:int;
		
		public function CLinkQueue()
		{
		}
		
//		public function get nextNode():*
//		{
//			return null;
//		}
//		
//		public function get prevNode():*
//		{
//			return null;
//		}
		
		public function addAfter(node:ICDoubleNode):void
		{
			if(_length==0)
			{
				_rootNode=node;
				_currentNode=node;
			}
			else
			{
				_currentNode.addAfter(node);
				_currentNode=node;
			}
			_length++;
		}
		
		public function addBefore(node:ICDoubleNode):void
		{
			if(_length==0)
			{
				_rootNode=node;
				_currentNode=node;
			}
			else
			{
				if(_rootNode==_currentNode)
				{
					_rootNode=node;
				}
				_currentNode.addBefore(node);
				_currentNode=node;
			}
			_length++;
		}
		
		private function doSearchNode(node:ICDoubleNode):Boolean
		{
			return false;
		}
		public function removeNode(node:ICDoubleNode):void
		{
			if(doSearchNode(node))
			{
				node.unlink();
			}
			else
			{
				
			}
		}
		
//		public function 
	}
}
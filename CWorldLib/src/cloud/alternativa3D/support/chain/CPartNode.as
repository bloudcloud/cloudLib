package cloud.alternativa3D.support.chain
{
	import cloud.alternativa3D.support.chain.ICNode;

	public class CPartNode implements ICNode
	{
		protected var _prevNode:ICNode;
		protected var _nextNode:ICNode;
		protected var _index:int=-1;
		
		public function get prevNode():ICNode
		{
			return _prevNode;
		}
		
		public function set prevNode(node:ICNode):void
		{
			_prevNode = node;
		}
		
		public function get nextNode():ICNode
		{
			return _nextNode;
		}
		
		public function set nextNode(node:ICNode):void
		{
			_nextNode = node;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
	}
}
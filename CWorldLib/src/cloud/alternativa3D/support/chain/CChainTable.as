package cloud.alternativa3D.support.chain
{
	import flash.geom.Vector3D;
	
	public class CChainTable implements ICChainTable
	{
		protected var _rootNode:ICNode;
		protected var _chainLength:int;
		protected var _invalidPos:Boolean;
		protected var _position:Vector3D;
		protected var _direction:int;

		public function get position():Vector3D
		{
			if(_invalidPos)
			{
				updatePosition();
				_invalidPos=false;
			}
			return _position;
		}

		
		public function CChainTable()
		{
			_position=new Vector3D();
		}
		
		/**
		 * 执行根据索引获取节点 
		 * @param node
		 * @param index
		 * @return 
		 * 
		 */		
		private function doGetNode(node:ICNode,index:int):ICNode
		{
			return node.index==index ? node : doGetNode(node.nextNode,index);
		}
		/**
		 *  执行删除节点
		 * @param node
		 * 
		 */		
		private function doRemoveNode(node:ICNode):void
		{
			if(node)
			{
				if(node.index!=0)
				{
					node.prevNode.nextNode=null;
					node.prevNode=null;
					node.index=-1;
				}
				doRemoveNode(node.nextNode);
				node.nextNode=null;
			}
		}
		
		public function updatePosition():void
		{
			
		}
		
		public function updateDirection():void
		{
			
		}
		
		public function get chainLength():int
		{
			return _chainLength;
		}
		
		public function addChainNode(node:ICNode):void
		{
			_invalidPos=true;
			node.index=_chainLength++;
			node.prevNode=getChainNodeByIndex(node.index-1);
			node.prevNode.nextNode=node;
		}
		
		public function removeChainNode(node:ICNode):void
		{
			_invalidPos=true;
			doRemoveNode(node);
			node.nextNode=null;
		}
		
		public function getChainNodeByIndex(index:int):ICNode
		{
			return index<0 || index>=_chainLength-1 ? null : doGetNode(_rootNode,index);
		}
	}
}
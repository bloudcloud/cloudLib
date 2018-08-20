package cloud.ds
{
	import cloud.ds.nodes.CGraphNode;

	/**
	 * 
	 * @author	cloud
	 * @date	2018-7-13
	 */
	public class CGraph
	{
		public var nodes:Array;
		public var count:int;
		
		public function CGraph()
		{
			nodes=[];
			count=0;
		}
		
		public function addGraphNode(data:*,index:int):Boolean
		{
			if(nodes[index])
			{
				return false;
			}
			nodes[index]=new CGraphNode(data);
			return true;
		}
		
		public function removeGraphNode(index:int):Boolean
		{
			if(!nodes[index])
			{
				return false;
			}
			var targetNode:CGraphNode=nodes[index];
			//删除所有该节点的引用
			for(var i:int=nodes.length-1; i>=0; i--)
			{
				nodes[i].removeContected(targetNode);
			}
			
			return true;
		}
		
	}
}
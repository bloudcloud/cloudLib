package cloud.ds.nodes
{
	/**
	 * 联通图节点
	 * @author	cloud
	 * @date	2018-7-12
	 */
	public class CGraphNode
	{
		private var _nodeData:*;
		private var _contectNodes:Vector.<CGraphNode>;
		
		public function CGraphNode(data:*)
		{
			_nodeData=data;
			_contectNodes=new Vector.<CGraphNode>();
		}
		
		/**
		 * 添加一个连接节点
		 * @param p_node 目标GraphNode
		 * @param p_weight 该Arc的权重(weight)
		 */
		public function addContected(node:CGraphNode):void
		{
			_contectNodes.push(new CGraphNode(node));
		}
		/**
		 * 移除一个连接节点 
		 * @param node
		 * @return Boolean
		 * 
		 */		
		public function removeContected(node:CGraphNode):Boolean
		{
			for(var i:int=_contectNodes.length-1; i>=0; i--)
			{
				if(_contectNodes[i]==node)
				{
					_contectNodes.splice(i,1);
					return true;
				}
			}
			return false;
		}
		/**
		 *  连通节点中是否有该节点
		 * @param node
		 * @return Boolean
		 * 
		 */		
		public function hasContected(node:CGraphNode):Boolean
		{
			for(var i:int=_contectNodes.length-1; i>=0; i--)
			{
				if(_contectNodes[i]==node)
				{
					return true;
				}
			}
			return false;
		}

	}
}
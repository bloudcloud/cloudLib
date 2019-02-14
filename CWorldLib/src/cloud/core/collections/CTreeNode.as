package cloud.core.collections
{
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.utils.CDebugUtil;

	/**
	 * 树节点
	 * @author	cloud
	 * @date	2018-8-27
	 */
	public class CTreeNode 
	{
		private var _children:Vector.<CTreeNode>;
		private var _isMarked:Boolean;
		private var _nodeData:ICNodeData;
		private var _numChildren:int;
		
		public var parent:CTreeNode;
		
		public function get isMarked():Boolean
		{
			return _isMarked;
		}
		public function set isMarked(value:Boolean):void
		{
			_isMarked=value;
		}
		
		public function get isEnd():Boolean
		{
			return _numChildren==0;
		}
		public function get nodeData():ICNodeData
		{
			return _nodeData;
		}
		public function get numChildren():int
		{
			return _numChildren;
		}
		
		public function CTreeNode(data:ICNodeData)
		{
			_children=new Vector.<CTreeNode>();
			_nodeData=data;
		}
		
		public function addChild(node:CTreeNode):void
		{
			if(node.parent)
			{
				node.parent.removeChild(node);
			}
			node.parent=this;
			_children.push(node);
			_numChildren++;
		}
		
		public function removeChild(node:CTreeNode):Boolean
		{
			for (var i:int=_children.length-1; i>=0; i--)
			{
				if(_children[i]==node)
				{
					node.parent=null;
					_children.splice(i,1);
					_numChildren--;
					return true;
				}
			}
			return false;
		}
		/**
		 * 为当前子节点执行回调，并返回执行结果，如果成功执行返回null,否则返回该子节点对象
		 * @param callback	回调方法
		 * @param index	子节点的索引
		 * @return CTreeNode
		 * 
		 */		
		private function doForeachChild(callback:Function,index:int):CTreeNode
		{
			//遍历当前节点以及其所有子节点
			var breakNode:CTreeNode=_children[index].foreachChildren(callback);
			
			if(breakNode)
			{
				return breakNode;
			}
			else if(index==0)
			{
				//没有其他子节点，返回null,结束遍历
				return null;
			}
			//执行下一个节点遍历
			return doForeachChild(callback,index-1);
		}
		/**
		 * 遍历所有子节点 
		 * @param callback
		 * @return Boolean
		 * 
		 */		
		public function foreachChildren(callback:Function):CTreeNode
		{
			if(callback==null)
			{
				CDebugUtil.Instance.traceStr("树遍历时执行的回掉方法为空，返回失败！", this);
				return null;
			}
			var result:CTreeNode;
			var bool:Boolean;
			
			bool=callback(this);
			if(bool)
			{
				result=this;
			}
			else if(!isEnd)
			{
				//继续查询所有子节点,从子节点尾部开始
				result=doForeachChild(callback,_children.length-1);
			}
			return result;
		}
		
		public function clearChildren():void
		{
			_children.length=0;
		}
	}
}
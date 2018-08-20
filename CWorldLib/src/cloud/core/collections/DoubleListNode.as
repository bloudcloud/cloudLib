package cloud.core.collections
{
	import cloud.core.interfaces.ICNodeData;
	
	/**
	 *  双向单循环链表节点类
	 * @author cloud
	 */
	public class DoubleListNode extends DoubleList implements ICycleDoubleNode
	{
		protected var _data:ICNodeData;
		protected var _next:ICDoubleNode;
		protected var _prev:ICDoubleNode;
		protected var _hasIn:Boolean;
		
		public function get isEmpty():Boolean
		{
			return _currentNode==null;
		}
		
		public function DoubleListNode(sourceVo:ICNodeData)
		{
			_data=sourceVo;
			super();
		}
		/**
		 * 做一次循环遍历，执行回调函数
		 * @param callback	回调函数
		 * @param isNext	遍历方向是否向下
		 * 
		 */		
		public function foreachForOnce(callback:Function):void
		{
			var child:ICDoubleNode;
			for(child=this.next; child!=this; child=this.next)
			{
				if(child is ICycleDoubleNode && callback!=null)
					callback.call(null,child as ICycleDoubleNode);
			}
		}
		
		public function get hasIn():Boolean
		{
			return _hasIn;
		}
		
		public function set hasIn(value:Boolean):void
		{
			_hasIn=value;
		}
		
		public function get next():ICDoubleNode
		{
			return _next;
		}
		
		public function set next(value:ICDoubleNode):void
		{
			_next = value;
		}
		
		public function get prev():ICDoubleNode
		{
			return _prev;
		}
		
		public function set prev(value:ICDoubleNode):void
		{
			_prev = value;
		}
		
		public function get nodeData():ICNodeData
		{
			return _data;
		}
		
		public function set nodeData(value:ICNodeData):void
		{
			_data = value;
		}
		
		public function get nodeLength():uint
		{
			var cursor:ICDoubleNode; 
			var length:uint = 1;
			for (cursor = _prev; cursor != null; cursor = cursor.prev) { 
				length++; 
			} 
			return length;
		}
		public function addAfter(node:ICDoubleNode):void
		{
			if(node.next==null)
				node.next = _next; 
			node.prev = this; 
			if (_next!=null) { 
				_next.prev = node; 
			}
			_next = node; 
			node.hasIn=true; 
		}
		
		public function addBefore(node:ICDoubleNode):void
		{
			node.next = this; 
			if(node.prev==null)
				node.prev = _prev; 
			if (_prev!=null) { 
				_prev.next = node; 
			} 
			_prev = node; 
			node.hasIn=true; 
		}
		
		public function unlink():void
		{
			if (_prev!=null) { 
				_prev.next = _next; 
			} 
			if (_next!=null) { 
				_next.prev = _prev; 
			} 
			_next = _prev = null; 
			_hasIn=false; 
			this._data=null;
		}
		
		public function toString():String
		{
			return "[DoubleListNode, data=" + _data.toString() + "]";
		}

	}
}
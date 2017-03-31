package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	
	/**
	 *  双向单循环链表节点类
	 * @author cloud
	 */
	public class DoubleListNode extends DoubleList implements ICycleDoubleNode
	{
		protected var _data:ICData;
		protected var _next:IDoubleNode;
		protected var _prev:IDoubleNode;
		protected var _hasIn:Boolean;
		
		public function get isEmpty():Boolean
		{
			return _currentNode==null;
		}
		
		public function DoubleListNode()
		{
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
			var child:IDoubleNode;
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
		
		public function get next():IDoubleNode
		{
			return _next;
		}
		
		public function set next(value:IDoubleNode):void
		{
			_next = value;
		}
		
		public function get prev():IDoubleNode
		{
			return _prev;
		}
		
		public function set prev(value:IDoubleNode):void
		{
			_prev = value;
		}
		
		public function get nodeData():ICData
		{
			return _data;
		}
		
		public function set nodeData(value:ICData):void
		{
			_data = value;
		}
		
		public function addAfter(node:IDoubleNode):void
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
		
		public function addBefore(node:IDoubleNode):void
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
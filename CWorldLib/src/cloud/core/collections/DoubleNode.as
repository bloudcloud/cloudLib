package cloud.core.collections
{
	import cloud.core.interfaces.ICData;

	public class DoubleNode implements IDoubleNode
	{
		//双向链表， double list node 
		private var _data:ICData; 
		protected var _prev:IDoubleNode; 
		protected var _next:IDoubleNode; 
		//标志是否已在链表中 
		private var _hasIN:Boolean=false; 
		//@initData:结点初始值， the node’ data; 
		public function DoubleNode(source:ICData) { 
			_data = source; 
			_prev = _next = null; 
		} 
		//this node has in link 
		public function get hasIn():Boolean { 
			return _hasIN; 
		} 
		public function set hasIn(boolean:Boolean):void { 
			_hasIN=boolean; 
		} 
		//后继节点 
		public function get next():IDoubleNode { 
			return _next; 
		} 
		//前驱节点 
		public function get prev():IDoubleNode { 
			return _prev; 
		} 
		//设定后继 
		public function set next(newNode:IDoubleNode):void { 
			_next = newNode; 
		} 
		//设定前驱 
		public function set prev(newNode:IDoubleNode):void { 
			_prev = newNode; 
		} 
		//取得当前结点数据, return the node’s data 
		public function get nodeData():ICData { 
			return _data; 
		} 
		//设置当前结点数据， set the node‘s data 
		public function set nodeData(newData:ICData):void { 
			_data = newData; 
		} 
		//在当前节点后插入结点， append a new node after current node 
		public function addAfter(newNode:IDoubleNode):void { 
			newNode.next = _next; 
			newNode.prev = this; 
			if (_next!=null) { 
				_next.prev = newNode; 
			}
			_next = newNode; 
			newNode.hasIn=true; 
		} 
		//在当前节点前插入结点， append a new node before current node 
		public function addBefore(newNode:IDoubleNode):void { 
			newNode.next = this; 
			newNode.prev = _prev; 
			if (_prev!=null) { 
				_prev.next = newNode; 
			} 
			_prev = newNode; 
			newNode.hasIn=true; 
		} 
		//返回当前数组长度， get the length of the node 
		public function get nodeLength():uint { 
			var cursor:IDoubleNode; 
			var length:uint = 1; 
			for (cursor = _prev; cursor != null; cursor = cursor.prev) { 
				length++; 
			} 
			return length; 
		} 
		//从双向链表中脱离。 get out of link to the double-node 
		public function unlink():void { 
			if (_prev!=null) { 
				_prev.next = _next; 
			} 
			if (_next!=null) { 
				_next.prev = _prev; 
			} 
			_next = _prev = null; 
			_hasIN=false; 
			this._data=null;
		} 
		//描述当前double-node， rerurn a string represent the double-node 
		public function toString():String { 
			return "[DoubleNode, data=" + _data.toString() + "]"; 
		} 
	} 
}
package cloud.core.collections
{
	import cloud.core.interfaces.ICNodeData;

	/**
	 * 双向链表节点
	 * @author cloud
	 * 
	 */	
	public class CDoubleNode implements ICDoubleNode
	{
		private var _data:ICNodeData; 
		private var _hasIN:Boolean=false; 
		
		protected var _prev:ICDoubleNode; 
		protected var _next:ICDoubleNode; 
		
		/**
		 * 初始化节点 
		 * @param source
		 * 
		 */		
		public function CDoubleNode(source:ICNodeData) { 
			_data = source; 
			_prev = _next = null; 
		} 
		/**
		 * 获取节点是否已在链表中 
		 * @return 
		 * 
		 */		
		public function get hasIn():Boolean { 
			return _hasIN; 
		} 
		/**
		 * 设置节点是否已在链表中 
		 * @param boolean
		 * 
		 */		
		public function set hasIn(boolean:Boolean):void { 
			_hasIN=boolean; 
		} 
		/**
		 * 获取下一个节点 
		 * @return ICDoubleNode
		 * 
		 */		
		public function get next():ICDoubleNode { 
			return _next; 
		} 
		/**
		 * 获取上一个节点 
		 * @return ICDoubleNode
		 * 
		 */		
		public function get prev():ICDoubleNode { 
			return _prev; 
		} 
		/**
		 * 设置下一个节点 
		 * @param newNode
		 * 
		 */		
		public function set next(newNode:ICDoubleNode):void { 
			_next = newNode; 
		} 
		/**
		 * 设置上一个节点 
		 * @param newNode
		 * 
		 */		
		public function set prev(newNode:ICDoubleNode):void { 
			_prev = newNode; 
		} 
		/**
		 * 获取当前节点数据 
		 * @return ICNodeData
		 * 
		 */		
		public function get nodeData():ICNodeData { 
			return _data; 
		} 
		/**
		 * 设置当前节点数据 
		 * @param newData
		 * 
		 */		
		public function set nodeData(newData:ICNodeData):void { 
			_data = newData; 
		} 
		/**
		 * 在当前节点之后添加节点 
		 * @param newNode
		 * 
		 */		
		public function addAfter(newNode:ICDoubleNode):void { 
			newNode.next = _next; 
			newNode.prev = this; 
			if (_next!=null) { 
				_next.prev = newNode; 
			}
			_next = newNode; 
			newNode.hasIn=true; 
		} 
		/**
		 * 在当前节点之间添加节点 
		 * @param newNode
		 * 
		 */		
		public function addBefore(newNode:ICDoubleNode):void { 
			newNode.next = this; 
			newNode.prev = _prev; 
			if (_prev!=null) { 
				_prev.next = newNode; 
			} 
			_prev = newNode; 
			newNode.hasIn=true; 
		} 
		/**
		 * 返回当前节点长度 
		 * @return uint
		 * 
		 */		
		public function get nodeLength():uint { 
			var cursor:ICDoubleNode; 
			var length:uint = 1; 
			for (cursor = _prev; cursor != null; cursor = cursor.prev) { 
				length++; 
			} 
			return length; 
		} 
		/**
		 * 将当前节点脱离出原有链表 
		 * 
		 */		
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
		/**
		 * 描述当前节点数据信息 
		 * @return String
		 * 
		 */		
		public function toString():String { 
			return "[CDoubleNode, data=" + _data.toString() + "]"; 
		}
		
	} 
}
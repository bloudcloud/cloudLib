package cloud.ds.nodes
{
	public class CListNode
	{
		public var data:* ;
		public var next:CListNode = null;
		public var prev:CListNode = null;
		
		public function CListNode(Data:*):void
		{
			this.data = Data;
		}
		/**
		 * 从链表中删除此节点 
		 * 
		 */		
		public function delink():void
		{
			if (prev)
			  prev.next = next;
			if (next)
			  next.prev = prev;
		}
		/**
		 * 在当前节点之后插入 
		 * @param data
		 * 
		 */		
		public function insertAfter(data:*):void
		{
			var node:CListNode = new CListNode(data);
			node.next = next;
			node.prev = this;
			
			if (next != null)
			  next.prev = node;
			
			next = node;
		}
		/**
		 * 在当前节点之前插入 
		 * @param data
		 * 
		 */		
		public function insertBefore(data:*):void
		{
			var node:CListNode = new CListNode(data);
			node.next = this;
			node.prev = prev;
			
			if (prev)
			  prev.next = node;
			prev = node;
		}

		public function toString():String
		{
			return this.data.toString();
		}
	}

}
package cloud.ds.iterators
{
	import cloud.ds.CLinkedList;
	import cloud.ds.nodes.CListNode;
	
	/**
	 * 链表迭代器类
	 * @author cloud
	 * 
	 */	
	public class CListIterator
	{
		/**
		 * 迭代的节点对象 
		 */		
		public var node:CListNode;
		/**
		 * 迭代的链表容器 
		 */		
		public var list:CLinkedList;
		/**
		 * 必须有迭代的存储容器和迭代的存储对象 
		 * @param list	链表对象
		 * @param node	链表节点
		 * 
		 */		
		public function CListIterator(list:CLinkedList, node:CListNode = null)
		{
			this.list = list;
			this.node = node;
		}
		/**
		 * 设置迭代器指向起始位置
		 * 
		 */		
		public function start():void
		{
			if(list)
				node = list.head;
		}
		/**
		 * 设置迭代器指向终止位置 
		 * 
		 */		
		public function end():void
		{
			if(list)
				node = list.tail;
		}
		/**
		 * 设置迭代器指向下一个位置 
		 * 
		 */		
		public function next():void
		{
			if(node)
				node = node.next;
		}
		/**
		 * 设置迭代器指向上一个位置 
		 * 
		 */		
		public function prev():void
		{
			if(node)
				node = node.prev;
		}
		/**
		 * 判断当前指向是否有效
		 * @return Boolean
		 * 
		 */		
		public function valid():Boolean
		{
			return node != null;
		}
		/**
		 * 获取当前指向的节点数据的引用 
		 * @return *
		 * 
		 */		
		public function get data():*
		{
			if(node)
				return node.data;
			return null;
		}
		/**
		 * 目标迭代器是否与当前迭代器的指向相同
		 * @param iterator	
		 * @return Boolean	
		 * 
		 */		
		public function equalTo(iterator:CListIterator):Boolean
		{
			return node == iterator.node && list == iterator.list;
		}
	}
}
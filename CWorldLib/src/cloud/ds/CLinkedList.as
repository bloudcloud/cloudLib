package cloud.ds
{
	import cloud.ds.iterators.CListIterator;
	import cloud.ds.nodes.CListNode;
	
	/**
	 *  双向链表
	 */
	public class CLinkedList
	{
		public var head:CListNode = null;
		public var tail:CListNode = null;
		private var _length:uint = 0;
		/**
		 * 初始化链表 
		 * @param args	链表数据集合
		 * 
		 */		
		public function CLinkedList(...args):void
		{ 
		   var l:uint = args.length;
		   if(l>0)
		   {
			   head = tail = new CListNode(args[0]);
			   _length++ ;
			   if(l>1)
			   {
				 for(var i:uint = 1 ; i < l; i++)
				 {
					 push(args[i]);
				 }
			   }
		   }
		 }
		/**
		 * 根据索引获取节点数据，由于需要遍历所以比数组慢很多 
		 * @param idx
		 * @return *
		 * 
		 */		
		public function getData(idx:uint):*
		{
			var n:CListNode = getListNode(idx);
			return n == null ? null : n.data;
		}
		/**
		 * 根据索引，设置节点数据，由于需要遍历所以比数组慢很多 
		 * @param idx	索引
		 * @param obj	新的节点数据
		 * @return *
		 * 
		 */		
		public function setData(idx:uint , obj:*):*
		{
			var n:CListNode = getListNode(idx);
			if (n)
			  n.data = obj;
		}
		/**
		 * 添加尾结点数据
		 * @param	obj
		 * @return	CListNode
		 */
		public function push(obj:*):CListNode
		{
			if (obj == null)
				return null;
			if (_length > 0)
			{
				tail.insertAfter(obj);
				tail = tail.next;
			}else
			{
				head = tail = new CListNode(obj);
			}
			_length++;
			return tail;
		}
		/**
		 *  删除尾节点数据
		 */
		public function pop():CListNode
		{
			if (_length <= 0) 
			   return null;
			   
			var d:CListNode = tail;
			if(this._length == 1)
				head = tail = null;
			else
			{
				tail = tail.prev;
				tail.next = null;
			}
			_length--;
			return d;
		}
		/**
		 * 删除头节点数据 
		 * @return CListNode
		 * 
		 */		
		public function shift():CListNode
		{
			if (_length <= 0)
			   return null;
			   
			var d:CListNode = head;
			if (_length == 1)
			{
				head = tail = null;
			}else
			{
				head = head.next;
				head.prev = null;
			}
			_length--;
			return d;
			
		}
		/**
		 * 添加头节点数据 
		 * @param obj
		 * @return CListNode
		 * 
		 */		
		public function unshift(obj:*):CListNode
		{
			if (obj == null)
				return null;
			if (_length > 0)
			{
				head.insertBefore(obj);
				head = head.prev;
			}else
			{
				head = tail = new CListNode(obj);
			}
			_length++;
			return head;
		}
		/**
		 * 在iterator后插入数据，如果iterator是invalid的则push到对尾
		 * @param	iterator
		 * @param	obj
		 */
		public function insertAfter( iterator:CListIterator , obj:*):void
		{
			if (iterator && iterator.node != null)
			{
				iterator.node.insertAfter(obj);
				if (iterator.node == tail)
				  tail = tail.next;
				  
				_length ++ ;
			}else
			{
				push(obj);
			}
		}
		/**
		 * 在iterator前插入数据，如果iterator是invalid的则unshift到队首
		 * @param iterator
		 * @param obj
		 * 
		 */		
		public function insertBefore(iterator:CListIterator, obj:*):void
		{
			if (iterator && iterator.node != null)
			{
				iterator.node.insertBefore(obj);
				if (iterator.node == head)
				  head = head.prev;
				  
				_length ++;
			}else {
				unshift(obj);
			}
		} 
		/**
		 * 删除iterator指定节点，并把iterator向后移一位。
		 * @param	iterator
		 */
		public function remove( iterator:CListIterator ):void
		{
			if (!iterator || !iterator.node)
				return;
				
			var node:CListNode = iterator.node;
			if (node == head)
				head = head.next;
			else if (node == tail)
				tail = tail.prev;
			iterator.next();
			node.delink();
			
			if (head == null)
			  tail = null;
			
			_length --;
		}
		/**
		 * 获取链表的长度
		 * @return uint
		 * 
		 */		
		public function get length():uint
		{
			return _length;
		}
		/**
		 * 获取迭代器，默认指向头节点
		 * @param	node
		 * @return	CListIterator
		 */
		public function getIterator(node:CListNode = null ):CListIterator
		{
			return new CListIterator(this, node == null? head : node);
		}
	   /**
	    * 根据索引获取链表的节点 
	    * @param idx
	    * @return CListNode
	    * 
	    */	 
		public function getListNode(idx:uint):CListNode
		{
			if (_length <= 0 || idx < 0 || idx > _length-1)return null;
			var n:CListNode = head;
			var i:uint = 0;
			while (i < idx)
			{
				i++;
				n = n.next;
			}
			return n;
		}
		public function toString():String
		{
			var str:String = "[";
			var n:CListNode = this.head;
			while(n)
			{
				str += n.toString();
				if(n!= this.tail)
					str+=",";
				n = n.next;
			}
			str += "]";
			return str;
		}
		
	}
}



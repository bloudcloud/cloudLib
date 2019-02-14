package cloud.core.collections
{
	import cloud.core.interfaces.ICIterator;
	
	import ns.cloudLib;
	
	use namespace cloudLib;
	/**
	 * 迭代器
	 * @author	cloud
	 * @date	2018-9-7
	 */
	public class CIterator implements ICIterator
	{
		private var _iteratorData:*;
		private var _next:ICIterator;
		private var _prev:ICIterator;

		public function CIterator(data:*)
		{
			_iteratorData=data;
		}
		
		public function get iteratorData():*
		{
			return _iteratorData;
		}
		
		public function get next():ICIterator
		{
			return _next;
		}

		public function get prev():ICIterator
		{
			return _prev;
		}
		
		public function get linkLength():int
		{
			var length:int;
			
			for(var curIterator:ICIterator=_next; curIterator!=this; curIterator=curIterator.next)
			{
				length++;
			}
			length++;
			return length;
		}
		
		public function set next(value:ICIterator):void
		{
			_next=value;
		}
		
		public function set prev(value:ICIterator):void
		{
			_prev=value;
		}
		
		public function linkToNext(iterator:ICIterator):void
		{
			var linkedIterator:CIterator=iterator as CIterator;
			linkedIterator.prev = this; 
			if (_next is CIterator) { 
				(_next as CIterator).prev = linkedIterator; 
			}
			_next = linkedIterator;
		}
		/**
		 * 根据数据获取迭代器对象 
		 * @param iteratorData
		 * @return ICIterator
		 * 
		 */		
		public function getIteratorByData(iteratorData:*):ICIterator
		{
			var isSearched:Boolean;
			for(var curIterator:ICIterator=_next; curIterator!=this; curIterator=curIterator.next)
			{
				if(curIterator.iteratorData==iteratorData)
				{
					isSearched=true;
					break;
				}
			}
			return isSearched?curIterator:null;
		}
		
		public function unlink():void
		{
			if (_prev is CIterator) { 
				(_prev as CIterator).next = _next; 
			} 
			if (_next is CIterator) { 
				(_next as CIterator).prev = _prev; 
			} 
			_next = _prev = null; 
		}
	}
}
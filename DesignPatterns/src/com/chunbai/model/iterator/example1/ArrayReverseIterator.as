package com.chunbai.model.iterator.example1
{
	/**
	 * 迭代器接口实现类2
	 * */
	public class ArrayReverseIterator implements IIterator
	{
		private var _index:uint = 0;
		private var _collection:Array;
		
		public function ArrayReverseIterator($collection:Array)
		{
			_collection = $collection;
			_index = 0;
		}
		
		public function reset():void
		{
		    _index = 0;
		}
		
		public function next():Object
		{
		    return _collection[_index--];
		}
		
		public function hasNext():Boolean
		{
		    return _index >= 0;
		}
		
	}
}
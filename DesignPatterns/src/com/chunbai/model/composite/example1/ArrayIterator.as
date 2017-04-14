package com.chunbai.model.composite.example1
{
	/**
	 * 迭代器接口实现类1
	 * */
	public class ArrayIterator implements IIterator
	{
		private var _index:uint = 0;
		private var _collection:Array;
		
		public function ArrayIterator($collection:Array)
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
		    return _collection[_index++];
		}
		
		public function hasNext():Boolean
		{
		    return _index < _collection.length;
		}
		
	}
}
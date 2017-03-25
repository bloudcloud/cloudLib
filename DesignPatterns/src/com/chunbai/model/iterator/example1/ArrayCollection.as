package com.chunbai.model.iterator.example1
{
	/**
	 * 集合接口实现类
	 */
	public class ArrayCollection implements ICollection
	{
		public static const ARRAYITERATOR:String = "ArrayIterator";
		public static const ARRAYREVERSEITERATOR:String = "ArrayReverseIterator";
		
		private var _data:Array;
		
		public function ArrayCollection()
		{
			_data = [];
		}
		
		public function addElement($value:String):void
		{
		    _data.push($value);
		}
		
		public function iterator($type:String=null):IIterator
		{
		    if($type == ARRAYITERATOR)
			{
			    return new ArrayIterator(_data);
			}
			else if($type == ARRAYREVERSEITERATOR)
			{
			    return new ArrayReverseIterator(_data);
			}
			else
			{
			    return null;
			}
		}
		
	}
}
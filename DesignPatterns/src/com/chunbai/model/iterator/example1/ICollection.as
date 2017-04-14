package com.chunbai.model.iterator.example1
{
	/**
	 * 集合接口
	 * */
	public interface ICollection
	{
		function iterator($type:String=null):IIterator;
		
	}
}
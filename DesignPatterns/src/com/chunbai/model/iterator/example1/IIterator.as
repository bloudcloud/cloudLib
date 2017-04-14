package com.chunbai.model.iterator.example1
{
	/**
	 * 迭代器接口
	 * */
	public interface IIterator
	{
		function reset():void;
		function next():Object;
		function hasNext():Boolean;
	}
}
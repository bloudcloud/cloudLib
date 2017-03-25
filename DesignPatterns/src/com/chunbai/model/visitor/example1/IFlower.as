package com.chunbai.model.visitor.example1
{
	
	/**
	 * 元素接口
	 * */
	public interface IFlower
	{
		function accept($v:IVisitor):void;
		
	}
}
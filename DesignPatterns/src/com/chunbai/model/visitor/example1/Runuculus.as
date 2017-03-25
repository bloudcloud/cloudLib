package com.chunbai.model.visitor.example1
{
	
	/**
	 * 具体元素角色
	 * */
	public class Runuculus implements IFlower
	{
		public function Runuculus()
		{
			
		}
		
		public function accept($v:IVisitor):void
		{ 
			$v.visit2(this);
		}
		
	}
}
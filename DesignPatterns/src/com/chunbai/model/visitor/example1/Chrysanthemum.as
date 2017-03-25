package com.chunbai.model.visitor.example1
{
	
	/**
	 * 具体元素角色
	 * */
	public class Chrysanthemum implements IFlower
	{
		public function Chrysanthemum()
		{
			
		}
		
		public function accept($v:IVisitor):void
		{ 
			$v.visit3(this);
		}
		
	}
}
package com.chunbai.model.visitor.example1
{
	
	/**
	 * 具体元素角色
	 * */
	public class Gladiolus implements IFlower
	{
		public function Gladiolus()
		{
			
		}
		
		public function accept($v:IVisitor):void
		{ 
			$v.visit1(this);
		}
		
	}
}
package com.chunbai.model.visitor.example1
{
	
	/**
	 * 另一个具体访问者角色
	 * */
	public class Bee implements IVisitor
	{
		public function Bee()
		{
			
		}
		
		public function visit($g:Gladiolus):void
		{ 
			trace("Bee and Gladiolus"); 
		} 
		
		public function visit($r:Runuculus):void
		{ 
		　　trace("Bee and Runuculus"); 
		} 
		
		public function visit($c:Chrysanthemum):void
		{ 
		　　trace("Bee and Chrysanthemum"); 
		} 
		
	}
}
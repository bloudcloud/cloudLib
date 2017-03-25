package com.chunbai.model.visitor.example1
{
	
	/**
	 * 实现的具体访问者角色
	 * */
	public class StringVal implements IVisitor
	{
		private var _str:String;
		
		public function StringVal()
		{
			
		}
		
		public function toString():String
		{ 
			return _str; 
		}
		
		public function visit1($g:Gladiolus):void
		{ 
		　　_str = "Gladiolus"; 
		} 
		
		public function visit2($r:Runuculus):void
		{
		　　_str = "Runuculus"; 
		} 
		
		public function visit3($c:Chrysanthemum):void
		{ 
		　　_str = "Chrysanthemum"; 
		} 
				
	}
}
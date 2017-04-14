package com.chunbai.model.builder.example1
{
	public class BuilderManager
	{
		public function BuilderManager()
		{
		    
		}
		
		public function makeFood(food:IBuilderFood):IBuilderFood
		{
			food.make1();
			food.make2();
			food.make3();
			return food;
		}
		
	}
}
package com.chunbai.model.builder.example1
{
	public class BuilderGoodFood implements IBuilderFood
	{
		public function BuilderGoodFood()
		{
		    
		}
		
		public function make1():void
		{
			trace("goodfood:make1.........");
		}
		
		public function make2():void
		{
			trace("goodfood:make2.........");
		}
		
		public function make3():void
		{
			trace("goodfood:make3.........");
		}
		
		public function showFood():String
		{
			return "goodfood have xxx xxx xxx";
		}
		
	}
}
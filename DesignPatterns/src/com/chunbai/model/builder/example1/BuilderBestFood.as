package com.chunbai.model.builder.example1
{
	public class BuilderBestFood implements IBuilderFood
	{
		public function BuilderBestFood()
		{
			
		}
		
		public function make1():void
		{
			trace("bestfood:make1.........");
		}
		
		public function make2():void
		{
			trace("bestfood:make2.........");
		}
		
		public function make3():void
		{
			trace("bestfood:make3.........");
		}
		
		public function showFood():String
		{
			return "bestfood have xxx xxx xxx";
		}
		
	}
}
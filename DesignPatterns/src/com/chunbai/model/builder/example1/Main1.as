package com.chunbai.model.builder.example1
{
	import flash.display.Sprite;
	
	public class Main1 extends Sprite
	{
		public function Main1()
		{
			var builder:Builder = Builder.instance();
			var food:IBuilderFood = builder.getFood("good");
			trace(food.showFood());
		}
		
	}
}
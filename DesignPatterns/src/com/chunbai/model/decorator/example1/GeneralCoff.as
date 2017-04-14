package com.chunbai.model.decorator.example1
{
	
	public class GeneralCoff extends Coff
	{
		public function BlackCoff()
		{
			description = "GeneralCoff";
		}
		
		override public function cost():int
		{
			return 5;
		}
		
	}
}
package com.chunbai.model.decorator.example1
{
	
	public class BlackCoff extends Coff
	{
		public function BlackCoff()
		{
			description = "BlackCoff";
		}
		
		override public function cost():int
		{
			return 8;
		}
		
	}
}
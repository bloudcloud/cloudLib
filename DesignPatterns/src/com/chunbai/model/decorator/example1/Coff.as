package com.chunbai.model.decorator.example1
{
	
	import flash.display.MovieClip;
	
	public class Coff extends MovieClip
	{
		public var description:String = "Unknown coff";
		
		public function Coff()
		{
		    
		}
		
		public function getDescription():String
		{
			return description;
		}
		
		public function cost():int
		{
			return 0;
		}
		
	}
}
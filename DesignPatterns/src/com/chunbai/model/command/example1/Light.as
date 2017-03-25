package com.chunbai.model.command.example1
{
	
	public class Light
	{
		private var lightName:String;
		
		public function Light()
		{
			lightName = "Light";
		}
		
		public function off():void
		{
			trace(lightName + " off");
		}
		
		public function open():void
		{
			trace(lightName + " open");
		}
		
		public function unDo():void
		{
		
		}
		
	}
}
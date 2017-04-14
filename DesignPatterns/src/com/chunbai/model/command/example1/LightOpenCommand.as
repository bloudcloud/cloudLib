package com.chunbai.model.command.example1
{
	
	public class LightOpenCommand implements ICommand
	{
		private var light:Light;
		
		public function LightOpenCommand(_light:Light)
		{
			light=_light;
		}
		
		public function doAction():void
		{
			light.open();
		}
		
		public function unDo():void
		{
			light.off();
		}
		
	}
}
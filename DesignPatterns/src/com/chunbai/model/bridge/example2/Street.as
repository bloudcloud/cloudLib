package com.chunbai.model.bridge.example2
{
	
	/**
	 * 街道
	 * */
	public class Street extends AbstractRoad
	{
		public function Street()
		{
			
		}
		
		override public function run():void
		{
			car.run();
			trace("市区街道上行驶");
		}
		
	}
}
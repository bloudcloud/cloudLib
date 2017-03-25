package com.chunbai.model.bridge.example2
{
	
	/**
	 * 女人类
	 * */
	public class WoMan extends People
	{
		public function WoMan()
		{
			
		}
		
		override public function run():void
		{
			trace("女人开着");
			road.run();
		}
		
	}
}
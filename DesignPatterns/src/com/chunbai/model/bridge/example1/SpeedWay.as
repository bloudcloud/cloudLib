package com.chunbai.model.bridge.example1
{
	
	/**
	 * 告高速公路
	 * */
	public class SpeedWay extends AbstractRoad
	{
		override public function run():void
		{
		    car.run();
		    trace("高速公路上行驶");
		}
		
	}
}
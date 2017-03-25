package com.chunbai.model.bridge.example1
{
	public class Main1
	{
		public function Main1()
		{
			//小汽车在高速公路上行驶
			var speedWay:AbstractRoad = new SpeedWay();
			speedWay.car = new Car();
			speedWay.run();
			
			trace("=========================");
			
			//公共汽车在高速公路上行驶
			var speedWay2:AbstractRoad = new SpeedWay();
			speedWay2.car = new Bus();
			speedWay2.run();
		}
		
	}
}
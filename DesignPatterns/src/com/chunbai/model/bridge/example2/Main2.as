package com.chunbai.model.bridge.example2
{
	public class Main2
	{
		public function Main2()
		{
			//男人开着公共汽车在高速公路上行驶;
			trace("=========================");
			
			var road:AbstractRoad = new SpeedWay();
			road.car = new Bus();
			
			var people:People = new Man();
			people.road = road;
			people.run();
		}
		
	}
}
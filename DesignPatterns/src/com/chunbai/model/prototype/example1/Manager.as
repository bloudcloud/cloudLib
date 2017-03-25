package com.chunbai.model.prototype.example1
{
	public class Manager
	{
		public var car:Object;
		public var driver:Object;
		public var road:Object;
		
		public function Manager()
		{
			
		}
		
		public function run($car:AbstractCar, $driver:AbstractDriver, $road:AbstractRoad):void
		{
			car = $car.clone();
			driver = $driver.clone();
			road = $road.clone();
		}
		
	}
}
package com.chunbai.model.prototype.example1
{
	public class Main1
	{
		public function Main1()
		{
			var manager:Manager = new Manager();
			manager.run(new VolvoCar(), new Women("Anli", 18), new Bituminous("Road1", 1000));
			//trace("CarRun:" + manager.car.run());
			trace("DriverName: " + manager.driver.name);
			trace("DriverSex: " + manager.driver.sex);
			trace("RoadName: " + manager.road.roadName);
			trace("RoadType: " + manager.road.type);
			//trace("CarStop:" + manager.car.stop());
		}
		
	}
}
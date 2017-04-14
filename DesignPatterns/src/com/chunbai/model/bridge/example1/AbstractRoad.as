package com.chunbai.model.bridge.example1
{
	
	/**
	 * 抽象路
	 * */
	public class AbstractRoad
	{
		private var _car:AbstractCar;
		
		public function set car($car:AbstractCar):void
		{
			_car = $car;
		}
		
		public function get car():AbstractCar
		{
		    return _car;
		}
		
		public function  run():void
		{
			
	    }
		
	}
}
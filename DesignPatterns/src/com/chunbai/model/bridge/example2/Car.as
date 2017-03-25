package com.chunbai.model.bridge.example2
{
	
	/**
	 * 小汽车
	 * */
	public class Car extends AbstractCar
	{
		public function Car()
		{
			
		}
		
		override public function run():void
		{
			trace("小汽车在");
		}
		
	}
}
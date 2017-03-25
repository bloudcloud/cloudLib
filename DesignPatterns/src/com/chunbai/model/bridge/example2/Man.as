package com.chunbai.model.bridge.example2
{
	
	/**
	 * 男人类
	 * */
	public class Man extends People
	{
		public function Man()
		{
			
		}
		
		override public function run():void
		{
			trace("男人开着");
			road.run();
		}
		
	}
}
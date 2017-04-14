package com.chunbai.model.bridge.example2
{
	
	/**
	 * 人抽象类
	 * */
	public class People
	{
		private var _road:AbstractRoad;
		
		public function get road():AbstractRoad
		{
			return _road;
		}
		
		public function set road($road:AbstractRoad):void
		{
			_road = $road;
		}
		
		public function run():void
		{
		    
		}
		 
	}
}
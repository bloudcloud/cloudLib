package com.chunbai.model.singleton.example3
{
	public class Singleton3
	{
		private static var singleton:Singleton3;
		
		public function Singleton3(caller:Function=null)
		{
			if(caller != hidden)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
			if(Singleton3.singleton != null)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		
		public static function getInstance():Singleton3
		{
			if(singleton == null)
			{
				singleton = new Singleton3(hidden);
			}
			return singleton;
		}
		
		private static function hidden():void
		{
			
		}
		
	}
}

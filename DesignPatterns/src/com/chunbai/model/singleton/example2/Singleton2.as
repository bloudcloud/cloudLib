package com.chunbai.model.singleton.example2
{
	public class Singleton2
	{
		private static var _singleton:Boolean = true;
		private static var _instance:Singleton2;
		
		public function Singleton2()
		{
			if(_singleton)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		
		public static function getInstance():Singleton2
		{
			if(_instance == null)
			{
				_singleton = false;
				_instance = new Singleton2();
				_singleton = true;
			}
			return _instance;
		}
		
	}
}

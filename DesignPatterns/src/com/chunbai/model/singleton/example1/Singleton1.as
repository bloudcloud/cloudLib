package com.chunbai.model.singleton.example1
{
	public class Singleton1
	{
		private static  var _instance:Singleton1 = new Singleton1();
		
		public function Singleton1()
		{
			if(_instance)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		
		public static function getInstance():Singleton1
		{
			return _instance;
		}
		
	}
}

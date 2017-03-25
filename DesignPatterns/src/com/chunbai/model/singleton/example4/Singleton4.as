package com.chunbai.model.singleton.example4
{
	public class Singleton4
	{
		private static  var _instance:Singleton4;
		
		public function Singleton4($singletoner:Singletoner)
		{
			if($singletoner == null)
			{
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		
		public static function getInstance():Singleton4
		{
			if(_instance == null)
			{
				_instance = new Singleton4(new Singletoner());
			}
			return _instance;
		}
	}
}

internal class Singletoner
{
	
}

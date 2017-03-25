package com.chunbai.model.singleton.example5
{
	public class Singleton5
	{
		private static  var _singleton:Singleton5 = null;
		
		public function Singleton5()
		{
			if(_singleton == null)
			{
				trace ("ok");
			}
			else
			{
				throw new Error("do not function");
			}
		}
		
		public static  function getInstance():Singleton5
		{
			if(_singleton == null)
			{
				_singleton = new Singleton5();
			}
			return _singleton;
		}
		
		public function doSomething():void
		{
			trace ("dosomething");
		}
		
	}
}

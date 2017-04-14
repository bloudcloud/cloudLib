package com.chunbai.model.flyweight.example1
{
	public class User
	{
		private var _name:String;
		
		public function User($name:String)
		{
			_name = $name;
		}
		
		public function get name():String
		{
			return _name;
		}
		
	}
}
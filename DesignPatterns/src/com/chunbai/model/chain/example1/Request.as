package com.chunbai.model.chain.example1
{
	
	/**
	 * 用户的请求类
	 * */
	public class Request
	{
		private var _str:String;
		
		public function Request()
		{
			
		}
		
		public function get requestStr():String
		{
		    return _str;
		}
		
		public function set requestStr($str:String):void
		{
		    _str = $str;
		}
		
	}
}
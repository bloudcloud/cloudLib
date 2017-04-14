package com.chunbai.model.chain.example1
{
	
	/**
	 * 用户的接受类
	 * */
	public class Response
	{
		private var _str:String;  
		
		public function Response()
		{
			
		}
		
		public function get responseStr():String
		{
		    return _str;
		}
		
		public function set responseStr($str:String):void
		{
			_str = $str;
		}
		
	}
}
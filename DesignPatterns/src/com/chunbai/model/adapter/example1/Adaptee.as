package com.chunbai.model.adapter.example1
{
	
	/**
	 * 被适配者
	 * */
	public class Adaptee
	{
		public function requestA():void
		{
			trace("Adaptee:requestA()");
		}
		
		public function requestB():void
		{
			trace("Adaptee:requestB()");
		}
		
		public function requestC():void
		{
			trace("Adaptee:requestC()");
		}
		
	}
}
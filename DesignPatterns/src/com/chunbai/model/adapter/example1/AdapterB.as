package com.chunbai.model.adapter.example1
{
	
	/**
	 * 适配器
	 * */
	public class AdapterB extends Adaptee implements ITarget
	{
		private var adaptee:Adaptee;
		
		public function AdapterB()
		{
			adaptee = new Adaptee();
		}
		
		public function renamedRequestA():void
		{
			adaptee.requestA()
		}
		
		public function requestA():void
		{
			trace("AdapterB:requestA()");
		}
		
		public function requestB():void
		{
			trace("AdapterB:requestB()");
		}
		
		public function requestC():void
		{
			adaptee.requestC();
		}
		
		public function requestD():void
		{
			trace("AdapterB:requestD()");
		}
		
	}
}
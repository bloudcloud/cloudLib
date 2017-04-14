package com.chunbai.model.adapter.example1
{
	/**
	 * 适配器
	 * */
	public class AdapterA extends Adaptee implements ITarget
	{
		public function renamedRequestA():void
		{
			this.requestA();
		}
		
		override public function requestB():void
		{
			trace("AdapterA:requestB()");
		}
		
		public function requestD():void
		{
			trace("AdapterA:requestD()");
		}
		
	}
}  
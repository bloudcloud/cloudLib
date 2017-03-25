package com.chunbai.model.strategy.example2
{
	
	/**
	 * 木头鸭子
	 * */
	public class Duck_Mutou extends Duck
	{	
	    public function Duck_Mutou()
		{
			super();
			//木头鸭子什么都不会
			flyBehavior = new Fly_NoWay();
			quackBehavior = new Quack_No();
		}
		
		public override function descript():void
		{
		    trace("我是一只木头鸭子");
		}
		
	}
}
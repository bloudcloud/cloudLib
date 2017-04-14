package com.chunbai.model.strategy.example2
{
	
	/**
	 * 野鸭
	 * */
	public class Duck_Yeya extends Duck
	{
	    public function Duck_Yeya()
		{
		    super();
			//这只鸭子用翅膀飞
			flyBehavior = new Fly_WithWings();
			//嘎嘎叫
			quackBehavior = new Quack_Gaga();
		}
		
		override public function descript():void
		{
			trace("我是一只野鸭子");
	    }
		
	}
}
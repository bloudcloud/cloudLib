package com.chunbai.model.strategy.example2
{
	
	/**
	 * 橡胶鸭子
	 * */
    public class Duck_Xiangjiao extends Duck
	{
	    public function Duck_Xiangjiao()
		{
		    super();
			//橡胶鸭子不会飞
			flyBehavior = new Fly_NoWay();
			//橡胶鸭子捏起来会呱呱叫
			quackBehavior = new Quack_Guagua();
		}
		
		public override function descript():void
		{
		    trace("我是一只橡胶鸭子");
		}
		
	}
}
package com.chunbai.model.strategy.example2
{
	
	public class Main2
	{
		public function Main2()
		{
			trace("来了一只木头鸭子！");
			var mutouyazi1:Duck_Mutou = new Duck_Mutou();
			mutouyazi1.fly();
			mutouyazi1.quack();
			mutouyazi1.setFlyBehavior(new Fly_Rocket());
			mutouyazi1.fly();
			trace("来了一只橡胶鸭子！");
			var xiangjiaoyazi2 : Duck_Xiangjiao = new Duck_Xiangjiao();
			xiangjiaoyazi2.fly();
			xiangjiaoyazi2.quack();
			trace("来了一只真正的野鸭子！");
			var yeyazi3 : Duck_Yeya = new Duck_Yeya();
			yeyazi3.fly();
			yeyazi3.quack();
		}
		
	}
}
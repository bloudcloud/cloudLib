package com.chunbai.model.strategy.example2
{
	
	/**
	 * 鸭子的基类
	 * */
	public class Duck
	{
	    /*鸭子的飞行行为将委托flyBehavior来执行，所以flyBehavior在每个子类中必须指明，如果不指明则不执行任何动作，
		 当然利用setBehavior()方法也可以动态的为所有的鸭子子类设定这些行为
		*/
		protected var flyBehavior:IFlyBehavior;
		protected var quackBehavior:IQuackBehavior;
		
		public function Duck():void
		{			
		    
		}
		
		public function descript():void
		{
		    
		}
		
		public function fly():void
		{
		    flyBehavior.fly();
		}
		
		public function quack():void
		{
		    quackBehavior.quick();
		}
		
		public function setFlyBehavior(b:IFlyBehavior):void
		{
		    flyBehavior = b;
		}
		
		public function setQuackBehavior(b : IQuackBehavior):void
		{
		    quackBehavior = b;
		}
		
	}
}
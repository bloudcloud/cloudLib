package com.chunbai.model.abstractFactory.example1
{
	public class Main1
	{
		public function Main1()
		{
			var factoryA:AbstractFactory = new FactoryA();
			factoryA.createProduct().doTask();
			
			var factoryB:AbstractFactory = new FactoryB();
			factoryB.createProduct().doTask();
		}
		
	}
}
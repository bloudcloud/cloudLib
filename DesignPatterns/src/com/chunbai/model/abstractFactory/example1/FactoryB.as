package com.chunbai.model.abstractFactory.example1
{
	/**
	 * 具体工厂B
	 * */
	public class FactoryB extends AbstractFactory
	{
		public function FactoryB()
		{
			
		}
		
		override public function createProduct():IProduct
		{
		    return new ProductB();
		}
		
	}
}
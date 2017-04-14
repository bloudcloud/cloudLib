package com.chunbai.model.abstractFactory.example1
{
	/**
	 * 具体工厂A
	 * */
	public class FactoryA extends AbstractFactory
	{
		public function FactoryA()
		{
			
		}
		
		override public function createProduct():IProduct
		{
		    return new ProductA();
		}
		
	}
}
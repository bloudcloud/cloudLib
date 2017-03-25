package com.chunbai.model.abstractFactory.example1
{
	/**
	 * 具体产品B
	 * */
	public class ProductB implements IProduct
	{
		public function ProductB()
		{
			
		}
		
		public function doTask():void
		{
		    trace("产品B生产成功！");
		}
		
	}
}
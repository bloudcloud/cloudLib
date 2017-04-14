package com.chunbai.model.abstractFactory.example1
{
	/**
	 * 具体产品A
	 * */
	public class ProductA implements IProduct
	{
		public function ProductA()
		{
			
		}
		
		public function doTask():void
		{
		    trace("产品A生产成功！");
		}
		
	}
}
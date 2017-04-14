package com.chunbai.model.abstractFactory.example2
{
	/**
	 * 反射工厂类
	 * */
	public class ReflectFactory
	{
		private var _product:IProduct;
		
		public function ReflectFactory()
		{
			
		}
		
		public function setProduct($product:IProduct):void
		{
		    this._product = $product;
		}
		
		public function createProduct():IProduct
		{
		    return this._product;
		}
		
	}
}
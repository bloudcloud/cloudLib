package com.chunbai.model.proxy.example1
{
	/**
	 * 虚拟代理的作用就是来为具体的存取数据实体类(Product类)服务
	 * */
	public class ProductProxy implements IProduct
	{
		private var _data:XML;
		private var _product:Product;
		
		public function ProductProxy($data:XML)
		{
			_data = $data;
			_product = new Product();
		}
		
		public function getPrice():Number
		{
		    if(isNaN(_product.getPrice()))
			{
			    _product.setPrice(Number(_data.price.toString()));
			}
			return _product.getPrice();
		}
		
		public function getTitle():String
		{
		    if(_product.getTitle() == null)
			{
			    _product.setTitle(_data.title.toString());
			}
			return _product.getTitle();
		}
		
		public function setPrice($price:Number):void
		{
		    _data.price = $price;
			_product.setPrice($price);
		}
		
		public function setTitle($title:String):void
		{
		    _data.title = $title;
			_product.setTitle($title);
		}
		
	}
}
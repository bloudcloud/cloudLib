package com.chunbai.model.proxy.example1
{
	public class Main1
	{
		public function Main1()
		{
			virtualProxyFunc();
		}
		
		/**
		 * 虚拟代理
		 * */
		private function virtualProxyFunc():void
		{
			var data:XML = <product>
				            <title>HELLO WORLD</title>
				            <price>250</price>
				          </product>;
			var productProxy:IProduct = new ProductProxy(data);
			trace(productProxy.getTitle(), productProxy.getPrice());
		}
		
		
	}
}
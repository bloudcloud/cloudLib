package com.chunbai.model.flyweight.example1
{
	
	/**
	 * 工厂类
	 * */
	public class WebSiteFactory
	{
		private var flyweights:Object = new Object();
		
		/**
		 * 获得网站分类
		 * */
		public function getWebSiteCategory($key:String):IWebSite
		{
			if(flyweights[$key] == undefined)
				flyweights[$key] = new ConcreteWebSite($key);
			return flyweights[$key];
		}
		
	}
}
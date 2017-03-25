package com.chunbai.model.flyweight.example1
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main1 extends Sprite
	{
		
		public function Main1():void
		{
			initApp();
		}
		
		private function initApp():void
		{
			var factory:WebSiteFactory = new WebSiteFactory();
			
			var fx:IWebSite = factory.getWebSiteCategory("产品展示");
			fx.useing(new User("小菜"));
			
			var fy:IWebSite = factory.getWebSiteCategory("产品展示");
			fy.useing(new User("大鸟"));
			
			var fz:IWebSite = factory.getWebSiteCategory("产品展示");
			fz.useing(new User("娇娇"));
			
			var fl:IWebSite = factory.getWebSiteCategory("博客");
			fl.useing(new User("老顽童"));
			
			var fm:IWebSite = factory.getWebSiteCategory("博客");
			fm.useing(new User("桃谷六仙"));
			
			var fn:IWebSite = factory.getWebSiteCategory("博客");
			fn.useing(new User("南海鳄神"));
		}
		
	}
}
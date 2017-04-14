package com.chunbai.model.flyweight.example1
{
	
	/**
	 * 具体类
	 * */
	public class ConcreteWebSite implements IWebSite
	{
		private var _name:String = "";
		
		public function ConcreteWebSite($name:String)
		{
			_name = $name;
		}
		
		/**
		 * @override
		 * */
		public function useing(user:User):void
		{
			//实现useing方法
			trace("网站分类：" + _name + " 用户：" + user.name);
		}
		
	}
}
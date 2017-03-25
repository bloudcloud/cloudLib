package com.chunbai.model.mediator.example1
{
	public class Man
	{
		private var _mediator:Mediator;
		
		public function Man($mediator:Mediator)
		{
			_mediator = $mediator;
			$mediator.registeMan(this);    //把男人註冊到中介者中去
		}
		
		/**
		 * 男人向中介者提出約會的要求
		 * */
		public function tryst($says:String):void
		{
			trace("男人提出要求:" + $says);
			_mediator.doManTryst($says);
		}
		
		/**
		 * 中介者處理男人的想法
		 * */
		public function thingHandler($says:String):Boolean
		{
			trace("男人想:我要不要這樣做呢?");
			if($says.length > 5)
			{
				trace("好吧!我就這樣做吧!");
				return true;
			}
			else
			{
				trace("還是算了吧!下次了再約!");
				return false;
			}
		}
		
	}
}
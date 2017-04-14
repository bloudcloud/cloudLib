package com.chunbai.model.mediator.example1
{
	
	/**
	 * 中介者类
	 * */
	public class Mediator
	{
		private var _man:Man;
		private var _woman:Woman;
		private var _manBoolean:Boolean;
		private var _womanBoolean:Boolean;
		
		public function Mediator()
		{
			
		}
		
		public function registeWoman($woman:Woman):void
		{
			_woman = $woman;
		}
		
		public function registeMan($man:Man):void
		{
			_man = $man;
		}
		
		public function doManTryst($says:String):Boolean
		{
			trace("中介開始處理男人提出的要求");
			_manBoolean = _man.thingHandler($says);
			if(_manBoolean)
			{
				return true;
			}
			else
			{
			    return false;
			}
		}
		
		public function doWomanTryst($says:String):Boolean
		{
			trace("中介開始處理女人提出的要求");
			_womanBoolean = _woman.thingHandler($says);
			if(_womanBoolean)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function doResult():void
		{
			if(_manBoolean && _womanBoolean)
			{
				trace("約會成功");
			}
			else
			{
				trace("約會失敗");
			}
		}
		
	}
}
package com.chunbai.model.mediator.example1
{
	import flash.display.MovieClip;
	
	public class Main1 extends MovieClip
	{
		private var _man:Man;
		private var _woman:Woman;
		private var _mediator:Mediator;
		
		public function Main1()
		{
			_mediator = new Mediator();
			_man = new Man(_mediator);
			_woman = new Woman(_mediator);
			_man.tryst("我想和你約會");    //男人開始提要求
			_woman.tryst("我同意和你會");    //女人的回復
			//woman.tryst("不同意");
			_mediator.doResult();    //不管男人還是女人只要提出的要求少於5個字符約會都將失敗
		}
		
	}
}
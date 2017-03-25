package com.chunbai.model.observer
{
	import com.chunbai.model.observer.example1.Main1;
	import com.chunbai.model.observer.example2.Main2;
	import com.chunbai.model.observer.example3.Main3;
	
	import flash.display.Sprite;
	
	/**
	 * 观察者模式总测试类
	 * */
	public class ObserverTest extends Sprite
	{
		public function ObserverTest()
		{
			//var main1:Main1 = new Main1();
			
			//var main2:Main2 = new Main2();
			
			var main3:Main3 = new Main3();
			this.addChild(main3);
		}
		
	}
}
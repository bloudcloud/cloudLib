package com.chunbai.model.composite
{
	import com.chunbai.model.composite.example1.Main1;
	
	import flash.display.Sprite;
	
	/**
	 * 组合模式总测试类
	 * */
	public class CompositeTest extends Sprite
	{
		public function CompositeTest()
		{
			var main1:Main1 = new Main1();
			this.addChild(main1);
		}
		
	}
}
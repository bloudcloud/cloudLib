package com.chunbai.model.templateMethod
{
	import com.chunbai.model.templateMethod.example1.Main1;
	import com.chunbai.model.templateMethod.example2.FactoryGame;
	
	/**
	 * 模板方法模式总测试类
	 * */
	public class TemplateMethodTest
	{
		public function TemplateMethodTest()
		{
			var main1:Main1 = new Main1();
			var main2:FactoryGame = new FactoryGame();
		}
		
	}
}
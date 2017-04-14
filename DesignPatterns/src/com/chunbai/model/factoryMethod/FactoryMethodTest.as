package com.chunbai.model.factoryMethod
{
	import com.chunbai.model.factoryMethod.example1.FootballGame;
	
	/**
	 * 工厂方法模式总测试类
	 * */
	public class FactoryMethodTest
	{
		public function FactoryMethodTest()
		{
			footballFunc();
		}
		
		private function footballFunc():void
		{
			var game:FootballGame = new FootballGame();    //Create an instance of FootballGame
			game.initialize();    //Call the template method defined in AbstractGame
		}
		
	}
}
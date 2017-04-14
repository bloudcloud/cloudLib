package com.chunbai.model.templateMethod.example2
{
	public class FactoryGame
	{
		public function FactoryGame()
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
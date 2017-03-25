package com.chunbai.model.templateMethod.example2
{
	/**
	 * 抽象类
	 * */
	public class AbstractGame
	{
		/**
		 * Template Method
		 * */
		public final function initialize():void
		{
		    createField();
			createTeam("red");
			createTeam("blue");
			startGame();
		}
		
		public function createField():void
		{
		    throw new Error("Abstract Method!");
		}
		
		public function createTeam($name:String):void
		{
			throw new Error("Abstract Method!");
		}
		
		public function startGame():void
		{
			throw new Error("Abstract Method!");
		}
		
	}
}
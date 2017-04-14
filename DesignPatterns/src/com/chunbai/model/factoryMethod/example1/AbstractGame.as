package com.chunbai.model.factoryMethod.example1
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
		    var field:IField = createField();
			field.drawField();
			createTeam("red");
			createTeam("blue");
			startGame();
		}
		
		/**
		 * 创建场地
		 * */
		public function createField():IField
		{
		    throw new Error("Abstract Method!");
		}
		
		/**
		 * 创建队伍
		 * */
		public function createTeam($name:String):void
		{
		    throw new Error("Abstract Method!");
		}
		
		/**
		 * 开始比赛
		 * */
		public function startGame():void
		{
		    throw new Error("Abstract Method!");
		}
		
	}
}
package com.chunbai.model.factoryMethod.example1
{
	public class FootballGame extends AbstractGame
	{
		/**
		 * 创建场地
		 * */
		override public function createField():IField
		{
		    return new FootballField();
		}
		
		/**
		 *  创建队伍
		 * */
		override public function createTeam($name:String):void
		{
		    trace("Create Football Team Named " + $name);
		}
		
		/**
		 * 开始比赛
		 * */
		override public function startGame():void
		{
		    trace("Start Football Game");
		}
		
	}
}
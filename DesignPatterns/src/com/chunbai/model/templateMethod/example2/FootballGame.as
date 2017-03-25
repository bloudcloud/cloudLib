package com.chunbai.model.templateMethod.example2
{
	public class FootballGame extends AbstractGame
	{
		override public function createField():void
		{
		    trace("Create Football Field");
		}
		
		override public function createTeam($name:String):void
		{
		    trace("Create Football Team Named " + $name);
		}
		
		override public function startGame():void
		{
		    trace("Start Football Game");
		}
		
	}
}
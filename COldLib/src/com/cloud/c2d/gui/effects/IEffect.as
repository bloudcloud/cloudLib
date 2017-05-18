package com.cloud.c2d.gui.effects
{
	public interface IEffect
	{
		function active(target:Object):void;
		function deactive():void;
	}
}
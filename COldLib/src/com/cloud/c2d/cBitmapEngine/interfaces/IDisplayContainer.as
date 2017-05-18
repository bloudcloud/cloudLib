package com.cloud.c2d.cBitmapEngine.interfaces
{
	public interface IDisplayContainer
	{
		function addChild(target:IDisplay):void;
		function addChildAt(target:IDisplay, index:int):void;
		function removeChlid(target:IDisplay):void;
		function removeChildAt(index:int):IDisplay;
	}
}
package com.chunbai.model.proxy.example1
{
	public interface IProduct
	{
		function getPrice():Number;
		function getTitle():String;
		function setPrice($price:Number):void;
		function setTitle($title:String):void;
	}
}
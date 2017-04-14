package com.chunbai.model.command.example1
{
	public interface ICommand
	{
		function doAction():void;    //调用接受者的动作来满足请求
		function unDo():void;
		
	}
}
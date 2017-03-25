package com.chunbai.model.command.example1
{
	
	public class RemoteControl
	{
		private var onCommandArray:Array;    //记录所有的打开命令队列
		private var offCommandArray:Array;    //记录所有的关闭命令队列
		private var undoCommand:ICommand;
		private var undoArray:Array;
		
		public function RemoteControl()
		{
			onCommandArray = new Array(7);    //共有七种打开命令
			offCommandArray = new Array(7);    //共有七种关闭命令
			var noCommand:NoCommand = new NoCommand();
			//初始化命令队列全为空
			for(var i:int = 0; i < onCommandArray.length; i++)
			{
				onCommandArray[i] = (noCommand);
				offCommandArray[i] = (noCommand);
			}
			undoCommand = noCommand;
			undoArray = new Array();
			undoArray.push(undoCommand);
		}
		
		public function setCommand(slot:int,onCommand:ICommand, offCommand:ICommand):void
		{
			onCommandArray[slot] = onCommand;
			offCommandArray[slot] = offCommand;
		}
		
		public function onButtonWasPushed(slot:int):void
		{
			getInfo(onCommandArray[slot]);
			onCommandArray[slot].doAction();
			undoCommand = onCommandArray[slot];
			undoArray.push(undoCommand);
		}
		
		public function offButtonWasPushed(slot:int):void
		{
			getInfo(offCommandArray[slot]);
			offCommandArray[slot].doAction();
			undoCommand = offCommandArray[slot];
			undoArray.push(undoCommand);
		}
		
		public function undoButtonWasPushed():void
		{
			if(undoArray.length != 0)
			{
				undoCommand = undoArray.pop();
			}
			else
			{
				undoCommand = new NoCommand();
			}
			trace(undoCommand + " 执行undo命令");
			undoCommand.unDo();
		}
		
		public function getInfo(_command:ICommand):void
		{
			trace(_command + "执行命令");
		}
		
	}
}
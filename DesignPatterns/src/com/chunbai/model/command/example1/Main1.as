package com.chunbai.model.command.example1
{
	import flash.display.Sprite;
	
	public class Main1
	{
		public function Main1()
		{
			var light:Light = new Light();    //create light;
			var offLight:LightOffCommand = new LightOffCommand(light);    //create LightOffCommand
			var openLight:LightOpenCommand = new LightOpenCommand(light);
			var control:RemoteControl = new RemoteControl();    //create remoteControl,and set the command
			
			control.setCommand(1, openLight, offLight);    //给1号设置打开和关闭的命令，为关灯命令
			//按下一号关闭按钮,1号按钮是关灯命令，所以遥控会调用light的off方法
			control.offButtonWasPushed(1);    //light off
			control.onButtonWasPushed(1);    //light open                        
			control.undoButtonWasPushed();    //返回上一步
			control.undoButtonWasPushed();    //再返回上步
			control.offButtonWasPushed(2);    //noCommand,doNothing
		}
	}
}
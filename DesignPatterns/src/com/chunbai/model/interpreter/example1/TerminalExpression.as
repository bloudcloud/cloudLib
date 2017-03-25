package com.chunbai.model.interpreter.example1
{
	public class TerminalExpression extends AbstractExpression
	{
		public function TerminalExpression():void
		{
			
		}
		
		public override function interpret(context:Context):void
		{
			trace("终端解释器");
		}
		
	}
}
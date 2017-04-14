package com.chunbai.model.interpreter.example1
{
	
	public class NonterminalExpression extends AbstractExpression
	{
		public function NonterminalExpression():void
		{
			
		}
		
		public override function interpret(context:Context):void
		{
			trace("非终端解释器");
		}
		
	}
}
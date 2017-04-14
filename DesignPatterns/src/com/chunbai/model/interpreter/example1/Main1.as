package com.chunbai.model.interpreter.example1
{
	
	public class Main1
	{	
		private var _context:Context;
		public var _array:Array;
		
		public function Main1():void
		{
			_array = new Array();
			_context = new Context();
			_array.push(new TerminalExpression());
			_array.push(new NonterminalExpression());
			_array.push(new TerminalExpression());
			_array.push(new TerminalExpression());
			_array.push(new TerminalExpression());
			for each(var exp:AbstractExpression in _array)
			{
				exp.interpret(_context);
			}
			
		}
		
	}
}
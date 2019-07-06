package utils.l2dMathExpression
{
	import cores.HashMap;

	public class MathExp
	{
		public function MathExp(sym:String="0")
		{
			if(!(sym == null || sym == "" || sym.length==0))
				_symbol = sym;
				
		}
		
		private var _symbol:String = "0";
		
		private var _postfixSymbolStack:Array = null;
		
		private var _currentPos:int = 0;
		private var _totalLen:int = 0;
		private var _currentChar:String = "";
		public function toPostfix():void
		{
			_postfixSymbolStack = new Array();
			_currentPos = 0;
			_totalLen = _symbol.length;
			var node:ExpNode = null;
			var isParseFunction:Boolean = false;
			var isParseSign:Boolean = false;
			var numOfVar:int = 0;
			
			var opStack:LinkedStack = new  LinkedStack();
			var pn:int = 0;
			var opNode:ExpNode = null;
			var qn:int = 0;
			while(_currentPos < _totalLen)
			{
				_currentChar = _symbol.charAt(_currentPos);
				switch(_currentChar)
				{
					case "+":
					case "-":
						//如果_postfixSymbolStack没有操作数，或者opStack为(
						var postNode:ExpNode = null;
						if(_postfixSymbolStack.length > 0)postNode = _postfixSymbolStack[_postfixSymbolStack.length-1];
						if(postNode == null || ((postNode.type != ExpNode.NUMBER && postNode.type != ExpNode.VARIABLE)
							&& (opStack.get()!=null && opStack.get().type == ExpNode.LEFT_BRACKET)))
						{
							node = new ExpNode(ExpNode.OPER_UNARY, _currentChar=="+"?"postive":"neg");
							isParseSign = true; 
						}
						else
						{
							node = new ExpNode(ExpNode.OPER_BINARY, _currentChar);
						}
						pn = getPriority(node);
						opNode= opStack.get();
						
						if(opNode != null && opNode.type != ExpNode.LEFT_BRACKET)
						{
							qn = getPriority(opNode);
							if(pn<=qn)
							{
								opStack.pop();
								while(opNode != null && qn>=pn)
								{
									_postfixSymbolStack.push(opNode);
									opNode = opStack.get();
									if(opNode!=null && opNode.type == ExpNode.LEFT_BRACKET)
										break;
									opStack.pop();
									qn=getPriority(opNode);
								}
								
							}
						}
						opStack.push(node);
						break;
					case "*":
					case "/":
					case "^":
						node = new ExpNode(ExpNode.OPER_BINARY, _currentChar);
						pn = getPriority(node);
						opNode= opStack.get();
						if(opNode != null && opNode.type != ExpNode.LEFT_BRACKET)
						{
							qn = getPriority(opNode);
							if(pn<=qn)
							{
								opStack.pop();
								while(opNode != null && qn>=pn)
								{
									_postfixSymbolStack.push(opNode);
									opNode = opStack.get();
									if(opNode!=null && opNode.type == ExpNode.LEFT_BRACKET)
										break;
									opStack.pop();
									qn=getPriority(opNode);
								}
								
							}
						}
						opStack.push(node);
						break;
					case "(":
						node = new ExpNode(ExpNode.LEFT_BRACKET, _currentChar);
						opStack.push(node);
						break;
					case ")":
						opNode= opStack.pop();
						while(opNode != null && opNode.type != ExpNode.LEFT_BRACKET)
						{
							_postfixSymbolStack.push(opNode);
							opNode = opStack.pop();
						}
						if(isParseFunction)
						{
							if(opNode != null && opNode.type == ExpNode.LEFT_BRACKET)
							{
								opNode = opStack.pop();
								if(opNode != null && (opNode.type == ExpNode.FUNCTION  || opNode.type == ExpNode.OPER_BINARY ||
									opNode.type == ExpNode.OPER_TERNARY || opNode.type == ExpNode.OPER_UNARY)){
									opNode.numOfVar = numOfVar;
									_postfixSymbolStack.push(opNode);
								}
							}
							isParseFunction = false;
						}
						break;
					case ",":break;
					default:
						if(_currentChar>="0" && _currentChar<="9")
						{
							node = parseNumber();
							if(node != null)_postfixSymbolStack.push(node);
							if(isParseFunction){
								++numOfVar;
							}
							if(isParseSign)
							{
								isParseSign = false;
								opNode = opStack.get();
								if(opNode != null && opNode.type == ExpNode.OPER_UNARY)
								{
									_postfixSymbolStack.push(opNode);
									opStack.pop();
								}
							}
						}
						else 
						{
							node = parseFunctionOrVariable();
							if(node != null)
							{
								if(node.type == ExpNode.VARIABLE)
								{
									_postfixSymbolStack.push(node);
									if(isParseFunction){
										++numOfVar;
									}
								}
								else
								{
									opStack.push(node);
									isParseFunction = true;
									numOfVar = 0;
								}
							}
						}
						break;
				}
				
				++_currentPos;
			}
			
			opNode = opStack.pop();
			while(opNode != null)
			{
				_postfixSymbolStack.push(opNode);
				opNode = opStack.pop();
			}
			
			_postfixSymbolStack.reverse();
		}
		
		private function parseNumber():ExpNode
		{
			var strVal:String = _currentChar;
			++_currentPos;
			while(_currentPos < _totalLen)
			{
				_currentChar = _symbol.charAt(_currentPos);
				if((_currentChar>="0" && _currentChar<="9") || 
					_currentChar == ".")
				{
					strVal += _currentChar;
				}
				else
				{
				  break;
				}
				++_currentPos;
			}
			--_currentPos;
			
			return new ExpNode(ExpNode.NUMBER, Number(strVal));
		}
		
		private function parseFunctionOrVariable():ExpNode
		{
			var strVal:String = _currentChar;
			var type:int = 0;
			++_currentPos;
			while(_currentPos < _totalLen)
			{
				_currentChar = _symbol.charAt(_currentPos);
				if(_currentChar == "+" || _currentChar == "-" ||
					_currentChar == "*" || _currentChar == "/" ||
					_currentChar == "^" || _currentChar == ")" ||
					_currentChar == ",")
				{
					type = ExpNode.VARIABLE;
					break;
				}
				else if(_currentChar == "(")
				{
					type = ExpNode.FUNCTION;
					break;
				}
				else
				{
					strVal += _currentChar;
				}
				++_currentPos;
			}
			if(_currentPos >= _totalLen && type != ExpNode.VARIABLE && type != ExpNode.FUNCTION)
			{
				type = ExpNode.VARIABLE;
			}
			--_currentPos;
			
			return new ExpNode(type, strVal);
		}
		
		private function getPriority(op:ExpNode):int
		{
			if(op == null)return -9999;
			if(op.type == ExpNode.OPER_UNARY)
			{
				return 2;
			}
			else if(op.data=="+" || op.data=="-")
			{
				 return 1;
			}
			else if(op.data=="*" || op.data=="/")return 3;
			else if(op.data=="^") return 4;
			else if(op.data=="(")return 5;
			else return -1;
		}
		
		public function getPostfix():String
		{
			var str:String = "";
			if(_postfixSymbolStack != null)
			{
				for(var i:int = 0; i < _postfixSymbolStack.length; ++i)
				{
					var node:ExpNode = _postfixSymbolStack[i] as ExpNode;
					
					if(node.type == ExpNode.NUMBER)
						str += String(node.data) + " ";
					else
						str += String(node.data) + " ";
				}
			}
			return str;
		}
		
		public function toRealNumber(hashMap:HashMap, funcMap:HashMap=null):Number
		{
			var node:ExpNode = null;
			var i:int= _postfixSymbolStack.length-1;
			var args:Array = new Array();
			while(_postfixSymbolStack.length>0)
			{
				node = _postfixSymbolStack[_postfixSymbolStack.length-1] as ExpNode;
				_postfixSymbolStack.length -= 1;
				
				if(node != null)
				{
					if(node.type == ExpNode.NUMBER  )
					{
						var num:Number = Number(node.data);
						if(_postfixSymbolStack.length == 0)
							return num;
						args.push(num);
					}
					else if(node.type == ExpNode.VARIABLE)
					{
						var num2:Number = 0;
						num2 = BasicConstSymbolMap.getInstance().findSymbol(String(node.data));
						if(isNaN(num2))
						{
							num2 = Number(hashMap.getValue(String(node.data)));
						}
						if(_postfixSymbolStack.length == 0)
							return num2;
						args.push(num2);
					}
					else if(node.type == ExpNode.FUNCTION || node.type == ExpNode.OPER_BINARY ||
								node.type == ExpNode.OPER_TERNARY || node.type == ExpNode.OPER_UNARY)
					{
						var numOfVar : int = node.numOfVar;
						var j:int = args.length - numOfVar;
						var newNode:ExpNode = null;
						if(j<0)
						{
							newNode = new ExpNode(ExpNode.NUMBER,0);
						}
						else
						{
							var argArray:Array = new Array();
							for(var k :int  = j; k < args.length; ++k)
							{
								argArray.push(args[k]);
							}
							
							var func:Function = null;
							if(null  != funcMap)
							{
								func = funcMap.getValue(String(node.data)) as Function;
							}
							else
							{
								func = BasicFunctionMap.getInstance().findFunction(String(node.data)) as Function;
							}
							
							if(func != null)
							{
								var num1:Number = func.apply(null, argArray);
								newNode = new ExpNode(ExpNode.NUMBER,num1);
							}
							else{
								newNode = new ExpNode(ExpNode.NUMBER, 0);
							}
							args.splice(j, numOfVar);
						}
						
						_postfixSymbolStack.push(newNode);
					}
				}
			}
			return 0;
		}
	}
}
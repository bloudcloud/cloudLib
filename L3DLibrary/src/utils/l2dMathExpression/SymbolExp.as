package utils.l2dMathExpression
{
	import cores.HashMap;

	/*符号表达式*/
	public class SymbolExp
	{
		public function SymbolExp(sym:String="0")
		{
			symbol = sym;
		}
		
		public var symbol:String = "0";
		
		public function clone():SymbolExp{
			var c:SymbolExp = new SymbolExp();
			c.symbol = symbol;
			return c;
		}
		
		public function toRealNumber(hashMap:HashMap):Number
		{
			if(symbol == "")return 0;
			var mathExp:MathExp = new MathExp(symbol);
			mathExp.toPostfix();
			var val:Number = mathExp.toRealNumber(hashMap);
			return val;
		}
		
		/*序列化*/
		public function serialize():XML{
			var dataXML:XML = new XML();
			
			dataXML = <SymbolExp sym={symbol}></SymbolExp>;
			
			return dataXML;
		}
		
		/*反序列化*/
		public function deserialize(xml:XML):Boolean{
			symbol = String(xml.@sym);
			return true;
		}
	}
}
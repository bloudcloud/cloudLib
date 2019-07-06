package utils.l2dMathExpression
{
	public class ExpNode
	{
		public static const UNDEFINED:int = -1; //未定义
		public static const NUMBER:int = 0;  //数值
		public static const OPER_UNARY:int = 1; //单目运算符
		public static const OPER_BINARY:int = 2; //双目运算符
		public static const OPER_TERNARY:int = 3;//三目运算符
		public static const VARIABLE:int = 4;   //变量
		public static const FUNCTION:int = 5;   //函数
		public static const LEFT_BRACKET:int = 6;//左括号
		public static const RIGHT_BRACKET:int = 7;//右括号
		
		public var data:Object;
		public var next:ExpNode;
		public var type:int = 0;
		
		public var numOfVar:int = 0; //仅对函数和运算符起作用，参数个数
		
		
		public function ExpNode(type:int=ExpNode.UNDEFINED,data:Object=null, next:ExpNode=null)
		{
			this.type = type;
			this.data = data;
			this.next = next;
			if(type == ExpNode.OPER_UNARY)
			{
				numOfVar = 1;
			}
			else if(type == ExpNode.OPER_BINARY)
			{
				numOfVar = 2;
			}
			else if(type == ExpNode.OPER_TERNARY)
			{
				numOfVar = 3;
			}
		}
		
	}
}
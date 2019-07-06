package utils.l2dMathExpression
{
	public class LinkedStack 
	{
		private var top:ExpNode;
		
		public function LinkedStack()
		{
			top = null;
		}
		
		public function isEmpty():Boolean
		{
			return top == null;
		}
		
		public function get():ExpNode
		{
			if(!isEmpty())
			{
				return top;
			}
			return null;
		}
		
		public function clear():void{
			top = null;
		}
		
		public function push(newNode:ExpNode):Boolean
		{
			if(newNode == null)
				return false;
			newNode.next = top;
			top = newNode;
			return true;
		}
		
		public function pop():ExpNode
		{
			if(!isEmpty())
			{
				var temp:ExpNode = top;
				top = top.next;
				return temp;
			}
			return null;
		}
		
	}
}
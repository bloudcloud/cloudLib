package utils.l2dMathExpression
{
	public interface IStack
	{
		function isEmpty():Boolean;
		function get():Object;
		function push(element:Object):Boolean;
		function pop():Object;
	}
}
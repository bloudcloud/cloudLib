package cloud.core.collections
{
	public interface IDoubleList
	{
		function get rootNode():IDoubleNode;
		function set rootNode(value:IDoubleNode):void;
		function get endNode():IDoubleNode;
		function set endNode(value:IDoubleNode):void;
		function get length():uint;
		
		function addBefore(node:IDoubleNode):void;
		function addAfter(node:IDoubleNode):void;
		function remove(nodel:IDoubleNode):void;
		function forEach(callback:Function):void;
	}
}
package cloud.core.collections
{
	public interface IDoubleNode
	{
		function get hasIn():Boolean;
		function set hasIn(value:Boolean):void;
		function get next():IDoubleNode;
		function set next(value:IDoubleNode):void;
		function get prev():IDoubleNode;
		function set prev(value:IDoubleNode):void;
		function get nodeData():*;
		function set nodeData(value:*):void;
		function addAfter(node:IDoubleNode):void;
		function addBefore(node:IDoubleNode):void;
		function unlink():void;
		function toString():String;
	}
}
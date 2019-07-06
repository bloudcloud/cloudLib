package cloud.core.collections
{
	import cloud.core.interfaces.ICNodeData;

	public interface ICDoubleNode
	{
		function get hasIn():Boolean;
		function set hasIn(value:Boolean):void;
		function get next():ICDoubleNode;
		function set next(value:ICDoubleNode):void;
		function get prev():ICDoubleNode;
		function set prev(value:ICDoubleNode):void;
		function get nodeData():ICNodeData;
		function set nodeData(value:ICNodeData):void;
		function get nodeLength():uint;
		function addAfter(node:ICDoubleNode):void;
		function addBefore(node:ICDoubleNode):void;
		function unlink():void;
		function toString():String;
		/**
		 * 遍历链表 
		 * @param callbackFunc	回调函数
		 * @param callbackParams	回调函数的参数
		 * @return Boolean	返回是否发生中断
		 * 
		 */		
		function mapDoubleNode(callbackFunc:Function,...callbackParams):Boolean;
	}
}
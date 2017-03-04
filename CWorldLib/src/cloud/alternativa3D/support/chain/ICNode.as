package cloud.alternativa3D.support.chain
{
	public interface ICNode
	{
		function get prevNode():ICNode;
		function set prevNode(node:ICNode):void;
		function get nextNode():ICNode;
		function set nextNode(node:ICNode):void;
		function get index():int;
		function set index(value:int):void;
	}
}
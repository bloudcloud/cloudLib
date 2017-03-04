package cloud.alternativa3D.support.chain
{
	public interface ICChainTable
	{
		function addChainNode(node:ICNode):void;
		function removeChainNode(node:ICNode):void;
		function getChainNodeByIndex(index:int):ICNode;
		function updatePosition():void;
	}
}
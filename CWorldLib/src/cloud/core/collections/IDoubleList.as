package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	
	public interface IDoubleList
	{
		function get rootNode():IDoubleNode;
		function set rootNode(value:IDoubleNode):void;
		function get endNode():IDoubleNode;
		function set endNode(value:IDoubleNode):void;
		function get length():uint;
		/**
		 * 添加数据
		 * @param nodeData
		 * 
		 */		
		function add(nodeData:ICData):void;
		/**
		 * 移除数据
		 * @param nodeData
		 * 
		 */		
		function remove(nodeData:ICData):void;
		/**
		 * 获取 
		 * @param uniqueID
		 * @return ICData
		 * 
		 */		
		function getDataByID(uniqueID:String):ICData;
		/**
		 * 遍历当前节点，执行回调  
		 * @param nodeData	数据
		 * @param callback	回调
		 * @return Boolean	成功执行回调
		 * 
		 */					
		function mapFromNow(nodeData:ICData,callback:Function):Boolean;
		/**
		 * 遍历全部节点，并执行回调 
		 * @param callback	回调方法
		 * 
		 */		
		function forEach(callback:Function):void;
	}
}
package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	
	public interface IDoubleList
	{
//		function get rootNode():IDoubleNode;
//		function set rootNode(value:IDoubleNode):void;
//		function get endNode():IDoubleNode;
//		function set endNode(value:IDoubleNode):void;
		function get numberChildren():uint;
		/**
		 * 添加数据 
		 * @param nodeData
		 * @return Boolean	是否执行成功
		 * 
		 */			
		function add(nodeData:ICData):Boolean;
		/**
		 * 移除数据 
		 * @param nodeData
		 * @return Boolean 	是否执行成功
		 * 
		 */			
		function remove(nodeData:ICData):Boolean;
		/**
		 * 获取 
		 * @param uniqueID
		 * @return ICData
		 * 
		 */		
		function getDataByID(uniqueID:String):ICData;
//		/**
//		 * 从当前节点向下遍历搜索 
//		 * @param nodeData	数据
//		 * @param callback	回调
//		 * @return Boolean	成功执行回调
//		 * 
//		 */					
//		function mapNextFromNow(nodeData:ICData,callback:Function):Boolean;
//		/**
//		 * 从当前节点向上遍历搜索 
//		 * @param nodeData	数据
//		 * @param callback	回调
//		 * @return Boolean	成功执行回调
//		 * 
//		 */		
//		function mapPrevFromNow(nodeData:ICData,callback:Function):Boolean;
//		/**
//		 * 遍历当前节点，执行回调 
//		 * @param callback
//		 * @param isNext	是否向下遍历
//		 * @return Boolean
//		 * 
//		 */				
//		function mapFromNow(callback:Function,isNext:Boolean):Boolean;
		/**
		 * 根据遍历顺序，遍历所有节点并执行回调 
		 * @param callback	回调函数
		 * @param isNext	是否向下遍历
		 * 
		 */			
		function forEach(callback:Function,isNext:Boolean=true):void;
	}
}
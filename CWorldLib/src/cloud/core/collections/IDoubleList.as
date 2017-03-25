package cloud.core.collections
{
	import cloud.core.interfaces.ICData;
	
	public interface IDoubleList
	{
		/**
		 * 链表是否已满 
		 * @return Boolean
		 * 
		 */		
		function get isFull():Boolean;
		function get numberChildren():uint;
		/**
		 * 添加数据 
		 * @param nodeData
		 * @return Vector.<ICData>		返回发生改变的数据集合
		 * 
		 */			
		function add(nodeData:ICData):Vector.<ICData>;
		/**
		 * 移除数据 
		 * @param nodeData
		 * @return Vector.<ICData> 	返回发生改变的数据集合
		 * 
		 */			
		function remove(nodeData:ICData):Vector.<ICData>;
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
		function forEachNode(callback:Function,isNext:Boolean=true):void;
	}
}
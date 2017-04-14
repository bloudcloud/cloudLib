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
		/**
		 * 根据遍历顺序，遍历所有节点并执行回调 
		 * @param callback	回调函数，回调函数的格式：function callback(data:ICData):void
		 * @param isNext	是否向下遍历
		 * 
		 */			
		function forEachNode(callback:Function,isNext:Boolean=true):void;
		/**
		 * 清理链表 
		 * 
		 */		
		function clear():void;
	}
}
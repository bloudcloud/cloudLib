package cloud.core.interfaces
{
	/**
	 * 迭代器
	 * @author	cloud
	 * @date	2018-9-7
	 */
	public interface ICIterator
	{
		function get iteratorData():*;
		function get next():ICIterator;
		function get prev():ICIterator;
		function get linkLength():int;
		/**
		 * 连接下一个迭代器
		 * @param iterator
		 * 
		 */	
		function linkToNext(iterator:ICIterator):void;
		/**
		 * 根据迭代数据获取迭代器对象
		 * @param iteratorData
		 * @return ICIterator
		 * 
		 */		
		function getIteratorByData(iteratorData:*):ICIterator;
		/**
		 * 解除当前连接
		 * 
		 */		
		function unlink():void;
	}
}
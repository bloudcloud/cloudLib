package cloud.core.interfaces
{
	/**
	 * 数据模型接口
	 * @author cloud
	 */
	public interface ICDataModel
	{
		/**
		 * 添加数据
		 * @param data
		 * 
		 */		
		function addData(data:ICData):void;
		/**
		 * 移除数据 
		 * @param data
		 * 
		 */		
		function removeData(data:ICData):void;
	}
}
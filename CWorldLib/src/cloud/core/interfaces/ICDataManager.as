package cloud.core.interfaces
{
	/**
	 * 数据管理接口
	 * @author cloud
	 */
	public interface ICDataManager
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
		/**
		 * 根据类型获取数据集合 
		 * @param type	数据类型
		 * @return Vector.<ICData>
		 * 
		 */		
		function getDatasByType(type:uint):Vector.<ICData>;
		/**
		 * 根据唯一ID获取数据对象 
		 * @param uniqueID	唯一ID
		 * @return ICData
		 * 
		 */		
		function getDataByUniqueID(uniqueID:String):ICData;
		/**
		 * 根据数据类型和数据ID获取对象 
		 * @param type		数据类型
		 * @param uniqueID		数据ID
		 * @return ICData
		 * 
		 */		
		function getDataByTypeAndID(type:uint,uniqueID:String):ICData;
		/**
		 * 清空所有数据集合 
		 * 
		 */		
		function clear():void;
	}
}
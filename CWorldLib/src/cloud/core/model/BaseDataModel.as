package cloud.core.model
{
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICDataModel;
	
	import ns.cloudLib;
	
	use namespace cloudLib;
	/**
	 *	基础数据模型类
	 * @author cloud
	 */
	public class BaseDataModel implements ICDataModel
	{
		public function BaseDataModel()
		{
		}
		
		public function addData(data:ICData):void
		{
			CDataManager.instance.addData(data);
		}
		
		public function removeData(data:ICData):void
		{
			CDataManager.instance.removeData(data);
		}
		
		protected function getDatasByType(type:uint):Vector.<ICData>
		{
			return CDataManager.instance.getDatasByType(type);
		}
	}
}
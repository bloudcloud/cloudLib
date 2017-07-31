package cloud.core.data
{
	import cloud.core.interfaces.ICResource;
	
	/**
	 * 基础资源数据类
	 * @author cloud
	 */
	public class BaseResource implements ICResource
	{
		private var _refCount:int;
		
		public function BaseResource()
		{
		}
		
		public function get refCount():uint
		{
			return _refCount;
		}
		
		public function set refCount(value:uint):void
		{
			_refCount=value;
		}
		
		public function clear():void
		{
		}
	}
}
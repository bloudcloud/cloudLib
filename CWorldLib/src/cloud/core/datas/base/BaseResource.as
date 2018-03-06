package cloud.core.datas.base
{
	import cloud.core.interfaces.ICResource;
	
	/**
	 * 基础资源数据类
	 * @author cloud
	 */
	public class BaseResource implements ICResource
	{
		private var _refCount:int;
		private var _name:String;
		
		public function BaseResource()
		{
		}
		
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name=value;
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
			_name=null;
			_refCount=0;
		}
	}
}
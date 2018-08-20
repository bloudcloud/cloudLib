package cloud.core.datas.base
{
	import cloud.core.interfaces.ICResource;
	
	/**
	 * 基础资源数据类
	 * @author cloud
	 */
	public class BaseResource implements ICResource
	{
		private var _isLife:Boolean;
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
		/**
		 * 获取数据是否生存
		 * @return Boolean
		 * 
		 */		
		public function get isLife():Boolean
		{
			return _isLife;
		}
		/**
		 * 设置数据是否生存 
		 * @param value
		 * 
		 */		
		public function set isLife(value:Boolean):void
		{
			_isLife=value;
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
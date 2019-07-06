package extension.cloud.a3d.resources
{
	import alternativa.engine3d.resources.TextureResource;
	
	import extension.cloud.interfaces.ICNameResource;
	
	/**
	 * 纹理资源类
	 * @author cloud
	 */
	public class CTextureResource extends TextureResource implements ICNameResource
	{
		private var _refCount:int;
		
		protected var _name:String;
		protected var _code:String;
		protected var _mark:String;
		
		public function get code():String
		{
			return _code;
		}
		public function set code(v:String):void
		{
			_code = v;
		}
		
		public function get mark():String
		{
			return _mark;
		}
		public function set mark(value:String):void
		{
			_mark=value;
		}
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name=value;
		}
		public function get refCount():int
		{
			return _refCount;
		}
		public function set refCount(value:int):void
		{
			_refCount=value;
		}
		
		public function CTextureResource()
		{
			super();
			
		}
		/**
		 * 释放所有资源(需子类扩展方法)
		 * 
		 */		
		protected function doDisposeAll():void
		{
			_refCount=0
			_name=null;
			_code=null;
			_mark=null;
		}
		
		public function clear():void
		{
			_refCount--;
//			if(_refCount<=0)
//			{
//				CResourceManager.Instance.removeResource(this);
//				doDisposeAll();
//			}
		}
	}
}
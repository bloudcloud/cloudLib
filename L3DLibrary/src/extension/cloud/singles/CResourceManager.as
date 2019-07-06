package extension.cloud.singles
{
	
	import cloud.core.datas.maps.CHashMap;
	
	import extension.cloud.a3d.resources.CTextureResource;
	import extension.cloud.interfaces.ICNameResource;

	/**
	 * 资源管理类
	 * @author cloud
	 */
	public class CResourceManager
	{
		private static var _Instance:CResourceManager;
		
		public static function get Instance():CResourceManager
		{
			return _Instance||=new CResourceManager(new SingletonEnforce());
		}
		
		private var _resourceMap:CHashMap;
		
		public function CResourceManager(enforcer:SingletonEnforce)
		{
			_resourceMap=new CHashMap();
		}
		/**
		 * 添加资源 
		 * @param key
		 * @param resource
		 * 
		 */		
		public function addResource(key:String,resource:ICNameResource):void
		{
			var result:ICNameResource=_resourceMap.put(key,resource) as ICNameResource;
			if(result && result != resource)
			{
				resource.refCount=result.refCount;
				result.refCount=0;
				result.clear();
			}
			resource.refCount++;
		}
		/**
		 * 根据键值获取资源对象 
		 * @param key
		 * @return ICResource
		 * 
		 */		
		public function getResource(key:String):ICNameResource
		{
			var resource:ICNameResource=_resourceMap.get(key) as ICNameResource;
			if(resource)
				resource.refCount++;
			return resource;
		}
		/**
		 * 移除资源
		 * @param resource
		 * 
		 */
		public function removeResource(resource:ICNameResource):void
		{
			_resourceMap.remove(resource.mark);
		}
		/**
		 * 释放不使用的GPU显存
		 * 
		 */		
		public function disposeFreeGPUMemory():void
		{
			var keys:Array=_resourceMap.keys;
			var i:int=keys.length-1;
			var resource:CTextureResource;
			for(;i>0;i--)
			{
				resource=_resourceMap.get(keys[i]) as CTextureResource;
				if(resource && resource.refCount<=0)
				{
					resource.refCount=0;
					resource.dispose();
				}
			}
		}
	}
}
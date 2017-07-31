package cloud.core.singleton
{
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import cloud.core.data.map.CHashMap;
	import cloud.core.data.pool.CObjectPool;
	import cloud.core.data.pool.ICObjectPool;
	
	import ns.singleton;

	use namespace singleton;
	/**
	 * 池管理类
	 * @author cloud
	 */
	public class CPoolsManager
	{
		private static var _Instance:CPoolsManager;
		
		public static function get Instance():CPoolsManager
		{
			return _Instance ||= new CPoolsManager(new SingletonEnforce());
		}
		
		private var _poolMap:CHashMap;
		
		public function CPoolsManager(enforcer:SingletonEnforce)
		{
			_poolMap=new CHashMap();
		}
		/**
		 * 注册缓存池
		 * @param cls	缓存池的缓存对象类型
		 * @param size 缓存池的缓存对象的个数
		 * @param params	缓存池的缓存对象类型的实例化参数表 
		 * 
		 */			
		public function registPool(cls:*,size:int,...params):void
		{
			var realCls:String;
			var typeCls:Class;
			if(cls is String)
			{
				realCls=cls;
				typeCls=getDefinitionByName(cls) as Class;
			}
			else if(cls is Class)
			{
				realCls=getQualifiedClassName(cls as Class);
				typeCls=cls as Class;
			}
			//执行注册
			_poolMap.put(realCls,CClassFactory.instance.funcs[3-1].call(null,CObjectPool,[typeCls, params, size]));
		}
		/**
		 * 移除注册的缓冲池 
		 * @param cls
		 * 
		 */		
		public function unRegistPool(cls:*):void
		{
			var realCls:String;
			if(cls is String)
			{
				realCls=cls;
			}
			else if(cls is Class)
			{
				realCls=getQualifiedClassName(cls as Class);
			}
			var pool:ICObjectPool=_poolMap.remove(realCls) as ICObjectPool;
			pool.flush();
			pool.dispose();
		}
		/**
		 * 根据缓冲对象类型，获取缓冲池对象 
		 * @param cls	缓冲对象类型
		 * @return ICObjectPool
		 * 
		 */		
		public function getPool(cls:*):ICObjectPool
		{
			var realCls:String;
			if(cls is String)
				realCls=cls;
			else if(cls is Class)
				realCls=getQualifiedClassName(cls);
			else 
				return null;
			return _poolMap.containsKey(realCls) ? _poolMap.get(realCls) as ICObjectPool : null;
		}
	}
}
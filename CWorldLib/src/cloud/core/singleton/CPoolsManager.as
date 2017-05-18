package cloud.core.singleton
{
	import flash.utils.getDefinitionByName;
	
	import cloud.core.dataStruct.map.CHashMap;
	import cloud.core.dataStruct.pool.CObjectPool;
	import cloud.core.dataStruct.pool.ICObjectPool;
	
	import ns.singleton;

	use namespace singleton;
	/**
	 * 池管理类
	 * @author cloud
	 */
	public class CPoolsManager
	{
		private static var _instance:CPoolsManager;
		
		public static function get instance():CPoolsManager
		{
			return _instance ||= new CPoolsManager(new SingletonEnforce());
		}
		
		private var _poolMap:CHashMap;
		
		public function CPoolsManager(enforcer:SingletonEnforce)
		{
			_poolMap=new CHashMap();
		}
		/**
		 *  注册缓冲池
		 * @param cls	缓冲池的缓冲对象类型
		 * @param params	缓冲池的缓冲对象类型的实例化参数表
		 * 
		 */		
		public function registPool(cls:*,...params):void
		{
			var realCls:Class;
			if(cls is String)
			{
				realCls=getDefinitionByName(cls as String) as Class;
			}
			else
			{
				realCls=cls;
			}
			if(_poolMap.containsKey(realCls)) return;
			//执行注册
			_poolMap.put(realCls,CClassFactory.instance.funcs[3].apply(null,[CObjectPool, realCls, params, 5]));
		}
		/**
		 * 根据缓冲对象类型，获取缓冲池对象 
		 * @param cls	缓冲对象类型
		 * @return ICObjectPool
		 * 
		 */		
		public function getPool(cls:*):ICObjectPool
		{
			var realCls:Class;
			if(cls is String)
				realCls=getDefinitionByName(cls as String) as Class;
			else if(cls is Class)
				realCls=cls;
			else 
				return null;
			return _poolMap.containsKey(realCls) ? _poolMap.get(realCls) as ICObjectPool : null;
		}
	}
}
package cloud.core.singleton
{
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
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
			if(_poolMap.containsKey(realCls)) return;
			//执行注册
			_poolMap.put(realCls,CClassFactory.instance.funcs[3-1].call(null,CObjectPool,[typeCls, params, 5]));
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
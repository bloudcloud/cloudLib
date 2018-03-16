package happyECS.resources.pool
{

	import flash.utils.getQualifiedClassName;
	
	import happyECS.ns.happy_ecs;
	import happyECS.resources.CHashMap;
	
	use namespace happy_ecs;
	/**
	 * 缓冲池系统
	 * @author cloud
	 * @2018-3-8
	 */
	public class CPoolSystem
	{
		private static var _Instance:CPoolSystem;
		
		happy_ecs static function get Instance():CPoolSystem
		{
			return _Instance ||= new CPoolSystem();
		}
		
		private var _poolMap:CHashMap;
		
		public function CPoolSystem()
		{
		}
		/**
		 * 注册缓存池 
		 * @param cls
		 * @param size
		 * @param params
		 * 
		 */		
		public function registPool(clsName:String,cls:Class,size:uint,...params):void
		{
			//执行注册
			if(!_poolMap.containsKey(clsName))
			{
				_poolMap.put(clsName,new CPool(cls,size,params));
			}
		}
		/**
		 * 将对象放回缓存池 
		 * @param clsName
		 * @param o
		 * 
		 */		
		public function backToPool(clsName:String,o:ICPoolObject):void
		{
			(_poolMap.get(clsName) as CPool).push(o);
		}
		/**
		 * 从缓存池中获取一个实例对象 
		 * @param clsName
		 * @return 
		 * 
		 */		
		public function getFromPool(clsName:String):ICPoolObject
		{
			return (_poolMap.get(clsName) as CPool).pop();
		}
		/**
		 * 清理缓存池 
		 * 
		 */		
		public function clear():void
		{
			var pool:CPool;
			for (var key:String in _poolMap)
			{
				pool=_poolMap.get(key) as CPool;
				pool.clear();
			}
		}
	}
}

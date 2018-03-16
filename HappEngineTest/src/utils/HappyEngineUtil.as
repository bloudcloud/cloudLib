package utils
{
	import happyECS.ecs.component.BaseHComponent;
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.entity.IHEntity;
	import happyECS.ns.happy_ecs;
	import happyECS.resources.CHashMap;
	import happyECS.utils.CClassFactory;

	use namespace happy_ecs;
	/**
	 * 哈皮引擎工具类
	 * @author cloud
	 * @2018-3-14
	 */
	public class HappyEngineUtil
	{
		private static var _Instance:HappyEngineUtil;
		
		public static function get Instance():HappyEngineUtil
		{
			return _Instance ||= new HappyEngineUtil();
		}
		/**
		 * 获取ECS系统的类对象实例 
		 * @param cls	类对象
		 * @param params	实例化参数集
		 * @return *
		 * 
		 */		
		public function getECSInstance(cls:Class,...params):*
		{
			return params.length>0 ? CClassFactory.Instance.funcs[params.length-1].apply(null,params) : new cls();
		}
		/**
		 * 获取组件的引用 
		 * @param component
		 * @return BaseHComponent
		 * 
		 */		
		public function getComponentRef(component:BaseHComponent):BaseHComponent
		{
			component._refCount++;
			return component;
		}
		/**
		 * 释放组件的引用 
		 * @param component
		 * @return BaseHComponent
		 * 
		 */		
		public function releaseComponentRef(component:BaseHComponent):BaseHComponent
		{
			component._refCount--;
			return null;
		}
		/**
		 * 清空ECS系统的缓存哈希图
		 * @param map
		 * 
		 */		
		public function clearECSMap(map:CHashMap):void
		{
			for(var i:int=map.keys.length-1; i>=0; i--)
			{
				var obj:Object=map.get(map.keys[i]);
				if(obj is IHEntity || obj is IHComponent)
				{
					obj.dispose();
				}
				map.remove(map.keys[i]);
			}
		}
	}
}
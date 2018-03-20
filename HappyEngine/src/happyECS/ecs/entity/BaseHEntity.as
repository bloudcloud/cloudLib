package happyECS.ecs.entity
{
	import happyECS.ecs.component.IHComponent;
	import happyECS.ns.happy_ecs;
	import happyECS.resources.CHashMap;
	import happyECS.utils.ECSUtil;
	
	use namespace happy_ecs;
	/**
	 * 基础实体类
	 * @author cloud
	 * @2018-3-9
	 */
	public class BaseHEntity implements IHEntity
	{
		private var _entityID:String;
		private var _clsName:String;
		private var _componentMap:CHashMap;
		private var _propertyMap:CHashMap;
		
		public function get entityID():String
		{
			return _entityID;
		}
		
		public function BaseHEntity(refName:String="BaseHEntity")
		{
			_clsName=refName;
			_componentMap=new CHashMap();
			_propertyMap=new CHashMap();
			_entityID=ECSUtil.Instance.createUID();
			
			doInitialization();
		}

		protected function doInitialization():void
		{
		}

		public function addComponent(name:String, component:IHComponent):void
		{
			component.owner=this;
			_componentMap.put(name,component);
		}
		
		public function removeComponent(name:String):void
		{
			var component:IHComponent=_componentMap.remove(name) as IHComponent;
			if(component)
			{
				component.owner=null;
			}
		}
		
		public function addProperty(name:String, value:*):void
		{
			_propertyMap.put(name,value);
		}
		
		public function getProperty(name:String):*
		{
			return _propertyMap.get(name);
		}
		
		public function dispose():void
		{
			ECSUtil.Instance.clearECSHashMap(_componentMap);
			ECSUtil.Instance.clearECSHashMap(_propertyMap);
		}
	}
}
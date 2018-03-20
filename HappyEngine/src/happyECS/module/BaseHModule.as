package happyECS.module
{
	import happyECS.ecs.component.IHComponent;
	import happyECS.ecs.entity.IHEntity;
	import happyECS.ecs.system.IHSystem;
	import happyECS.resources.CHashMap;
	import happyECS.resources.pool.ICPool;
	import happyECS.utils.ECSUtil;
	
	/**
	 * 基础模块类
	 * @author cloud
	 * @2018-3-10
	 */
	public class BaseHModule implements IHModule
	{
		private var _clsName:String;
		private var _isInstalled:Boolean;
		
		private var _entityMap:CHashMap;
		private var _systems:Vector.<IHSystem>;
		
		public function BaseHModule(clsRefName:String="BaseHModule")
		{
			_clsName=clsRefName;
		}
		
		protected function doInstall():void
		{
		}
		protected function doUninstall():void
		{
		}
		protected function doCreateEntities():void
		{	
		}
		protected function doCreateSystems():void
		{
		}
		
		public function addEntity(entity:IHEntity):void
		{
			_entityMap.put(entity.entityID,entity);
		}
		
		public function removeEntity(entity:IHEntity):void
		{
			_entityMap.remove(entity.entityID);
		}
		
		public function addSystem(system:IHSystem):void
		{
			_systems.push(system);
		}
		
		public function removeSystem(system:IHSystem):void
		{
			var idx:int=_systems.indexOf(system);
			if(idx>=0)
			{
				_systems.removeAt(idx);
			}
		}
		
		public function get isInstalled():Boolean
		{
			return _isInstalled;
		}
		
		public function set systems(value:Vector.<IHSystem>):void
		{
			_systems=value;
		}
		
		public function set entities(value:Vector.<IHEntity>):void
		{
			ECSUtil.Instance.clearECSHashMap(_entityMap);
			for each(var entity:IHEntity in value)
			{
				addEntity(entity);
			}
		}
		
		public function set pools(value:Vector.<ICPool>):void
		{
		}
		
		public function set components(value:Vector.<IHComponent>):void
		{
		}
		
		public function install():void
		{
			_isInstalled=true;
			doInstall();
			doCreateEntities();
			doCreateSystems();
		}
		public function uninstall():void
		{
			_isInstalled=false;
			doUninstall();
			
			for each(var key:String in _entityMap.keys)
			{
				(_entityMap.get(key) as IHEntity).dispose();
				_entityMap.remove(key);
			}
			_entityMap=null;
			_systems.length=0;
			_systems=null;
		}

	}
}
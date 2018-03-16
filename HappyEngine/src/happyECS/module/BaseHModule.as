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
		private var _isInstalled:Boolean;
		
		protected var _entityMap:CHashMap;
		protected var _systems:Vector.<IHSystem>;
		
		public function BaseHModule()
		{
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
				_entityMap.put(entity.entityID,entity);
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
			_isInstalled=true
			doInstall();
		}
		public function uninstall():void
		{
			_isInstalled=false;
			doUninstall();
		}
	}
}
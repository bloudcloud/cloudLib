package happyECS.ecs.component
{
	import happyECS.ecs.entity.IHEntity;
	import happyECS.ns.happy_ecs;

	use namespace happy_ecs;
	/**
	 * 基础组件类
	 * @author cloud
	 * @2018-3-8
	 */
	public class BaseHComponent implements IHComponent
	{
		/**
		 * 类名 
		 */		
		private var _clsName:String;
		/**
		 * 所属实体对象 
		 */		
		private var _entity:IHEntity;
		/**
		 * 外部资源对象的引用 
		 */		
		private var _resource:*;

		happy_ecs var _refCount:uint;
		
		public function BaseHComponent(refName:String="BaseHComponent")
		{
			_clsName=refName;
			doInitialization();
		}
		protected function doInitialization():void
		{
		}
		public function get owner():IHEntity
		{
			return _entity;
		}
		public function set owner(ref:IHEntity):void
		{
			_entity=ref;
		}
		
		public function create(resource:*):void
		{
			_resource=resource;
		}
		
		public function dispose():void
		{
			_entity=null;
			_resource=null;	
		}
	}
}
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
		protected var _resource:*;

		private var _invalidResource:Boolean;
		/**
		 *  获取组件资源是否失效
		 * @return Boolean
		 * 
		 */		
		public function get invalidResource():Boolean
		{
			return _invalidResource;
		}

		happy_ecs var _refCount:uint;
		
		public function BaseHComponent(refName:String="BaseHComponent")
		{
			_clsName=refName;
			doInitialization();
		}
		/**
		 * 执行组件初始化 
		 * 
		 */		
		protected function doInitialization():void
		{
		}
		/**
		 * 执行更新组件 
		 */		
		protected function doUpdateComponent():void
		{
		}
		/**
		 * 更新资源引用 
		 * @param resource
		 * 
		 */		
		public function updateResource(resource:*):void
		{
			if(_resource!=resource)
			{
				_invalidResource=true;
				_resource=resource;
			}
		}
		/**
		 * 更新组件 
		 * 
		 */		
		public function updateComponent():void
		{
			if(_invalidResource)
			{
				_invalidResource=false;
				if(_resource!=null)
				{
					doUpdateComponent();
				}
			}
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
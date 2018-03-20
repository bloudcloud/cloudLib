package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	import happyECS.utils.ECSUtil;
	
	import prefabs.TypeDict;

	/**
	 *  基础对象组件
	 * @author cloud
	 * @2018-3-12
	 */
	public class BaseObjectComponent extends BaseHComponent
	{
		/**
		 * 标识ID
		 */		
		private var _uniqueID:String;
		/**
		 * 类型
		 */		
		public var type:uint;
		/**
		 *	名字 
		 */		
		public var name:String;

		public function get uniqueID():String
		{
			return _uniqueID;
		}
		
		public function BaseObjectComponent()
		{
			super(TypeDict.BASEOBJECT_COMPONENT_CLSNAME);
		}
		
		override protected function doInitialization():void
		{
			_uniqueID=ECSUtil.Instance.createUID();
		}
		
		override protected function doUpdateComponent():void
		{
			_uniqueID=_resource.uniqueID;
			type=_resource.type;
			name=_resource.name;
		}
	}
}
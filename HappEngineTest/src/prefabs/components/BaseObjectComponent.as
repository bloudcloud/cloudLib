package prefabs.components
{
	import cloud.core.utils.CUtil;
	
	import happyECS.ecs.component.BaseHComponent;
	
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
			_uniqueID;
		}
		
		public function BaseObjectComponent()
		{
			_uniqueID=CUtil.Instance.createUID();
			super(TypeDict.BASEOBJECT_COMPONENT_CLSNAME);
		}
	}
}
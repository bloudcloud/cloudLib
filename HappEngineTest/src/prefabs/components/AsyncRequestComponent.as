package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;

	/**
	 * 异步请求组件类
	 * @author cloud
	 * @2018-3-14
	 */
	public class AsyncRequestComponent extends BaseHComponent
	{
		/**
		 * 请求名称 
		 */		
		public var requestName:String;
		/**
		 * 请求参数集合 
		 */		
		public var requestParams:Array;
		/**
		 * 请求成功回调函数 
		 */		
		public var successCallback:Function;
		/**
		 * 请求失败回调函数 
		 */		
		public var faultCallback:Function;
		
		public function AsyncRequestComponent()
		{
			super(TypeDict.BASEOBJECT_COMPONENT_CLSNAME);
		}
		
		override public function dispose():void
		{
			super.dispose();
			successCallback=null;
			faultCallback=null;
		}
	}
}
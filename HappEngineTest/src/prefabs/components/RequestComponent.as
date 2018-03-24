package prefabs.components
{
	import happyECS.ecs.component.BaseHComponent;
	
	import dict.PrefabTypeDict;

	/**
	 * 异步请求组件类
	 * @author cloud
	 * @2018-3-14
	 */
	public class RequestComponent extends BaseHComponent
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
		
		public function RequestComponent()
		{
			super(PrefabTypeDict.BASEOBJECT_COMPONENT_CLSNAME);
		}
		
		override protected function doUpdateComponent():void
		{
			requestName=_resource.requestName;
			requestParams=_resource.requestParams;
			successCallback=_resource.successCallback;
			faultCallback=_resource.faultCallback;
		}
		 
		override public function dispose():void
		{
			super.dispose();
			successCallback=null;
			faultCallback=null;
		}
	}
}
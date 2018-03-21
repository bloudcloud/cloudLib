package prefabs.components
{
	import flash.utils.ByteArray;
	
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
	/**
	 * 材质组件类
	 * @author cloud
	 * @2018-3-13
	 */
	public class MaterialComponent extends BaseHComponent
	{
		public var mode:String;
		public var vrmMode:int;
		public var renderMode:int;
		public var previewBuffer:ByteArray;
		
		
		public function MaterialComponent()
		{
			super(TypeDict.MATERIAL_COMPONENT_CLSNAME);
		}
		
		override protected function doUpdateComponent():void
		{
			mode = _resource.mode;
			vrmMode = _resource.vrmode;
			renderMode = _resource.renderMode;
			previewBuffer=_resource.previewBuffer;
		}
	}
}
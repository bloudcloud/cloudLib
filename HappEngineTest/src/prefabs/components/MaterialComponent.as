package prefabs.components
{
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
		
		public function MaterialComponent()
		{
			super(TypeDict.MATERIAL_COMPONENT_CLSNAME);
		}
	}
}
package prefabs.entities
{
	import happyECS.ecs.component.BaseHComponent;
	import happyECS.ecs.entity.BaseHEntity;
	
	import prefabs.TypeDict;
	
	import resources.manager.GlobalManager;
	
	import utils.HappyEngineUtil;
	
	/**
	 * 砖块实体类
	 * @author cloud
	 * @2018-3-13
	 */
	public class TileEntity extends BaseHEntity
	{
		public function TileEntity()
		{
			super(TypeDict.TILE_ENTITY_CLSNAME);
		}
		override protected function doInitialization():void
		{
			var component:BaseHComponent;
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(TypeDict.BASEOBJECT_COMPONENT_CLSNAME));
			addComponent(TypeDict.BASEOBJECT_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(TypeDict.COMMODITY_COMPONENT_CLSNAME));
			addComponent(TypeDict.COMMODITY_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(TypeDict.MATERIAL_COMPONENT_CLSNAME));
			addComponent(TypeDict.MATERIAL_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
		}
	}
}
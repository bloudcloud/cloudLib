package prefabs.entities
{
	import happyECS.ecs.component.BaseHComponent;
	import happyECS.ecs.entity.BaseHEntity;
	
	import dict.PrefabTypeDict;
	
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
			super(PrefabTypeDict.TILE_ENTITY_CLSNAME);
		}
		override protected function doInitialization():void
		{
			var component:BaseHComponent;
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(PrefabTypeDict.BASEOBJECT_COMPONENT_CLSNAME));
			addComponent(PrefabTypeDict.BASEOBJECT_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(PrefabTypeDict.COMMODITY_COMPONENT_CLSNAME));
			addComponent(PrefabTypeDict.COMMODITY_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
			component=HappyEngineUtil.Instance.getECSInstance(GlobalManager.Instance.resourceMGR.getClassByKey(PrefabTypeDict.MATERIAL_COMPONENT_CLSNAME));
			addComponent(PrefabTypeDict.MATERIAL_COMPONENT_CLSNAME,HappyEngineUtil.Instance.getComponentRef(component));
		}
	}
}
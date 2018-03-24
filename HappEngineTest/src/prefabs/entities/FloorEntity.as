package prefabs.entities
{
	import happyECS.ecs.entity.BaseHEntity;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 地面实体类
	 * @author cloud
	 * @2018-3-13
	 */
	public class FloorEntity extends BaseHEntity
	{
		public function FloorEntity()
		{
			super(PrefabTypeDict.FLOOR_ENTITY_CLSNAME);
		}
	}
}
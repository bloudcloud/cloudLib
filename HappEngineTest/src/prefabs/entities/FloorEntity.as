package prefabs.entities
{
	import happyECS.ecs.entity.BaseHEntity;
	
	import prefabs.TypeDict;
	
	/**
	 * 地面实体类
	 * @author cloud
	 * @2018-3-13
	 */
	public class FloorEntity extends BaseHEntity
	{
		public function FloorEntity()
		{
			super(TypeDict.FLOOR_ENTITY_CLSNAME);
		}
	}
}
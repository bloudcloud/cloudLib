package prefabs.entities
{
	import happyECS.ecs.entity.BaseHEntity;
	
	import prefabs.TypeDict;
	
	/**
	 * 墙面实体类
	 * @author cloud
	 * @2018-3-13
	 */
	public class WallEntity extends BaseHEntity
	{
		public function WallEntity()
		{
			super(TypeDict.WALL_ENTITY_CLSNAME);
		}
	}
}
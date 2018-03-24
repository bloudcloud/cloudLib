package prefabs.entities
{
	import happyECS.ecs.entity.BaseHEntity;
	
	import dict.PrefabTypeDict;
	
	/**
	 * 墙面实体类
	 * @author cloud
	 * @2018-3-13
	 */
	public class WallEntity extends BaseHEntity
	{
		public function WallEntity()
		{
			super(PrefabTypeDict.WALL_ENTITY_CLSNAME);
		}
	}
}
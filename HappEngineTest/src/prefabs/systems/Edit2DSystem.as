package prefabs.systems
{
	import dict.PrefabTypeDict;
	
	import happyECS.ecs.events.ECSEvent;
	import happyECS.ecs.system.BaseHSystem;
	
	/**
	 * 2D编辑系统类
	 * @author cloud
	 * @2018-3-14
	 */
	public class Edit2DSystem extends BaseHSystem
	{
		public function Edit2DSystem()
		{
			super(PrefabTypeDict.EDIT2D_SYSTEM_CLSNAME);
//			this.addEventListener(EventTypeDict.TILEPLAN_SERIALIZE_EVENT,onTilePlanSerializeDataHandler);
//			this.addEventListener(EventTypeDict.TILEPLAN_DESERIALIZE_EVENT,onTilePlanDeserializeDataHandler);
		}
		
		private function onTilePlanSerializeDataHandler(evt:ECSEvent):void
		{
			
		}
		
		private function onTilePlanDeserializeDataHandler(evt:ECSEvent):void
		{
			
		}
		public function excuteTile():void
		{
			
		}
	}
}
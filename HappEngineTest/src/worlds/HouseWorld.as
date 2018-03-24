package worlds
{
	import happyECS.world.BaseHWorld;
	
	import modules.EditTileModule;
	
	import dict.PrefabTypeDict;
	
	import utils.HappyEngineUtil;

	/**
	 * 单房间场景世界类
	 * @author cloud
	 * @2018-3-17
	 */
	public class HouseWorld extends BaseHWorld
	{
		private var _editTileModule:EditTileModule;
		
		public function HouseWorld()
		{
			super(PrefabTypeDict.HOUSE_WORLD_CLSNAME);
		}
		override protected function doCreated():void
		{
			_editTileModule=new EditTileModule();
			_editTileModule.install();
			addModule(_editTileModule);
		}
		override protected function doDisposed():void
		{
			_editTileModule=null;
		}

		public function setResource():void
		{
			
		}
	}
}
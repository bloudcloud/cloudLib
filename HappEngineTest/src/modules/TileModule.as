package modules
{
	import resources.LJResourceRegist;
	
	import happyECS.module.BaseHModule;
	
	import prefabs.TypeDict;
	import prefabs.components.BaseObjectComponent;
	import prefabs.components.CommodityComponent;
	import prefabs.components.MaterialComponent;
	import prefabs.components.PlanComponent;
	import prefabs.components.RegionComponent;
	import prefabs.entities.FloorEntity;
	import prefabs.entities.TileEntity;
	import prefabs.entities.WallEntity;
	import prefabs.systems.CommandSystem;
	import prefabs.systems.DownloadSystem;
	import prefabs.systems.Show2DSystem;
	import prefabs.systems.Show3DSystem;
	import prefabs.systems.TileSystem;
	
	/**
	 * 铺砖模块
	 * @author cloud
	 * @2018-3-12
	 */
	public class TileModule extends BaseHModule
	{
		private var _commandSys:DownloadSystem;
		private var _show2dSys:Show2DSystem;
		private var _show3dSys:Show3DSystem;
		private var _tileSys:TileSystem;
		
		public function TileModule()
		{
			super();
		}
		
		override protected function doInstall():void
		{
			LJResourceRegist.Instance.registClass(TypeDict.BASEOBJECT_COMPONENT_CLSNAME,BaseObjectComponent);
			LJResourceRegist.Instance.registClass(TypeDict.COMMODITY_COMPONENT_CLSNAME,CommodityComponent);
			LJResourceRegist.Instance.registClass(TypeDict.MATERIAL_COMPONENT_CLSNAME,MaterialComponent);
			LJResourceRegist.Instance.registClass(TypeDict.REGION_COMPONENT_CLSNAME,RegionComponent);
			LJResourceRegist.Instance.registClass(TypeDict.PLAN_COMPONENT_CLSNAME,PlanComponent);
			
			LJResourceRegist.Instance.registClass(TypeDict.TILE_ENTITY_CLSNAME,TileEntity);
			LJResourceRegist.Instance.registClass(TypeDict.FLOOR_ENTITY_CLSNAME,FloorEntity);
			LJResourceRegist.Instance.registClass(TypeDict.WALL_ENTITY_CLSNAME,WallEntity);
			
			LJResourceRegist.Instance.registClass(TypeDict.DOWNLOAD_SYSTEM_CLSNAME,DownloadSystem);
			LJResourceRegist.Instance.registClass(TypeDict.SHOW2D_SYSTEM_CLSNAME,Show2DSystem);
			LJResourceRegist.Instance.registClass(TypeDict.SHOW3D_SYSTEM_CLSNAME,Show3DSystem);
			LJResourceRegist.Instance.registClass(TypeDict.TILE_SYSTEM_CLSNAME,TileSystem);
		}
		override protected function doUninstall():void
		{
			LJResourceRegist.Instance.unregistClass(TypeDict.BASEOBJECT_COMPONENT_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.COMMODITY_COMPONENT_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.MATERIAL_COMPONENT_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.REGION_COMPONENT_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.PLAN_COMPONENT_CLSNAME);
			
			LJResourceRegist.Instance.unregistClass(TypeDict.TILE_ENTITY_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.FLOOR_ENTITY_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.WALL_ENTITY_CLSNAME);
			
			LJResourceRegist.Instance.unregistClass(TypeDict.DOWNLOAD_SYSTEM_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.SHOW2D_SYSTEM_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.SHOW3D_SYSTEM_CLSNAME);
			LJResourceRegist.Instance.unregistClass(TypeDict.TILE_SYSTEM_CLSNAME);
		}
		override protected function doCreateEntities():void
		{
			
		}
		override protected function doCreateSystems():void
		{
			_commandSys=new CommandSystem();
			_systems.push(_commandSys);
			_show2dSys=new Show2DSystem();
			_systems.push(_show2dSys);
			_show3dSys=new Show3DSystem();
			_systems.push(_show3dSys);
			_tileSys=new TileSystem();
			_systems.push(_tileSys);
		}
		
		public function excuteDownLoad(urls:Array,callback:Function):Boolean
		{
//			_commandSys
		}
		
		
	}
}
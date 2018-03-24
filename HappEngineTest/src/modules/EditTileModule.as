package modules
{
	import core.datas.L3DMaterialInformations;
	
	import dict.EventTypeDict;
	import dict.PrefabTypeDict;
	
	import happyECS.ecs.events.ECSEvent;
	import happyECS.module.BaseHModule;
	
	import prefabs.components.BaseObjectComponent;
	import prefabs.components.CauclateComponent;
	import prefabs.components.CommodityBasicComponent;
	import prefabs.components.CommodityModelComponent;
	import prefabs.components.MaterialComponent;
	import prefabs.components.RegionComponent;
	import prefabs.components.RequestComponent;
	import prefabs.components.RollbackComponent;
	import prefabs.components.TilePlanComponent;
	import prefabs.entities.FloorEntity;
	import prefabs.entities.TileEntity;
	import prefabs.entities.WallEntity;
	import prefabs.systems.CalculateSystem;
	import prefabs.systems.CommandSystem;
	import prefabs.systems.Edit2DSystem;
	import prefabs.systems.Edit3DSystem;
	import prefabs.systems.RollbackSystem;
	import prefabs.systems.Show2DSystem;
	import prefabs.systems.Show3DSystem;
	
	import resources.manager.GlobalManager;
	
	import utils.OKResourceUtil;
	
	/**
	 * 铺贴模块
	 * @author cloud
	 * @2018-3-12
	 */
	public class EditTileModule extends BaseHModule
	{
		private var _commandSys:CommandSystem;
		private var _show2dSys:Show2DSystem;
		private var _show3dSys:Show3DSystem;
		private var _edit2dSys:Edit2DSystem;
		private var _edit3dSys:Edit3DSystem;
		private var _rollbackSys:RollbackSystem;
		private var _calculateSys:CalculateSystem;
		
		public function EditTileModule()
		{
			super(PrefabTypeDict.EDITTILE_MODULE_CLSNAME);
		}
		
		override protected function doInstall():void
		{
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.BASEOBJECT_COMPONENT_CLSNAME,BaseObjectComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.COMMODITY_BASIC_COMPONENT_CLSNAME,CommodityBasicComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.COMMODITY_MODEL_COMPONENT_CLSNAME,CommodityModelComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.MATERIAL_COMPONENT_CLSNAME,MaterialComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.REGION_COMPONENT_CLSNAME,RegionComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.TILEPLAN_COMPONENT_CLSNAME,TilePlanComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.REQUEST_COMPONENT_CLSNAME,RequestComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.ROLLBACK_COMPONENT_CLSNAME,RollbackComponent);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.CAUCLATE_COMPONENT_CLSNAME,CauclateComponent);
			
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.TILE_ENTITY_CLSNAME,TileEntity);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.FLOOR_ENTITY_CLSNAME,FloorEntity);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.WALL_ENTITY_CLSNAME,WallEntity);
			
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.COMMAND_SYSTEM_CLSNAME,CommandSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.SHOW2D_SYSTEM_CLSNAME,Show2DSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.SHOW3D_SYSTEM_CLSNAME,Show3DSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.EDIT2D_SYSTEM_CLSNAME,Edit2DSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.EDIT3D_SYSTEM_CLSNAME,Edit3DSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.ROLLBACK_SYSTEM_CLSNAME,RollbackSystem);
			GlobalManager.Instance.resourceMGR.registClass(PrefabTypeDict.CALCULATE_SYSTEM_CLSNAME,CalculateSystem);
		}
		override protected function doUninstall():void
		{
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.BASEOBJECT_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.COMMODITY_BASIC_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.MATERIAL_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.REGION_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.TILEPLAN_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.REQUEST_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.ROLLBACK_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.CAUCLATE_COMPONENT_CLSNAME);
			
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.TILE_ENTITY_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.FLOOR_ENTITY_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.WALL_ENTITY_CLSNAME);
			
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.COMMAND_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.SHOW2D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.SHOW3D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.EDIT2D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.EDIT3D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.ROLLBACK_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(PrefabTypeDict.CALCULATE_SYSTEM_CLSNAME);
		}
		
		override protected function doCreateEntities():void
		{
			
		}
		override protected function doCreateSystems():void
		{
			_commandSys=new CommandSystem();
			addSystem(_commandSys);
			_show2dSys=new Show2DSystem();
			addSystem(_show2dSys);
			_show3dSys=new Show3DSystem();
			addSystem(_show3dSys);
			_edit2dSys=new Edit2DSystem();
			addSystem(_edit2dSys);
			_edit3dSys=new Edit3DSystem();
			addSystem(_edit3dSys);
			_rollbackSys=new RollbackSystem();
			addSystem(_rollbackSys);
			_calculateSys=new CalculateSystem();
			addSystem(_calculateSys);
		}
		
		public function excuteLoadLayer():void
		{
			var materialInfo:L3DMaterialInformations=OKResourceUtil.Instance.getL3DMaterialInfoResource("D-6",null,doGetMaterialInfoSuccess,doGetMaterialInfoFault);
			if(materialInfo)
			{
				doGetMaterialInfoSuccess(materialInfo.url,materialInfo);
			}
		}
		
		protected function doGetMaterialInfoSuccess(resourceID:String,materialInfo:L3DMaterialInformations):void
		{
			_edit2dSys.dispatchEvent(new ECSEvent(EventTypeDict.TILEPLAN_DESERIALIZE_EVENT,materialInfo));
		}
		
		protected function doGetMaterialInfoFault(resourceID:String,message:String)
		{
			
		}
	}
}
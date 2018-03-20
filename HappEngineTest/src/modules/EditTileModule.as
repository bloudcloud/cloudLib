package modules
{
	import happyECS.module.BaseHModule;
	
	import prefabs.TypeDict;
	import prefabs.components.BaseObjectComponent;
	import prefabs.components.CauclateComponent;
	import prefabs.components.CommodityComponent;
	import prefabs.components.MaterialComponent;
	import prefabs.components.PlanComponent;
	import prefabs.components.RegionComponent;
	import prefabs.components.RequestComponent;
	import prefabs.components.RollbackComponent;
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
			super(TypeDict.EDITTILE_MODULE_CLSNAME);
		}
		
		override protected function doInstall():void
		{
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.BASEOBJECT_COMPONENT_CLSNAME,BaseObjectComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.COMMODITY_COMPONENT_CLSNAME,CommodityComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.MATERIAL_COMPONENT_CLSNAME,MaterialComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.REGION_COMPONENT_CLSNAME,RegionComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.PLAN_COMPONENT_CLSNAME,PlanComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.REQUEST_COMPONENT_CLSNAME,RequestComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.ROLLBACK_COMPONENT_CLSNAME,RollbackComponent);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.CAUCLATE_COMPONENT_CLSNAME,CauclateComponent);
			
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.TILE_ENTITY_CLSNAME,TileEntity);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.FLOOR_ENTITY_CLSNAME,FloorEntity);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.WALL_ENTITY_CLSNAME,WallEntity);
			
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.COMMAND_SYSTEM_CLSNAME,CommandSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.SHOW2D_SYSTEM_CLSNAME,Show2DSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.SHOW3D_SYSTEM_CLSNAME,Show3DSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.EDIT2D_SYSTEM_CLSNAME,Edit2DSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.EDIT3D_SYSTEM_CLSNAME,Edit3DSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.ROLLBACK_SYSTEM_CLSNAME,RollbackSystem);
			GlobalManager.Instance.resourceMGR.registClass(TypeDict.CALCULATE_SYSTEM_CLSNAME,CalculateSystem);
		}
		override protected function doUninstall():void
		{
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.BASEOBJECT_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.COMMODITY_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.MATERIAL_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.REGION_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.PLAN_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.REQUEST_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.ROLLBACK_COMPONENT_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.CAUCLATE_COMPONENT_CLSNAME);
			
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.TILE_ENTITY_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.FLOOR_ENTITY_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.WALL_ENTITY_CLSNAME);
			
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.COMMAND_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.SHOW2D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.SHOW3D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.EDIT2D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.EDIT3D_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.ROLLBACK_SYSTEM_CLSNAME);
			GlobalManager.Instance.resourceMGR.unregistClass(TypeDict.CALCULATE_SYSTEM_CLSNAME);
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
			_edit2dSys=new Edit2DSystem();
			_systems.push(_edit2dSys);
			_edit3dSys=new Edit3DSystem();
			_systems.push(_edit3dSys);
			_rollbackSys=new RollbackSystem();
			_systems.push(_rollbackSys);
			_calculateSys=new CalculateSystem();
			_systems.push(_calculateSys);
		}
		
		public function excuteDownLoad(urls:Array,callback:Function):Boolean
		{
//			_commandSys
		}
		
		
	}
}
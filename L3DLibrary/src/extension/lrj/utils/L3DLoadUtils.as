package extension.lrj.utils
{
	import flash.events.EventDispatcher;
	
	import L3DLibrary.L3DLibraryWebService;
	import L3DLibrary.L3DMaterialInformations;
	
	import extension.cloud.singles.CL3DModuleUtil;
	
	import utils.DatasEvent;
	import utils.lx.managers.GlobalManager;

	public class L3DLoadUtils extends EventDispatcher
	{
		public function L3DLoadUtils()
		{
		}
		
		private static var _Instance:L3DLoadUtils = null;
		private var _currentID:String = null;
		private var materials:Vector.<L3DMaterialInformations> = null;
		private var itemsinfos:Array = null;
		private var maxLength:int = 0;
		public static const LOAD_MATERIALS_COMPLETE:String = "Load_Materials_Complete";
		
		public function MaxLength(v:int):void
		{
			maxLength = v;
		}
		public static function get Instance():L3DLoadUtils 
		{
			return _Instance ||=new L3DLoadUtils();
		}
		
		public function get currentID():String
		{
			return _currentID;
		}
		
		public function loadByID(id:String):void
		{
			if(materials == null)
			{
				materials = new Vector.<L3DMaterialInformations>();	
			}
			
			_currentID = id;
			var infos:Array = CL3DModuleUtil.Instance.getXMLNodeResource(id,urlsFindHandler);
			if(infos)
			{
				urlsFindHandler(currentID, infos);
			}
		}
		
		private function urlsFindHandler(id:String, infos:Array):void
		{
			// TODO Auto Generated method stub
			if(id != currentID)
			{
				return;
			}
			
			if(infos.length>maxLength)
			{			
				infos = infos.slice(0,maxLength);
				
			}
		
			itemsinfos = infos.concat();
			
			if(infos.length > 0)
			{
				loadMaterialInfo();
			}
		}		
		
		private function loadMaterialInfo():void
		{
			// TODO Auto Generated method stub
			var itemUrl:String = itemsinfos.shift();
			if(itemUrl != null && itemUrl.length > 0 && L3DLibraryWebService.WebServiceEnable)
			{
				var itemInfo:L3DMaterialInformations = CL3DModuleUtil.Instance.getL3DMaterialInfoResource(null,itemUrl,materialInfoHandler);
				
				if(itemInfo)
				{
					materialInfoHandler(itemUrl, itemInfo);
				}
			}
		}
		
		private function materialInfoHandler(itemUrl:String, itemInfo:L3DMaterialInformations):void
		{
			// TODO Auto Generated method stub
			materials.push(itemInfo);
			
			if(itemsinfos.length > 0)
			{
				loadMaterialInfo();
			}
			else
			{
				if(materials)
				{
					var obj:Object = {};
					obj.id = _currentID;
					obj.data = materials.concat();
					
					GlobalManager.Instance.dispatchEvent(new DatasEvent(LOAD_MATERIALS_COMPLETE, obj));
				}
			}
		}
		
		public function clean():void
		{
//			if(_Instance)
//			{
//				_Instance = null;
//			}
			
			if(_currentID)
			{
				_currentID = null;
			}
		
			if(materials)
			{
				materials.splice(0, materials.length);
				materials = null;
			}
			
			if(itemsinfos)
			{
				itemsinfos = null;
			}
		}
		
	}
}
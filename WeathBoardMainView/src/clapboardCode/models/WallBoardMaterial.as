package clapboardCode.models
{
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DMaterialInformations;
	
	import cores.HashMap;
	
	import extension.cloud.singles.CL3DModuleUtil;
	
	import utils.DatasEvent;
	
	public class WallBoardMaterial extends EventDispatcher
	{
		public static const LoadMaterialComplete:String = "BasicWallBoard_LoadMaterialComplete";
		private var _map:HashMap = new HashMap();
		
		public function WallBoardMaterial()
		{
			if(_instance)
			{
				throw new Error("已创建实例");
			}
		}
		
		public function get hashMap():HashMap
		{
			return _map;
		}
		
		public function searchMaterialByCode(code:String):void
		{
			if(_map.hasKey(code)){
				dispatchEvent(new DatasEvent(LoadMaterialComplete));
			}else{ 
				var materialInfo:L3DMaterialInformations = new L3DMaterialInformations();
				materialInfo.code = code;
				materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoCompleteHandler);
				materialInfo.SearchMaterialInformation(materialInfo.code);
			}
		}
		
		public function getMaterial(code:String):L3DMaterialInformations
		{
			var info:L3DMaterialInformations;
			info=CL3DModuleUtil.Instance.getL3DMaterialInfoResource(code,null);
			return info?info:_map.getValue(code) as L3DMaterialInformations;
		}
		
		public function addMaterial(code:String,information:L3DMaterialInformations):void
		{
			if(!_map.hasKey(code))
			{
				CL3DModuleUtil.Instance.saveL3DMateiralInfo(code,information);
				_map.add(code,information);
			}
		}
		
		public function hasMaterial(code:String):Boolean
		{
			return _map.hasKey(code);
		}
		private function SearchMaterialInfoCompleteHandler(event:L3DLibraryEvent):void{
			var materialInfo:L3DMaterialInformations=event.MaterialInformation;
			materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);
			materialInfo.DownloadMaterial();
		}
		private function LoadMaterialBufferCompleteHandler(evt:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations=evt.target as L3DMaterialInformations;
			materialInfo.removeEventListener(evt.type,LoadMaterialBufferCompleteHandler);
			materialInfo.previewBuffer=evt.MaterialBuffer;
			materialInfo.addEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			materialInfo.LoadPreview();
		}
		
		private function SearchMaterialInformationFault(event:FaultEvent):void
		{
			var e:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			e.MaterialInformation = null;
			dispatchEvent(e);
		}
		
		private function loadPreviewHandler(event:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations = event.target as L3DMaterialInformations;
			materialInfo.removeEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			materialInfo.Preview = event.PreviewBitmap;
			_map.add(materialInfo.code,materialInfo);
			CL3DModuleUtil.Instance.saveL3DMateiralInfo(materialInfo.code,materialInfo);
			dispatchEvent(new DatasEvent(LoadMaterialComplete));
		}
		
		private static var _instance:WallBoardMaterial;
		
		public static function get instance():WallBoardMaterial
		{
			return _instance||= new WallBoardMaterial();
		}
	}
}
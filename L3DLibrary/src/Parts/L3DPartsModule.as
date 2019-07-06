package Parts 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import spark.components.Alert;
	
	import L3DLibrary.L3DLibraryWebService;
	import L3DLibrary.L3DRootNode;
	import L3DLibrary.LivelyLibrary;
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.utils.Object3DUtils;
	
	import extension.cloud.dict.CWebServiceDict;
	
	import utils.lx.managers.GlobalManager;
	
	public class L3DPartsModule extends EventDispatcher
	{
		public var code:String = "MB-001";
		public var name:String = "新建方案";
		public var mainClothCode:String = "";
		public var mainClothName:String = "";
		public var author:String = "";
		public var linkedData:String = "";
		public var description:String = "";
		private var previewBuffer:ByteArray = null;		
		private var preview:BitmapData = null;	
	//	private var server:LejiaPartsService7 = null;
		private var completeFun:Function = null;
		private var scene:Object3D = null;		
		private static var stage3D:Stage3D;
		private var combinedMesh:L3DMesh = null;		
		private var windowLength:int = 3000;
		private var windowHeight:int = 2700;
		private var originWindowLength:int = 3000;
		private var originWindowHeight:int = 2700;
		private var minWindowLength:int = 1500;
		private var maxWindowLength:int = 6000;
		private var minWindowHeight:int = 2000;
		private var maxWindowHeight:int = 4500;		
		private var currentIndex:int = -1;	
		private var currentSubsetIndex:int = -1;
		private var caculations:Vector.<L3DPartCaculation> = new Vector.<L3DPartCaculation>();
		private var currentLoadCaculationIndex:int = 0;
		private var version:int = 0;
		private var loadMeshCompleteFun:Function = null;
		private static var exportMode:Boolean = false;
		public static const LoadModulePreview:String = "LoadModulePreview";
		
		public static var webService:WebService;
		
	//	private static var serverClass:Class;
	//	private static var server:Object = null;
		
		private static var loadingPartsMode:Boolean = false;
		private var editMode:Boolean = true;
		
		public function L3DPartsModule(combinedMesh:L3DMesh, scene:Object3D, stage3D:Stage3D)
		{
			this.combinedMesh = combinedMesh;
			this.scene = scene;
			if(stage3D != null)
			{
			    L3DPartsModule.stage3D = stage3D;
			}
			if(combinedMesh == null)
			{
				BuildCombinedMesh();
			}
			else
			{
				windowLength = combinedMesh.WindowLength;
				windowHeight = combinedMesh.WindowHeight;
				maxWindowLength = combinedMesh.MaxWindowLength;
				minWindowLength = combinedMesh.MinWindowLength;
				maxWindowHeight = combinedMesh.MaxWindowHeight;
				minWindowHeight = combinedMesh.MinWindowHeight;
				for(var i:int = 0;i<combinedMesh.numChildren;i++)
				{
					var subObject:Object3D = combinedMesh.getChildAt(i);
					if(subObject is L3DMesh)
					{
						var subMesh:L3DMesh = subObject as L3DMesh;						
						if(subMesh.caculation != null)
						{
							if(!subMesh.caculation.IsArraiedPart)
							{
							    subMesh.caculation.CombinedMesh = combinedMesh;
							    caculations.push(subMesh.caculation);
							}
						}
						else
						{
							subMesh.caculation = new L3DPartCaculation(subMesh, combinedMesh);
							subMesh.caculation.CombinedMesh = combinedMesh;
							subMesh.WindowLength = windowLength;
							subMesh.WindowHeight = windowHeight;
							subMesh.MinWindowLength = minWindowLength;
							subMesh.MaxWindowLength = maxWindowLength;
							subMesh.MinWindowHeight = minWindowHeight;
							subMesh.MaxWindowHeight = maxWindowHeight;
							subMesh.caculation.Amend();
							caculations.push(subMesh.caculation);
						}
					}
				}
				scene.addChild(combinedMesh);
			}
		}	
		
		private static var isOpenAlert:Boolean;
		private static var webServiceEnabled:Boolean;
		public static function SetupPartsModule(url:String):void
		{
			webService = new WebService();
			webService.wsdl = url;
			webService.addEventListener(LoadEvent.LOAD, onWebServiceLoad);
			webService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
			webService.requestTimeout = 1200;
			webService.loadWSDL();
		}
		
		private static function onWebServiceLoad(e:LoadEvent):void
		{
			webServiceEnabled = true;
//			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private static function onWebServiceFault(e:FaultEvent):void
		{
			if(!isOpenAlert)
				Alert.show("网络连接错误，或远端服务器未能响应，请检查网络配置。","",4,null,closeHandler);
			
			isOpenAlert = true;
		}
		
		private static function closeHandler(event:CloseEvent):void
		{
			isOpenAlert = false;
		}
		
		public static function get LoadingPartsMode():Boolean
		{
			return loadingPartsMode;
		}
		
		public static function set LoadingPartsMode(v:Boolean):void
		{
			loadingPartsMode = v;
		}
		
		private function BuildCombinedMesh():void
		{
			var nowDate:Date = new Date();
			var checkDay:Number = nowDate.fullYear * 10000 + (nowDate.month + 1)*100 + nowDate.date;
			var checkTime:Number = nowDate.hours * 10000 + nowDate.minutes*100 + nowDate.seconds;
			combinedMesh = new L3DMesh();
			combinedMesh.Mode = 31;
			combinedMesh.catalog = 31;
			combinedMesh.Code = "LJ" + checkDay.toString() + checkTime.toString();
			combinedMesh.Name = name == null || name.length == 0 ? "窗帘" : name;
			scene.addChild(combinedMesh);
			combinedMesh.moduleCode = code;
			combinedMesh.Mode = 31;
			combinedMesh.WindowLength = windowLength;
			combinedMesh.WindowHeight = windowHeight;
			combinedMesh.MaxWindowLength = maxWindowLength;
			combinedMesh.MinWindowLength = minWindowLength;
			combinedMesh.MaxWindowHeight = maxWindowHeight;
			combinedMesh.MinWindowHeight = minWindowHeight;
			combinedMesh.x = 0;
			combinedMesh.y = 0;
			combinedMesh.z = 0;
			combinedMesh.scaleX = 1;
			combinedMesh.scaleY = 1;
			combinedMesh.scaleZ = 1;
			combinedMesh.rotationX = 0;
			combinedMesh.rotationY = 0;
			combinedMesh.rotationZ = 0;
			combinedMesh.matrix.identity();
			if(stage3D != null)
			{
			    UploadResources(combinedMesh, stage3D.context3D);
			}
		}
		
		public function get Exist():Boolean
		{
			if(code != null && code.length > 0)
			{
				if(name != null && name.length > 0)
				{
					if(mainClothCode != null && mainClothCode.length > 0)
					{
						if(mainClothName != null && mainClothName.length > 0)
						{
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public static function get Server():Object
		{
			return L3DLibrary.L3DLibraryWebService.LibraryService;
		}
		
		public function get CombinedMesh():L3DMesh
		{
			return combinedMesh;
		}
		
		public function get Scene():Object3D
		{
			return scene;
		}
		
		public function set Scene(v:Object3D):void
		{
			scene = v;
		}
		
		public function get SceneStage3D():Stage3D
		{
			return stage3D;
		}
		
		public function set SceneStage3D(v:Stage3D):void
		{
			stage3D = v;
		}
		
		public function get WindowLength():int
		{
			return windowLength;
		}
		
		public function set WindowLength(v:int):void
		{
			if(v > 10000 || v < 500)
			{
				return;
			}
			windowLength = v;
            if(combinedMesh != null)
			{
				combinedMesh.WindowLength = v;
			}
		}
		
		public function get WindowHeight():int
		{
			return windowHeight;
		}
		
		public function set WindowHeight(v:int):void
		{
			if(v > 6000 || v < 500)
			{
				return;
			}
			windowHeight = v;
			if(combinedMesh != null)
			{
				combinedMesh.WindowHeight = v;
			}
		}
		
		public function get MinWindowLength():int
		{
			return minWindowLength;
		}
		
		public function set MinWindowLength(v:int):void
		{
			minWindowLength = v;
			if(combinedMesh != null)
			{
				combinedMesh.MinWindowLength = v;
			}
		}
		
		public function get MaxWindowLength():int
		{
			return maxWindowLength;
		}
		
		public function set MaxWindowLength(v:int):void
		{
			maxWindowLength = v;
			if(combinedMesh != null)
			{
				combinedMesh.MaxWindowLength = v;
			}
		}
		
		public function get MinWindowHeight():int
		{
			return minWindowHeight;
		}
		
		public function set MinWindowHeight(v:int):void
		{
			minWindowHeight = v;
			if(combinedMesh != null)
			{
				combinedMesh.MinWindowHeight = v;
			}
		}
		
		public function get MaxWindowHeight():int
		{
			return maxWindowHeight;
		}
		
		public function set MaxWindowHeight(v:int):void
		{
			maxWindowHeight = v;
			if(combinedMesh != null)
			{
				combinedMesh.MaxWindowHeight = v;
			}
		}
		
		public function get CurrentSubsetIndex():int
		{
			return currentSubsetIndex;
		}
		
		public function get Preview():BitmapData
		{
			return preview;
		}
		
		public function set Preview(v:BitmapData):void
		{
			if(preview != null)
			{
				preview.dispose();
				preview = null;
			}
			
			preview = v;
		}
		
		public function get PreviewBuffer():ByteArray
		{
			if(previewBuffer != null)
			{
				previewBuffer.length = 0;
				previewBuffer = null;
			}
			
			if(preview != null)
			{
				previewBuffer = L3DMaterial.BitmapDataToBuffer(preview);				
			}
			
			return previewBuffer;
		}
		
		public function LoadPreview():void
		{
			if(previewBuffer == null || previewBuffer.length == 0)
			{
				return;
			}
			
			var loader:Loader = new Loader();
			loader.loadBytes(previewBuffer);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderPreviewBitmapComplete);	
		}
		
		private function loaderPreviewBitmapComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			Preview = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			Preview.draw(loaderInfo.loader);	
			
			if(Preview == null)
			{
				return;
			}
			
			var evt:Event = new Event(LoadModulePreview);
			this.dispatchEvent(evt);
		}
		
		public function Dispose():void
		{
			if(preview != null)
			{
				preview.dispose();
				preview = null;
			}
		}
		
		public function AddPart(partMesh:L3DMesh):Boolean
		{
			ClearSelections();
			
			if(partMesh == null || partMesh.caculation == null || !partMesh.caculation.Exist)
			{
				return false;
			}
			
			var checkCode:String = partMesh.caculation.PartCode;
			
			for each(var caculation:L3DPartCaculation in caculations)
			{
				if(!caculation.Exist)
				{
					continue;
				}
				if(checkCode == caculation.PartCode)
				{
					var hasSameCode:Boolean = false;
					do
					{
						checkCode+="*";
						hasSameCode = false;
						for(var i:int = 0; i<caculations.length; i++)
						{
							if(caculations[i] == partMesh.caculation || caculations[i] == caculation)
							{
								continue;
							}
							if(checkCode == caculations[i].PartCode)
							{
								hasSameCode = true;
								break;
							}
						}
					}while(hasSameCode);
					partMesh.Code = checkCode;
					partMesh.caculation.PartCode = checkCode;
				//	return false;
				}
			}
			
			combinedMesh.addChild(partMesh);
			partMesh.caculation.CombinedMesh = combinedMesh;
			partMesh.WindowLength = combinedMesh.WindowLength;
			partMesh.WindowHeight = combinedMesh.WindowHeight;
			partMesh.MaxWindowLength = combinedMesh.MaxWindowLength;
			partMesh.MinWindowLength = combinedMesh.MinWindowLength;
			partMesh.MaxWindowHeight = combinedMesh.MaxWindowHeight;
			partMesh.MinWindowHeight = combinedMesh.MinWindowHeight;
			caculations.push(partMesh.caculation);
			
			partMesh.ShowBoundBox = true;
			
            return true;
		}
		
		public function RemovePart(caculation:L3DPartCaculation):Boolean
		{
			if(caculation == null || !caculation.Exist || caculation.IsArraiedPart)
			{
				return false;
			}
			
			var index:int = -1;
			for(var i:int = 0; i<caculations.length;i++)
			{
				if(caculations[i].PartCode == caculation.PartCode)
				{
					index = i;
					break;
				}
			}
			
			if(index < 0)
			{
				return false;
			}
			
			caculations.removeAt(index);
			
			combinedMesh.removeChild(caculation.PartMesh);
			
			for(i = caculation.ArrayPartIDs.length - 1;i>=0;i--)
			{
				var arrayPartID:String = caculation.ArrayPartIDs[i];
				if(arrayPartID != null && arrayPartID.length > 0)
				{
					var arrMesh:L3DMesh = null;
					for(var j:int = 0;j<combinedMesh.numChildren;j++)
					{
						var subObject:Object3D = combinedMesh.getChildAt(j);
						if(subObject != null && subObject is L3DMesh)
						{
							if(arrayPartID == (subObject as L3DMesh).UniqueID)
							{
								arrMesh = subObject as L3DMesh;
								break;
							}
						}
					}
					if(arrMesh != null)
					{
						combinedMesh.removeChild(arrMesh);
						arrMesh.Dispose();
					}
				}
			}
			
			caculation.PartMesh.Dispose();
			caculation.PartMesh = null;
			
			return true;
		}
		
		public function ReplacePart(caculation:L3DPartCaculation, vmodel:L3DModel):Boolean
		{
			if(caculation == null || !caculation.Exist || caculation.IsArraiedPart || combinedMesh == null || vmodel == null || !vmodel.Exist)
			{
				return false;
			}
			
			var mesh:L3DMesh = vmodel.Export(stage3D, true, false);
			if(mesh == null)
			{
				vmodel.Clear();
				return false;
			}
			
			switch(vmodel.Version)
			{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				{
					mesh.caculation.FromBufferVersionD(caculation.ToBuffer());
				}
					break;
				default:
				{
					mesh.caculation.FromBuffer(caculation.ToBuffer());
				}
					break;
			}
	//		mesh.caculation.FromBuffer(caculation.ToBuffer());
			mesh.caculation.PartMesh = mesh;
			mesh.Length = caculation.PartMesh.Length;
			mesh.Width = caculation.PartMesh.Width;
			mesh.Height = caculation.PartMesh.Height;
			mesh.x = caculation.PartMesh.x;
			mesh.y = caculation.PartMesh.y;
			mesh.z = caculation.PartMesh.z;
			mesh.caculation.CombinedMesh = combinedMesh;
			mesh.layer = caculation.Layer;
			
			var arrSize:Vector3D = new Vector3D(mesh.Length, mesh.Width, mesh.Height);
			
			combinedMesh.addChild(mesh);
			caculations.push(mesh.caculation);
			
			for(var i:int = caculation.ArrayPartIDs.length - 1;i>=0;i--)
			{
				var arrayPartID:String = caculation.ArrayPartIDs[i];
				if(arrayPartID != null && arrayPartID.length > 0)
				{
					var arrMesh:L3DMesh = null;
					for(var j:int = 0;j<combinedMesh.numChildren;j++)
					{
						var subObject:Object3D = combinedMesh.getChildAt(j);
						if(subObject != null && subObject is L3DMesh)
						{
							if(arrayPartID == (subObject as L3DMesh).UniqueID)
							{
								arrMesh = subObject as L3DMesh;
								break;
							}
						}
					}
					if(arrMesh != null)
					{
						var vmesh:L3DMesh = vmodel.Export(stage3D);
						if(vmesh == null)
						{
							vmodel.Clear();
							return false;
						}
						
						vmesh.caculation.FromBuffer(arrMesh.caculation.ToBuffer());
						vmesh.caculation.PartMesh = vmesh;
						vmesh.Length = arrSize.x;
						vmesh.Width = arrSize.y;
						vmesh.Height = arrSize.z;
						vmesh.x = arrMesh.x;
						vmesh.y = arrMesh.y;
						vmesh.z = arrMesh.z;
						vmesh.caculation.CombinedMesh = combinedMesh;
						vmesh.layer = caculation.Layer;	
						if(arrMesh.IsMirrored)
						{							
							vmesh.Mirror(Vector3D.X_AXIS);
							vmesh.Align(3);
							vmesh.mirror = true;
							if(stage3D != null)
							{
							    UploadResources(vmesh, stage3D.context3D);
							}
							vmesh.Length = arrSize.x;
							vmesh.Width = arrSize.y;
							vmesh.Height = arrSize.z;
							vmesh.x = arrMesh.x;
							vmesh.y = arrMesh.y;
							vmesh.z = arrMesh.z;
						}
						combinedMesh.addChild(vmesh);
						mesh.caculation.ArrayPartIDs.push(vmesh.UniqueID);
					}
				}
			}
			
			RemovePart(caculation);
			
			combinedMesh.AutoAmendLayers();
			AmendParamCurtain();
			
			vmodel.Clear();
			return true;
		}
		
		public function ClearParts():void
		{
			if(combinedMesh == null)
			{
				return;
			}
			
			for(var i:int = combinedMesh.numChildren - 1;i>=0;i--)
			{
				var obj:Object3D = combinedMesh.getChildAt(i);
				if(obj == null || !(obj is Mesh))
				{
					continue;
				}
				combinedMesh.removeChild(obj);
				if(obj is L3DMesh)
				{
					(obj as L3DMesh).Dispose();
				}
			}
			
			var length:int = caculations.length;
			for(i = 0;i< length;i++)
			{
				caculations.pop();
			}
		}
		
		public function GetCurrentCaculation3D(camera:Camera3D, x:Number, y:Number):L3DPartCaculation
		{
			ClearSelections();
			if(combinedMesh == null)
			{
				return null;
			}
			var index:int = GetCurrentMeshIndex(camera,x,y);
			if(index < 0 || index >= combinedMesh.numChildren)
			{
				return null;
			}
			var caculation:L3DPartCaculation = GetSelectedCaculation(index);
			if(caculation == null)
			{
				return null;
			}
			var mesh:L3DMesh = caculation.PartMesh;
			if(mesh == null)
			{
				return caculation;
			}
			mesh.ShowBoundBox = true;
			return caculation;
		}
		
		public function GetCurrentCaculation2D(origin:Vector3D, direction:Vector3D):L3DPartCaculation
		{
			ClearSelections();
			if(combinedMesh == null)
			{
				return null;
			}
			
			direction.normalize();
			
			for(var i:int = 10;i>=0;i--)
			{
			    for(var j:int = 0;j< combinedMesh.numChildren;j++)
			    {
			    	var subObject:Object3D = combinedMesh.getChildAt(j);
			    	if(subObject is L3DMesh && subObject.boundBox != null)
			    	{
			    		var subMesh:L3DMesh = subObject as L3DMesh;
						if(subMesh.layer != i)
						{
							continue;
						}
			    		var subOrigin:Vector3D = subMesh.globalToLocal(origin);
			    		if(subMesh.boundBox.intersectRay(subOrigin, direction))
				    	{
							var checkCode:String = subMesh.Code.toUpperCase();
							for each(var caculation:L3DPartCaculation in caculations)
							{
								if(!caculation.Exist)
								{
									continue;
								}
								if(checkCode == caculation.PartCode.toUpperCase())
								{
									if(caculation.PartMesh != null)
									{
										caculation.PartMesh.ShowBoundBox = true;
										for(var k:int=0;k<subMesh.numChildren;k++)
										{
											var inSubObject:Object3D = subMesh.getChildAt(k);
											if(inSubObject != null && inSubObject is L3DMesh)
											{
												var inSubMesh:L3DMesh = inSubObject as L3DMesh;
												var inSubOrigin:Vector3D = inSubMesh.globalToLocal(origin);
												if(inSubMesh.boundBox == null)
												{
													inSubMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(inSubMesh);
												}
												if(inSubMesh.boundBox.intersectRay(inSubOrigin, direction))
												{
													currentSubsetIndex = k;
													break;
												}
											}
										}
									}
									return caculation;
								}
							}
				    	}
				    }
		    	}
			}

			return null;
		}

		public function ClearSelections():void
		{
			if(combinedMesh == null)
			{
				return;
			}
			
			for(var i:int = 0;i<combinedMesh.numChildren;i++)
			{
				var obj:Object3D = combinedMesh.getChildAt(i);
				if(obj == null || !(obj is L3DMesh))
				{
					continue;
				}
				(obj as L3DMesh).ShowBoundBox = false;
			}
			
			currentIndex = -1;
            currentSubsetIndex = -1;
		}
		
		private function GetCurrentMeshIndex(camera:Camera3D, x:Number, y:Number):int
		{
			if(scene == null || camera == null || stage3D == null)
			{
				return -1;
			}
			
			if(combinedMesh == null)
			{
				return -1;
			}
			
			var cameraRenderToBitmap:Boolean = camera.view.renderToBitmap;
			
			var pickingColors:Vector.<uint> = new Vector.<uint>();
			var pickingIndices:Vector.<int> = new Vector.<int>();
			var pickingSubsetIndices:Vector.<int> = new Vector.<int>();
			var originalMaterials:Vector.<Material> = new Vector.<Material>();
			var originalBackColor:uint = camera.view.backgroundColor;
			camera.view.backgroundColor = 0x000000;
			var pickingColor:uint = 0x000001;
			
			var subObject:Object3D;
			var subMesh:L3DMesh;
			var subset:Object3D;
			var mesh:Mesh;
			for(var i:int = 0;i< combinedMesh.numChildren;i++)
			{
				subObject = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					subMesh = subObject as L3DMesh;
					for(var j:int = 0;j< subMesh.numChildren;j++)
					{
						subset = subMesh.getChildAt(j);
						if(subset != null && subset is Mesh)
						{
							mesh = subset as Mesh;
							originalMaterials.push(mesh.getSurface(0).material);
							mesh.getSurface(0).material = new FillMaterial(pickingColor, 1.0);
							pickingColors.push(pickingColor);
							pickingIndices.push(i);
							pickingSubsetIndices.push(j);
							pickingColor++;
						}
					}
				}
			}
			
			camera.render(stage3D);
			
			var pickingIndex:int = -1;
			if(camera.view.canvas != null)
			{
				var viewColor:uint = camera.view.canvas.getPixel(x, y);
				var index:int = pickingColors.indexOf(viewColor);
				if(index >= 0 && index < pickingColors.length)
				{
					pickingIndex = pickingIndices[index];
					currentSubsetIndex = pickingSubsetIndices[index];
				}
			}
			
			var count:int = 0;
			for(i = 0;i< combinedMesh.numChildren;i++)
			{
				subObject = combinedMesh.getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					subMesh = subObject as L3DMesh;
					for(j = 0;j< subMesh.numChildren;j++)
					{
						subset = subMesh.getChildAt(j);
						if(subset != null && subset is Mesh)
						{
							mesh = subset as Mesh;
							mesh.getSurface(0).material = originalMaterials[count];
							count++;	
						}
					}
				}
			}
			
			if(pickingIndex >= 0 && pickingIndex < combinedMesh.numChildren)
			{
				subObject = combinedMesh.getChildAt(pickingIndex);
				if(subObject != null && subObject is L3DMesh)
				{
					subMesh = subObject as L3DMesh;
					if(subMesh.boundBox == null)
					{
						subMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(subMesh);
					}
				}
			}
			
			camera.view.backgroundColor = originalBackColor;
			
			return pickingIndex;
		}
		
		private function GetSelectedPartMesh(meshIndex:int):L3DMesh
		{
			var caculation:L3DPartCaculation = GetSelectedCaculation(meshIndex);
			if(caculation == null)
			{
				return null;
			}
			return caculation.PartMesh;
		}
		
		private function GetSelectedCaculation(meshIndex:int):L3DPartCaculation
		{
			if(combinedMesh == null)
			{
				return null;
			}
			
			if(meshIndex < 0 || meshIndex >= combinedMesh.numChildren)
			{
				return null;
			}
			
			var subObject:Object3D = combinedMesh.getChildAt(meshIndex);
			if(subObject == null || !(subObject is L3DMesh))
			{
				return null;
			}
			
			var partMesh:L3DMesh = subObject as L3DMesh;
			if(partMesh.Code == null || partMesh.Code.length == 0)
			{
				return null;
			}
			
            var checkCode:String = partMesh.Code.toUpperCase();
			
			for each(var caculation:L3DPartCaculation in caculations)
			{
				if(!caculation.Exist)
				{
					continue;
				}
				if(checkCode == caculation.PartCode.toUpperCase())
				{
					return caculation;
				}
			}
			
			return null;
		}
		
		public function AddCompleteFunction(fun:Function):Boolean
		{
			if(fun == null)
			{
				return false;
			}
			
			completeFun = fun;			
			
			return true;
		}
		
		private function SetMeshFullLengthSize(mesh:L3DMesh, length:int, height:int):int
		{
			if(mesh == null || length <= 0 || height <= 0)
			{
				return 0;
			}
			
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			var checkLength:Number = Math.abs(mesh.boundBox.maxX - mesh.boundBox.minX);
			if(checkLength > 1000)
			{
				return 1;
			}
			
			var num:Number = Number(length) / checkLength;
			if(num <= 1.0)
			{	
				return 1;
			}	
			
			var count:Number = num > int(num) ? Number(int(num)) + 1:num;
			var amendLength:Number = Number(length) / count;
			
			mesh.scaleX = Number(amendLength) / Math.abs(mesh.boundBox.maxX - mesh.boundBox.minX);
			mesh.scaleZ = Number(height) / Math.abs(mesh.boundBox.maxZ - mesh.boundBox.minZ);
			
			return int(count);
		}
		
		private function SetMeshSize(mesh:L3DMesh, length:int, height:int):Boolean
		{
			if(mesh == null || length <= 0 || height <= 0)
			{
				return false;
			}
			
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			mesh.scaleX = Number(length) / Math.abs(mesh.boundBox.maxX - mesh.boundBox.minX);
			mesh.scaleZ = Number(height) / Math.abs(mesh.boundBox.maxZ - mesh.boundBox.minZ);
			
			return true;
		}
		
		private function AmendMesh(mesh:L3DMesh):Boolean
		{
			if(mesh == null)
			{
				return false;
			}
			
			for(var i:int=0;i< mesh.numChildren;i++)
			{
				if(mesh.getChildAt(i) != null && mesh.getChildAt(i) is Mesh)
				{
					var subMesh:Mesh = mesh.getChildAt(i) as Mesh;
					for(var j:int=0;j< subMesh.numSurfaces;j++)
					{
						var surface:Surface = subMesh.getSurface(j);
						if(surface != null)
						{
							if(surface.material == null)
							{
								surface.material = new FillMaterial(0xFFFFFF);
							}
							else if(surface.material is StandardMaterial)
							{
								var	material:StandardMaterial = surface.material as StandardMaterial;
								if(material.lightMap == null)
								{
									surface.material = new TextureMaterial(material.diffuseMap, null, material.alpha);
									(surface.material as TextureMaterial).alphaThreshold = material.alphaThreshold;
								}
								else
								{
									surface.material = new LightMapMaterial(material.diffuseMap, material.lightMap, material.lightMapChannel);
									(surface.material as LightMapMaterial).alpha = material.alpha;
									(surface.material as LightMapMaterial).alphaThreshold = material.alphaThreshold;
								}
							}
						}
					}
				}
			}
			mesh.scaleX = 1;
			mesh.scaleY = 1;
			mesh.scaleZ = 1;
			mesh.rotationX = 0;
			mesh.rotationY = 0;
			mesh.rotationZ = 0;
			
			return true;
		}
		
		public function SetupLoadMeshCompleteFunction(fun:Function):Boolean
		{
			if(fun == null)
			{
				return false;
			}
			
			loadMeshCompleteFun = fun;
			return true;
		}		
		
		public function Load(code:String, mainClothCode:String, windowLength:int, windowHeight:int, editMode:Boolean = true):void
		{
			if(code == null || code.length == 0 || mainClothCode == null || mainClothCode.length == 0)
			{
				LivelyLibrary.ShowMessage("请输入方案编号及主布编号", 2);
				if(loadMeshCompleteFun != null)
				{
					loadMeshCompleteFun(null);
				}
				return;
			}
			
			loadingPartsMode = true;
			
			this.windowLength = windowLength;
			this.windowHeight = windowHeight;
			this.code = code;
			this.editMode = editMode;
			
//			var atObj:AsyncToken = Server.LoadCurtainProjectBuffer(code, mainClothCode);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(loadModuleResult, loadModuleFault);
//			atObj.addResponder(rpObj);

			 
			//zh 2018.8.17
			GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_LOADCURTAINPROJECTBUFFER,loadModuleResult,loadModuleFault,code,mainClothCode);
		}
		
		private function loadModuleResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				loadingPartsMode = false;
				if(loadMeshCompleteFun != null)
				{
					loadMeshCompleteFun(null);
				}
				return;
			}
			
			exportMode = true;
			FromBuffer(buffer, windowLength, windowHeight);
		}
		
		private function loadModuleFault(feObj:FaultEvent):void
		{
			loadingPartsMode = false;
			LivelyLibrary.ShowMessage(feObj.fault.toString(), 1);
			if(loadMeshCompleteFun != null)
			{
				loadMeshCompleteFun(null);
			}
		}
		
		public function Update(windowLength:int, windowHeight:int):Boolean
		{
			if(windowLength > 20000 || windowLength < 300 || windowHeight > 20000 || windowHeight < 300)
			{
				return false;
			}
			
			var buffer:ByteArray = ToBuffer();
			if(buffer == null || buffer.length == 0)
			{
				return false;
			}
			
			exportMode = false;
			
			return FromBuffer(buffer, windowLength, windowHeight);
		}
		
		public function ToBuffer():ByteArray
		{
			version = 2016001;
			description=LivelyLibrary.SceneBrand;
			var buffer:ByteArray = new ByteArray();
			L3DPartCaculation.WriteString(buffer, code);
			L3DPartCaculation.WriteString(buffer, name);
			L3DPartCaculation.WriteString(buffer, mainClothCode);
			L3DPartCaculation.WriteString(buffer, mainClothName);
			L3DPartCaculation.WriteString(buffer, author);
			L3DPartCaculation.WriteString(buffer, linkedData);
			L3DPartCaculation.WriteString(buffer, description);
			previewBuffer = PreviewBuffer;
			if(previewBuffer == null || previewBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(previewBuffer.length);
				buffer.writeBytes(previewBuffer,0,previewBuffer.length);
			}			
            buffer.writeInt(windowLength);
			buffer.writeInt(windowHeight);
			buffer.writeInt(minWindowLength);
			buffer.writeInt(maxWindowLength);
			buffer.writeInt(minWindowHeight);
			buffer.writeInt(maxWindowHeight);
			buffer.writeInt(version);
			buffer.writeInt(caculations.length);
			if(caculations.length > 0)
			{
				for(var i:int = 0;i<caculations.length;i++)
				{
					if(caculations[i] != null)
					{
						var caculationBuffer:ByteArray = caculations[i].ToBuffer();
						if(caculationBuffer == null || caculationBuffer.length == 0)
						{
							buffer.writeInt(0);
						}
						else
						{
							buffer.writeInt(caculationBuffer.length);
							buffer.writeBytes(caculationBuffer, 0, caculationBuffer.length);
						}						
					}
				}
			}
			
			return buffer;
		}
		
		public function FromBuffer(buffer:ByteArray, windowLength:int, windowHeight:int):Boolean
		{	
			if(buffer == null || buffer.length == 0 || stage3D == null || scene == null)
			{
				loadingPartsMode = false;
				if(loadMeshCompleteFun != null)
				{
					loadMeshCompleteFun(combinedMesh);
				}
				return false;
			}
			
			ClearParts();
			
			buffer.position = 0;
			
			code = L3DPartCaculation.ReadString(buffer);
			name = L3DPartCaculation.ReadString(buffer);
			mainClothCode = L3DPartCaculation.ReadString(buffer);
			mainClothName = L3DPartCaculation.ReadString(buffer);
			author = L3DPartCaculation.ReadString(buffer);
			linkedData = L3DPartCaculation.ReadString(buffer);
			description = L3DPartCaculation.ReadString(buffer);
			var count:int = buffer.readInt();
			if(count > 0)
			{
				previewBuffer = new ByteArray();
				buffer.readBytes(previewBuffer,0,count);
			}
			var epBuffer:ByteArray = L3DUtils.CloneByteArray(previewBuffer);
			this.windowLength = buffer.readInt();
			this.windowHeight = buffer.readInt();
			originWindowLength = this.windowLength;
			originWindowHeight = this.windowHeight;
			minWindowLength = buffer.readInt();
			maxWindowLength = buffer.readInt();
			minWindowHeight = buffer.readInt();
			maxWindowHeight = buffer.readInt();	
			while(caculations.length)
			{
				caculations.pop();
			}
			version = buffer.readInt();
			
			var i:int;
			var caculation:L3DPartCaculation;
			var bufferCount:int;
			var caculationBuffer:ByteArray
			
			switch(version)
			{
				case 0:
				{
					count = buffer.readInt();
					if(count > 0)
					{
						for(i = 0;i< count;i++)
						{
							bufferCount = buffer.readInt();
							if(bufferCount > 0)
							{
								caculationBuffer = new ByteArray();
								buffer.readBytes(caculationBuffer,0,bufferCount);
								if(caculationBuffer != null && caculationBuffer.length > 0)
								{
									caculation = new L3DPartCaculation(null, null);
									caculation.FromBufferVersionZ(caculationBuffer);
									caculation.WindowLength = this.windowLength;
									caculation.WindowHeight = this.windowHeight;
									caculation.MinWindowLength = minWindowLength;
									caculation.MaxWindowLength = maxWindowLength;
									caculation.MinWindowHeight = minWindowHeight;
									caculation.MaxWindowHeight = maxWindowHeight;
									caculations.push(caculation);
								}
							}
						}
					}
				}
					break;
				case 2016001:
				{
					count = buffer.readInt();
					if(count > 0)
					{
						for(i = 0;i< count;i++)
						{
							bufferCount = buffer.readInt();
							if(bufferCount > 0)
							{
								caculationBuffer = new ByteArray();
								buffer.readBytes(caculationBuffer,0,bufferCount);
								if(caculationBuffer != null && caculationBuffer.length > 0)
								{
									caculation = new L3DPartCaculation(null, null);
									caculation.FromBuffer(caculationBuffer);
									caculation.WindowLength = this.windowLength;
									caculation.WindowHeight = this.windowHeight;
									caculation.MinWindowLength = minWindowLength;
									caculation.MaxWindowLength = maxWindowLength;
									caculation.MinWindowHeight = minWindowHeight;
									caculation.MaxWindowHeight = maxWindowHeight;
									caculations.push(caculation);
								}
							}
						}
					}
				}
					break;
				default:
				{
					count = version;
					if(count > 0)
					{
						for(i = 0;i< count;i++)
						{
							bufferCount = buffer.readInt();
							if(bufferCount > 0)
							{
								caculationBuffer = new ByteArray();
								buffer.readBytes(caculationBuffer,0,bufferCount);
								if(caculationBuffer != null && caculationBuffer.length > 0)
								{
									caculation = new L3DPartCaculation(null, null);
									caculation.FromBufferVersionD(caculationBuffer);
									caculation.WindowLength = this.windowLength;
									caculation.WindowHeight = this.windowHeight;
									caculation.MinWindowLength = minWindowLength;
									caculation.MaxWindowLength = maxWindowLength;
									caculation.MinWindowHeight = minWindowHeight;
									caculation.MaxWindowHeight = maxWindowHeight;
									caculations.push(caculation);
								}
							}
						}
					}
				}
					break;
			}
			
			for(i = combinedMesh.numChildren - 1;i>=0;i--)
			{
				combinedMesh.removeChildAt(i);
			}
			
			combinedMesh.moduleCode = this.code;
			combinedMesh.Mode = 31;
			combinedMesh.WindowLength = this.windowLength;
			combinedMesh.WindowHeight = this.windowHeight;
			combinedMesh.MaxWindowLength = maxWindowLength;
			combinedMesh.MinWindowLength = minWindowLength;
			combinedMesh.MaxWindowHeight = maxWindowHeight;
			combinedMesh.MinWindowHeight = minWindowHeight;
			combinedMesh.x = 0;
			combinedMesh.y = 0;
			combinedMesh.z = 0;
			combinedMesh.scaleX = 1;
			combinedMesh.scaleY = 1;
			combinedMesh.scaleZ = 1;
			combinedMesh.rotationX = 0;
			combinedMesh.rotationY = 0;
			combinedMesh.rotationZ = 0;
			combinedMesh.matrix.identity();
			combinedMesh.Name = name == null || name.length == 0 ? "窗帘" : name;
			combinedMesh.PreviewBuffer = epBuffer;
			
			if(windowLength < 300 || windowHeight < 300)
			{
				loadingPartsMode = false;
				if(loadMeshCompleteFun != null)
				{
					loadMeshCompleteFun(combinedMesh);
				}
				return false;
			}
			
			this.windowLength = windowLength;
			this.windowHeight = windowHeight;
			combinedMesh.WindowLength = windowLength;
			combinedMesh.WindowHeight = windowHeight;
			
			for(i = 0;i< caculations.length;i++)
			{
				caculation = caculations[i];
				caculation.WindowLength = windowLength;
				caculation.WindowHeight = windowHeight;				
			}
			
			if(caculations.length > 0)
			{
				currentLoadCaculationIndex = 0;
				caculations[currentLoadCaculationIndex].SetupLoadFunction(loadCaculationComplete);
				caculations[currentLoadCaculationIndex].LoadPartModel(this, stage3D);
			}
			
			return true;
		}
		
		private function loadCaculationComplete(caculation:L3DPartCaculation):void
		{
			if(caculation != null)
			{
				caculation.ClearLoadFunction();
			}
			currentLoadCaculationIndex++;
			if(currentLoadCaculationIndex < caculations.length)
			{
				caculations[currentLoadCaculationIndex].SetupLoadFunction(loadCaculationComplete);
				caculations[currentLoadCaculationIndex].LoadPartModel(this, stage3D);
			}
			else
			{
				AutoMakeCombintions();
			}
		}
		
		private function AutoMakeCombintions():void
		{
			if(caculations.length == 0)
			{
				loadingPartsMode = false;
				return;
			}
			
			var currentReferenceCaculation:L3DPartCaculation = null;
			var currentReferenceCheckArrayCount:int = 0;
			var currentReferenceActuallyArrayCount:int = 0;
			var caculation:L3DPartCaculation;
			for(var i:int = 0;i < caculations.length;i++)
			{
				caculation = caculations[i];
				if(caculation == null || !caculation.Exist)
				{
					continue;
				}
				if(caculation.ArrayMode == L3DPartArrayMode.FullArray)
				{
					if(caculation.InnerArrayCount == 0 && caculation.InnerActuallyArrayCount > 0)
					{
						if(currentReferenceCaculation == null || caculation.InnerActuallyArrayCount > currentReferenceCaculation.InnerActuallyArrayCount)
						{
							currentReferenceCaculation = caculation;
						}
					}
				}
			}
			
			if(currentReferenceCaculation != null)
			{
				currentReferenceCheckArrayCount = currentReferenceCaculation.InnerActuallyArrayCount;
				currentReferenceCaculation.PartMesh.x = currentReferenceCaculation.X + originWindowLength / 2 - windowLength / 2;
				currentReferenceCaculation.BeginArray(currentReferenceCaculation.ArrayMode,0,currentReferenceCaculation.InnerArraySpace, stage3D);
				currentReferenceCaculation.MakeCombintion();
				if(currentReferenceCaculation.InnerActuallyArrayCount == 0)
				{
					currentReferenceCaculation = null;
					currentReferenceCheckArrayCount = 0;
					currentReferenceActuallyArrayCount = 0;
				}
				else
				{
					currentReferenceActuallyArrayCount = currentReferenceCaculation.InnerActuallyArrayCount;
				}
			}
			
            if(currentReferenceCaculation == null)
			{
				for(i = 0;i < caculations.length;i++)
				{
					caculation = caculations[i];
					if(caculation == null || !caculation.Exist)
					{
						continue;
					}
					if(caculation.ArrayMode == L3DPartArrayMode.FullArray)
					{
						if(caculation.InnerActuallyArrayCount > 0)
						{
							if(currentReferenceCaculation == null || caculation.InnerActuallyArrayCount > currentReferenceCaculation.InnerActuallyArrayCount)
							{
								currentReferenceCaculation = caculation;
							}
						}
					}
				}
				
				if(currentReferenceCaculation != null)
				{
					currentReferenceCheckArrayCount = currentReferenceCaculation.InnerActuallyArrayCount;
					currentReferenceCaculation.PartMesh.x = currentReferenceCaculation.X + originWindowLength / 2 - windowLength / 2;
					currentReferenceCaculation.BeginArray(currentReferenceCaculation.ArrayMode,-1,currentReferenceCaculation.InnerArraySpace, stage3D);
					currentReferenceCaculation.MakeCombintion();
					if(currentReferenceCaculation.InnerActuallyArrayCount == 0)
					{
						currentReferenceCaculation = null;
						currentReferenceCheckArrayCount = 0;
						currentReferenceActuallyArrayCount = 0;
					}
					else
					{
						currentReferenceActuallyArrayCount = currentReferenceCaculation.InnerActuallyArrayCount;
					}
				}
			}			
			
			for(i = 0;i<caculations.length;i++)
			{
				caculation = caculations[i];
				if(caculation == null || !caculation.Exist || caculation.HadMadeCombintion)
				{
					continue;
				}
				if(caculation == currentReferenceCaculation)
				{
					continue;
				}
				switch(caculation.ArrayMode)
				{
					case L3DPartArrayMode.None:
					{
						if(Math.abs(caculation.PartMesh.x) < 50)
						{
							caculation.PartMesh.x = 0;
							caculation.SideOffDistance = windowLength / 2 - caculation.Width / 2;
						}
						else
						{
							var cl:Number = caculation.X - caculation.Width / 2 + originWindowLength / 2;
							var cr:Number = originWindowLength / 2 - caculation.X - caculation.Width / 2;
							var cw:Number = windowLength - cl - cr;
							if(cw >= 100)
							{
								caculation.Width = cw;
								caculation.SideOffDistance = cl;								
							}
							else
							{
								caculation.PartMesh.x = 0;
								caculation.SideOffDistance = windowLength / 2 - caculation.Width / 2;
							}
						}
					}
						break;
					case L3DPartArrayMode.Attaching:
					{
						caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;
						continue;
					}
						break;
					case L3DPartArrayMode.AutoArray:
					{
						caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;					
						caculation.BeginArray(caculation.ArrayMode, caculation.InnerArrayCount > 0 ? -1 : 0, 0, stage3D);
					}
						break;
					case L3DPartArrayMode.FullArray:
					{
						caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;
						if(caculation.InnerArrayCount == 0)
						{
							caculation.BeginArray(caculation.ArrayMode, 0, caculation.InnerArraySpace, stage3D);
						}
						else if(currentReferenceCaculation != null)
						{
							var arrayCount:int = caculation.InnerActuallyArrayCount - currentReferenceCheckArrayCount + currentReferenceActuallyArrayCount;
							if(arrayCount > 0)
							{
								caculation.BeginArray(caculation.ArrayMode, arrayCount, caculation.InnerArraySpace, stage3D);
							}
						}
						else
						{
							caculation.BeginArray(caculation.ArrayMode, -1, caculation.InnerArraySpace, stage3D);
						}
					}
						break;
					case L3DPartArrayMode.SideArray:
					{
						caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;
						caculation.BeginArray(caculation.ArrayMode, 0, 0, stage3D);
					}
						break;
					case L3DPartArrayMode.LeftLianshen:
					case L3DPartArrayMode.RightLianshen:
					case L3DPartArrayMode.BothSideLianshen:
					case L3DPartArrayMode.Guagan:
					{
						caculation.PartMesh.x = 0;
						caculation.BeginArray(caculation.ArrayMode, 0, 0, stage3D);
					}
						break;
					case L3DPartArrayMode.AutoSide:
					{
						caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;					
						caculation.BeginArray(caculation.ArrayMode, caculation.InnerArrayCount > 0 ? -1 : 0, 0, stage3D);
					}
						break;
					default:
					{
				//		caculation.PartMesh.x = caculation.X + originWindowLength / 2 - windowLength / 2;
						caculation.BeginArray(caculation.ArrayMode, 0, 0, stage3D);
					}
						break;
				}				
			}
			
			combinedMesh.AutoAmendLayers();
			combinedMesh.BuildBoundBox();
			
			if(exportMode)
			{
				combinedMesh.scaleX = 1;
				combinedMesh.scaleY = 1;
				combinedMesh.scaleZ = 1;
				var combinedThickness:Number = (combinedMesh.boundBox.maxY - combinedMesh.boundBox.minY);
				if(combinedThickness > L3DPartCaculation.MaxThickness)
				{
					combinedMesh.scaleY = L3DPartCaculation.MaxThickness / combinedThickness;
				}
			}
			else
			{
			    combinedMesh.scaleX = L3DPartCaculation.Scale2D;
			    combinedMesh.scaleY = L3DPartCaculation.ThicknessScale;
			    combinedMesh.scaleZ = L3DPartCaculation.Scale2D;
			}
			
			for(i=0;i<combinedMesh.numChildren;i++)
			{
				var subObject:Object3D = combinedMesh.getChildAt(i);
				if(subObject is L3DMesh)
				{
					(subObject as L3DMesh).visible = true;
				}
			}
			
			if(!editMode)
			{
				while(caculations.length)
				{
					caculations.pop();
				}
			}
			
			AmendParamCurtain();
			
			loadingPartsMode = false;
			
			if(loadMeshCompleteFun != null)
			{
				loadMeshCompleteFun(combinedMesh);
			}
		}
		
		public function AmendParamCurtain():Boolean
		{
			if(combinedMesh == null)
			{
				return false;
			}
			
			var subObject:Object3D;
			var subMesh:L3DMesh;
			for(var i:int = 0; i<combinedMesh.numChildren;i++)
			{
				subObject = combinedMesh.getChildAt(i);
				if(subObject == null || !(subObject is L3DMesh))
				{
					continue;
				}
				subMesh = subObject as L3DMesh;
				if(subMesh.caculation == null || subMesh.caculation.IsArraiedPart)
				{
					continue;
				}
				for(var j:int = 0; j < combinedMesh.numChildren; j++)
				{
					if(i == j)
					{
						continue;
					}
					var jsubObject:Object3D = combinedMesh.getChildAt(j);
					if(jsubObject == null || !(jsubObject is L3DMesh))
					{
						continue;
					}
					var jsubMesh:L3DMesh = jsubObject as L3DMesh;
					if(jsubMesh.caculation == null)
					{
						continue;
					}
					if(jsubMesh.Code.toUpperCase() != subMesh.Code.toUpperCase())
					{
						continue;
					}
					for(var k:int=0;k<subMesh.numChildren;k++)
					{
						var ksubObject:Object3D = subMesh.getChildAt(k);
						if(ksubObject == null || !(ksubObject is L3DMesh))
						{
							continue;
						}
						if(jsubMesh.getChildAt(k) == null || !(jsubMesh.getChildAt(k) is L3DMesh) || (jsubMesh.getChildAt(k) as L3DMesh).numSurfaces == 0)
						{
							continue;
						}
						var ksubMesh:L3DMesh = ksubObject as L3DMesh;
						var ksubMaterial:Material = ksubMesh.getSurface(0).material;
						var ksubMaterialSize:String = ksubMesh.MaterialSize;
						if((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material == ksubMaterial)
						{
							continue;
						}
						if((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material is LightMapMaterial)
						{
							if(((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).diffuseMap != null)
							{
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).diffuseMap.dispose();
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).diffuseMap = null;
							}
							if(((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).lightMap != null)
							{
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).lightMap.dispose();
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as LightMapMaterial).lightMap = null;
							}
						}
						else if((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material is TextureMaterial)
						{
							if(((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).diffuseMap != null)
							{
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).diffuseMap.dispose();
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).diffuseMap = null;
							}
							if(((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).opacityMap != null)
							{
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).opacityMap.dispose();
								((jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material as TextureMaterial).opacityMap = null;
							}
						}
						(jsubMesh.getChildAt(k) as L3DMesh).getSurface(0).material = ksubMaterial;
						(jsubMesh.getChildAt(k) as L3DMesh).MaterialSize = ksubMaterialSize;
					}
				}
			}
			
			for(i = 0; i<combinedMesh.numChildren;i++)
			{
				subObject = combinedMesh.getChildAt(i);
				if(subObject == null || !(subObject is L3DMesh))
				{
					continue;
				}
				subMesh = subObject as L3DMesh;
				for(j = 0; j<subMesh.numChildren;j++)
				{
					var isubObject:Object3D = subMesh.getChildAt(j);
					if(isubObject == null || !(isubObject is L3DMesh))
					{
						continue;
					}
					var isubMesh:L3DMesh = isubObject as L3DMesh;
					isubMesh.AutoAmendSizeForMaterialSize(stage3D);
				}
			}
			
			return true;
		}
		
		public static function LoadDetailFromBuffer(buffer:ByteArray):Object
		{	
			if(buffer == null || buffer.length == 0)
			{
                return null;
			}

			buffer.position = 0;
			
			var code:String = L3DPartCaculation.ReadString(buffer);
			var name:String = L3DPartCaculation.ReadString(buffer);
			var mainClothCode:String = L3DPartCaculation.ReadString(buffer);
			var mainClothName:String = L3DPartCaculation.ReadString(buffer);
			var author:String = L3DPartCaculation.ReadString(buffer);
			var linkedData:String = L3DPartCaculation.ReadString(buffer);
			var description:String = L3DPartCaculation.ReadString(buffer);
			var previewBuffer:ByteArray = null;
			var count:int = buffer.readInt();
			if(count > 0)
			{
				previewBuffer = new ByteArray();
				buffer.readBytes(previewBuffer,0,count);
			}
			
			var export:Object = {};
			export.code = code;
			export.name = name;
			export.mainClothCode = mainClothCode;
			export.mainClothName = mainClothName;
			export.author = author;
			export.linkedData = linkedData;
			export.description = description;
			export.previewBuffer = previewBuffer;
			
			return export;
		}
		
		private static function UploadResources(object:Object3D, context:Context3D):void
		{
			for each (var res:Resource in object.getResources(true))
			{
				res.upload(context);
			}
		}
	}
}
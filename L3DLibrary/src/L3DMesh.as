package
{
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.utils.UIDUtil;
	
	import L3DLibrary.LivelyLibrary;
	
	import Parts.L3DPartCaculation;
	
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import alternativa.engine3d.utils.Object3DUtils;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.singles.CL3DModuleUtil;
	
	public class L3DMesh extends Mesh
	{
		private var previewBuffer:ByteArray;
		private var length:int = 0;
		private var width:int = 0;
		private var height:int = 0;
		private var offGround:int = 0;
		private var offBoard:int = 0;
		private var modelName:String;
		private var code:String;
		private var erpCode:String;
		private var brand:String;
		private var series:String;
		private var place:String;
		private var price:Number = 0;
		private var version:int = 0;
		private var mode:int = 0;
		private var materialMode:int = 0;
		private var isLight:Boolean = false;
		private var lightMode:int = 0; //0: PointLight 1: BodyLight
		private var lightWattage:int = 50;
		private var lightColor:uint = 0xFFFFFF;
		private var haveOriginalTransparencyMaps:Array = [];
		private var boundBoxLines:Array;
		private var showBoundBox:Boolean = false;
		private var showHighLight:Boolean = false;
		private var showTexHighLight:Boolean = false;
		private var uniqueID:String = "";
		private var windowLength:int = 2000;
		private var windowHeight:int = 2000;
		private var minWindowLength:int = 1500;
		private var maxWindowLength:int = 6000;
		private var minWindowHeight:int = 2000;
		private var maxWindowHeight:int = 4500;
		private var materialCode:String = "";
		private var materialSize:String = "";
		public var moduleCode:String = "";
		public var moduleName:String = "";
		public var exportNormals:Boolean = false;
		public var layer:int = 0;
		public var caculation:L3DPartCaculation = null;
		public var url:String = "";
		public var catalog:int = 0;
		public var info:String = "";
		public var info2:String = "";
		public var family:String = "";
		public var compuValue:Number = 0;
		public var checkPoint:Vector3D = new Vector3D();
		public var mirror:Boolean = false;
		public var paramLength1:Number = 0;
		public var paramLength2:Number = 0;
		private var minPosition:Vector3D = new Vector3D();
		private var maxPosition:Vector3D = new Vector3D();
		private var deltaLayThickness:Number = 30;
		private var originalUVs:Vector.<Number> = new Vector.<Number>();
		public var isPolyMode:Boolean = false;
		public var parentObject:Object = null;
		public var grandParentObject:Object = null;
		public var linkedObject:Object = null;
		public var linkedData:* = null;
		public var editData:* = null;
		public var userData2:* = null;
		public var userData3:* = null;
		public var userData4:* = null;
		public var userData5:* = null;
		public var userData6:* = null;
		public var userData7:* = null;
		public var paramDoorWindowData:*;
		public var userType:int = 0;
		public var userHighLightFactor:int = 0;
		public var userReflectionFactor:int = 0;
		private var highLightBakMaterials:Vector.<Material> = new Vector.<Material>();
		private var texHighLightBakData:* = null;
		protected var _className:String;
		public var iesData:* = null;
		public var isCDMesh:Boolean = false;
		private static var isOnComputing:Boolean = false;
		public static const HighLightColor:uint = 0x77EFFE;
		public static const LOADCOMPLETE:String = "LoadComplete";		
		
		public function L3DMesh(className:String=CL3DConstDict.CLASSNAME_L3DMESH)
		{
			super();
			_className=className;
			matrix.identity();
			caculation = new L3DPartCaculation(this,null);
		}
		
		public function Clear():void
		{
			if(previewBuffer != null)
			{
				previewBuffer.clear();
				previewBuffer = null;
			}			
			length = 0;
			width = 0;
			height = 0;
			offGround = 0;
			offBoard = 0;
			name = "";
			code = "";
			brand = "";
			series = "";
			place = "";
			price = 0;
			mode = 0;
			materialMode = 0;
			materialCode = "";
			materialSize = "";
			moduleCode = "";
			moduleName = "";
			layer = 0;
			url = "";
			haveOriginalTransparencyMaps = [];
			boundBoxLines = [];
			ClearHighLights();
		}

		public function Dispose(clearMaterials:Boolean = true):void
		{
			//cloud 2017.11.16 优化
			var i:int,j:int;
			var surface:Surface;
			var geometry:Geometry;
			
			Clear();
			
			CL3DModuleUtil.Instance.disposeMeshFromParent(this,parent,clearMaterials);
			
			i=numChildren-1;
			for(;i>0;i--)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null)
				{
					if(subObject is Mesh)
					{
						var subMesh:Mesh = subObject as Mesh;
						j=subMesh.numChildren-1;
						for(;j>0;j--)
						{
							var isubObject:Object3D = subMesh.getChildAt(j);
							if(isubObject != null)
							{
								if(isubObject is Mesh)
								{
									CL3DModuleUtil.Instance.disposeMeshFromParent(isubObject as Mesh,subMesh,clearMaterials);
								}
								if(isubObject is L3DMesh)
								{
									(isubObject as L3DMesh).Dispose(clearMaterials);
								}
								isubObject = null;
							}
						}
						
						CL3DModuleUtil.Instance.disposeMeshFromParent(subMesh,this,clearMaterials);
					}
					if(subObject is L3DMesh)
					{
						(subObject as L3DMesh).Dispose(clearMaterials);
					}
					subObject = null;
				}
			}
			
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for(var i:int = boundBoxLines.length - 1;i>=0;i--)
				{
					boundBoxLines.pop();
				}
			}
		}
		
		public function get Length():int
		{
			if(boundBox != null)
			{
				return Math.abs(boundBox.maxX - boundBox.minX) * scaleX;
			}
			return length;
		}
		
		public function set Length(v:int):void
		{
			length = v;
			if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			scaleX = v / Math.abs(boundBox.maxX - boundBox.minX);
		}
		
		public function get Width():int
		{
			if(boundBox != null)
			{
				return Math.abs(boundBox.maxY - boundBox.minY) * scaleY;
			}
			return width;
		}
		
		public function set Width(v:int):void
		{
			width = v;
			if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			scaleY = v / Math.abs(boundBox.maxY - boundBox.minY);
		}
		
		public function get Height():int
		{
			if(boundBox != null)
			{
				return Math.abs(boundBox.maxZ - boundBox.minZ) * scaleZ;
			}
			return height;
		}
		
		public function set Height(v:int):void
		{
			height = v;
			if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			scaleZ = v / Math.abs(boundBox.maxZ - boundBox.minZ);
    	}
		
		public function get OffGround():int
		{
			return offGround;
		}
		
		public function set OffGround(v:int):void
		{
			offGround = v;
		}
		
		public function get OffBoard():int
		{
			return offBoard;
		}
		
		public function set OffBoard(v:int):void
		{
			offBoard = v;
		}
		
		public function get Name():String
		{
			return modelName;
		}
		
		public function set Name(v:String):void
		{
			modelName = v;
		}
		
		public function get Code():String
		{
			return code;
		}
		
		public function set Code(v:String):void
		{
			code = v;
			if(caculation != null)
			{
				caculation.PartCode = v;
			}
		}
		
		public function get ERPCode():String
		{
			return erpCode;
		}
		
		public function set ERPCode(v:String):void
		{
			erpCode = v;
		}
		
		public function get UniqueID():String
		{
			if(uniqueID == null || uniqueID.length == 0)
			{
				uniqueID = UIDUtil.createUID();
			}
			
			return uniqueID;
		}
		
		public function set UniqueID(v:String):void
		{
			if(v == null || v.length == 0)
			{
				return;
			}
			
			uniqueID = v;
		}
		
		public function AutoRenewID():void
		{
			uniqueID = UIDUtil.createUID();
		}
		
		public function get Brand():String
		{
			return brand;
		}
		
		public function set Brand(v:String):void
		{
			brand = v;
		}
		
		public function get Series():String
		{
			return series;
		}
		
		public function set Series(v:String):void
		{
			series = v;
		}
		
		public function get Place():String
		{
			return place;
		}
		
		public function set Place(v:String):void
		{
			place = v;
		}
		
		public function get Price():Number
		{
			return price;
		}
		
		public function set Price(v:Number):void
		{
			price = v;
		}
		
		public function get Mode():int
		{
			return mode;
		}
		
		public function set Mode(v:int):void
		{
			mode = v;
		}
		
		public function get MaterialMode():int
		{
			return materialMode;
		}
		
		public function set MaterialMode(v:int):void
		{
			materialMode = v;
		}
		
		public function get IsLight():Boolean
		{
			return isLight;	
		}
		
		public function set IsLight(v:Boolean):void
		{
			isLight = v;
		}
		
		public function get LightMode():int
		{
			return lightMode;
		}
		
		public function set LightMode(v:int):void
		{
			lightMode = v;
		}
		
		public function get LightWattage():int
		{
			return lightWattage;
		}
		
		public function set LightWattage(v:int):void
		{
			lightWattage = v;
		}
		
		public function get LightColor():uint
		{
			return lightColor;
		}
		
		public function set LightColor(v:uint):void
		{
			lightColor = v;
		}
		
		public function get NumberVertices():int
		{
			var count:int = 0;
			if(geometry != null)
			{
				count += geometry.numVertices;
			}
			for(var i:int = 0; i<numChildren; i++)
			{
				var obj:Object3D = getChildAt(i);
				if(obj != null && obj is Mesh)
				{
					var subMesh:Mesh = obj as Mesh;
					if(subMesh.geometry != null)
					{
						count += subMesh.geometry.numVertices;
					}
				}
			}
			
			return count;
		}
		
		public function get NumberTriangles():int
		{
			var count:int = 0;
			if(geometry != null)
			{
				count += geometry.numTriangles;
			}
			for(var i:int = 0; i<numChildren; i++)
			{
				var obj:Object3D = getChildAt(i);
				if(obj != null && obj is Mesh)
				{
					var subMesh:Mesh = obj as Mesh;
					if(subMesh.geometry != null)
					{
						count += subMesh.geometry.numTriangles;
					}
				}
			}
			
			return count;
		}
		
		public function get HaveOriginalTransparencyMaps():Array
		{
			return haveOriginalTransparencyMaps;
		}
		
		public function get ShowBoundBox():Boolean
		{
			return showBoundBox;
		}
		
		public function set ShowBoundBox(v:Boolean):void
		{
			showBoundBox = v;
			if(boundBoxLines == null || boundBoxLines.length == 0)
			{
                BuildBoundBox();
			}
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for each (var line:WireFrame in boundBoxLines)
				{
					if(line != null)
					{
						line.visible = showBoundBox;
					}
				}
			}
		}		
		
		public function get ShowHighLight():Boolean
		{
			return showHighLight;
		}
		
		public function set ShowHighLight(v:Boolean):void
		{
			if(numChildren == 0)
			{
				showHighLight = false;
				return;
			}
			var i:int;
			var subObj:Object3D;
			var subMesh:Mesh;
			if(showHighLight && !v)
			{
				if(highLightBakMaterials.length > 0)
				{
					var count:int = 0;
					for(i = 0; i<numChildren; i++)
					{
						subObj = getChildAt(i);
						if(subObj is Mesh)
						{
							subMesh = subObj as Mesh;
							if(subMesh.numSurfaces > 0)
							{
								subMesh.getSurface(0).material = highLightBakMaterials[count];
								count++;
								if(count >= highLightBakMaterials.length)
								{
									break;
								}
							}
						}
					}
				}
				
				highLightBakMaterials.length = 0;
			}
			else if(!showHighLight && v)
			{
				highLightBakMaterials.length = 0;
				for(i = 0; i<numChildren; i++)
				{
					subObj = getChildAt(i);
					if(subObj is Mesh)
					{
						subMesh = subObj as Mesh;
						if(subMesh.numSurfaces > 0)
						{
							highLightBakMaterials.push(subMesh.getSurface(0).material);
							subMesh.getSurface(0).material = new FillMaterial(0xEE6565, 1);
						}
					}
				}
			}
			
			showHighLight = v;
		}
		
		public function ShowTexHighLight(v:Boolean, stage3D:Stage3D):void
		{
			if(geometry == null || numSurfaces == 0)
			{
				return;
			}
			
			if((v && showTexHighLight) || (!v && !showTexHighLight))
			{
				return;
			}
			
			var material:Material = getSurface(0).material;
			if(material == null)
			{
				return;
			}
			
			
			if(v && !showTexHighLight)
			{
				if(stage3D == null)
				{
					return;
				}
				if(material is LightMapMaterial)
				{
					texHighLightBakData = (material as LightMapMaterial).lightMap;
					(material as LightMapMaterial).lightMap = CreateTexHighLightTexture(stage3D);
				}
				else if(material is TextureMaterial)
				{
					texHighLightBakData = null;
					//(material as StandardMaterial).lightMap = CreateTexHighLightTexture(stage3D);
				}
				else if(material is StandardMaterial)
				{
					texHighLightBakData = (material as StandardMaterial).lightMap;
					(material as StandardMaterial).lightMap = CreateTexHighLightTexture(stage3D);
				}
				else
				{
					texHighLightBakData = material;
					getSurface(0).material = new FillMaterial(HighLightColor, 1);
				}
			}
			else if(texHighLightBakData != null)
			{
				if(material is LightMapMaterial)
				{
					if((material as LightMapMaterial).lightMap != texHighLightBakData)
					{
						CL3DModuleUtil.Instance.clearTextureResource((material as LightMapMaterial).lightMap);
						(material as LightMapMaterial).lightMap = texHighLightBakData;
					}
				}
				else if(material is TextureMaterial)
				{

				}
				else if(material is StandardMaterial)
				{
					if((material as StandardMaterial).lightMap != texHighLightBakData)
					{
						CL3DModuleUtil.Instance.clearTextureResource((material as LightMapMaterial).lightMap);
						(material as StandardMaterial).lightMap = texHighLightBakData;
					}
				}
				else
				{
					getSurface(0).material = texHighLightBakData;
				}
				texHighLightBakData = null;
			}

			showTexHighLight = v;
		}
		
		private function CreateTexHighLightTexture(stage3D:Stage3D):CBitmapTextureResource
		{
			return LivelyLibrary.SceneHighLightTexture(stage3D);
		}
		
		public function ClearHighLights():void
		{
			ShowHighLight = false;
			ShowTexHighLight(false, null);
			for(var i:int = 0; i<numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var subMesh:L3DMesh = subObject as L3DMesh;
					subMesh.ClearHighLights();
				}
			}
		}
		
		public function get Center():Vector3D
		{
			var meshBoundBox:BoundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			var center:Vector3D = new Vector3D((meshBoundBox.maxX + meshBoundBox.minX) * 0.5, (meshBoundBox.maxY + meshBoundBox.minY) * 0.5, (meshBoundBox.maxZ + meshBoundBox.minZ) * 0.5);
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendScale(scaleX, scaleY, scaleZ);
			matrix.appendRotation(rotationX, new Vector3D(1,0,0));
			matrix.appendRotation(rotationY, new Vector3D(0,1,0));
			matrix.appendRotation(rotationZ, new Vector3D(0,0,1));
			matrix.appendTranslation(x,y,z);
			center = matrix.transformVector(center);
			
			return center;
		}
		
		public function get PartInsertPoint():Vector3D
		{
			var meshBoundBox:BoundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			var center:Vector3D = new Vector3D((meshBoundBox.maxX + meshBoundBox.minX) * 0.5, (meshBoundBox.maxY + meshBoundBox.minY) * 0.5, meshBoundBox.maxZ);
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendScale(scaleX, scaleY, scaleZ);
			matrix.appendRotation(rotationX, new Vector3D(1,0,0));
			matrix.appendRotation(rotationY, new Vector3D(0,1,0));
			matrix.appendRotation(rotationZ, new Vector3D(0,0,1));
			matrix.appendTranslation(x,y,z);
			center = matrix.transformVector(center);
			
			return center;
		}
		
		public function get WindowLength():int
		{
			return windowLength;
		}
		
		public function set WindowLength(v:int):void
		{
			windowLength = v;
			caculation.WindowLength = windowLength;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.WindowLength = v;
						mesh.caculation.WindowLength = v;
					}
				}
			}
		}
		
		public function get WindowHeight():int
		{
			return windowHeight;
		}
		
		public function set WindowHeight(v:int):void
		{
			windowHeight = v;
			caculation.WindowHeight = windowHeight;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.WindowHeight = v;
						mesh.caculation.WindowHeight = v;
					}
				}
			}
		}

		public function get MinWindowLength():int
		{
			return minWindowLength;
		}
		
		public function set MinWindowLength(v:int):void
		{
			minWindowLength = v;
			caculation.MinWindowLength = v;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.MinWindowLength = v;
						mesh.caculation.MinWindowLength = v;
					}
				}
			}
		}
		
		public function get MaxWindowLength():int
		{
			return maxWindowLength;
		}
		
		public function set MaxWindowLength(v:int):void
		{
			maxWindowLength = v;
			caculation.MaxWindowLength = v;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.MaxWindowLength = v;
						mesh.caculation.MaxWindowLength = v;
					}
				}
			}
		}
		
		public function get MinWindowHeight():int
		{
			return minWindowHeight;
		}
		
		public function set MinWindowHeight(v:int):void
		{
			minWindowHeight = v;
			caculation.MinWindowHeight = v;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.MinWindowHeight = v;
						mesh.caculation.MinWindowHeight = v;
					}
				}
			}
		}
		
		public function get MaxWindowHeight():int
		{
			return maxWindowHeight;
		}
		
		public function set MaxWindowHeight(v:int):void
		{
			maxWindowHeight = v;
			caculation.MaxWindowHeight = v;
			for(var i:int = 0;i< numChildren; i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.caculation != null)
					{
						mesh.MaxWindowHeight = v;
						mesh.caculation.MaxWindowHeight = v;
					}
				}
			}
		}
		
		public function get IsMirrored():Boolean
		{
			if(caculation == null)
			{
				return false;
			}
			
			return caculation.IsMirrored;
		}
		
		public function get MaterialCode():String
		{
			if(materialCode == null || materialCode.length == 0)
			{
				if(caculation != null)
				{
					materialCode = caculation.MaterialCode;
				}
			}

			return materialCode;
		}
		
		public function set MaterialCode(v:String):void
		{
			if(caculation == null)
			{
				return;
			}
			
			materialCode = v;
			caculation.MaterialCode = v;
		}
		
		public function get MaterialSize():String
		{
			if(materialSize == null || materialSize.length == 0)
			{
				if(caculation != null)
				{
					materialSize = caculation.MaterialSize;
				}
			}
			
			return materialSize;
		}
		
		public function set MaterialSize(v:String):void
		{
			if(caculation == null)
			{
				return;
			}
			
			materialSize = v;
			caculation.MaterialSize = v;;
		}
		
		public function GetMaterialParamTextureMode():int
		{
			if(geometry == null || materialSize == null || materialSize.length == 0)
			{
				return 0;
			}
			
			materialSize = materialSize.toUpperCase();
			if(materialSize.indexOf("X") < 0 || materialSize.indexOf(":") < 0)
			{
				return 0;
			}
			
			var rarr:Array = materialSize.split(":");
			if(rarr.length < 5)
			{
				return 0;
			}
			
			return parseInt(rarr[4]);
		}
		
		public function AutoAmendSizeForMaterialSize(stage3D:Stage3D):Boolean
		{
			if(geometry == null || materialSize == null || materialSize.length == 0)
			{
				return false;
			}
			
			materialSize = materialSize.toUpperCase();
			if(materialSize.indexOf("X") < 0)
			{
				return false;
			}
			
			var rotation:Number = 0;
			var deltaU:Number = 0;
			var deltaV:Number = 0;
			var sizeStr:String = "";
			if(materialSize.indexOf(":") > 0)
			{
				var rarr:Array = materialSize.split(":");
				if(rarr == null || rarr.length < 2)
				{
					return false;
				}
				sizeStr = rarr[0];
				rotation = parseFloat(rarr[1]);
				if(rarr.length > 3)
				{
					deltaU = parseFloat(rarr[2]);
					deltaV = parseFloat(rarr[3]);
				}
			}
			else
			{
				sizeStr = materialSize;
			}
			
			var arr:Array = sizeStr.split("X");
			if(arr == null || arr.length < 2)
			{
				return false;
			}
			
			var width:int = parseInt(arr[0]);
			var height:int = parseInt(arr[1]);
			
			if(width < 10 || width > 10000 || height < 10 || height > 10000)
			{
				return false;
			}
			
			deltaU = deltaU / Number(width);
			deltaV = deltaV / Number(height);
			
			var uvs:Vector.<Number> = geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			if(originalUVs.length == 0)
			{
				for(var i:int=0;i<uvs.length;i++)
				{
					var t:Number = uvs[i];
					originalUVs.push(t);
				}
			}
			
			var amendScale:Number = Math.min(scaleX, scaleY, scaleZ);
			if(amendScale <= 0)
			{
				amendScale = Math.max(scaleX, scaleY, scaleZ);
			}
			var widthScale:Number = width * 0.001 * amendScale;
			var heightScale:Number = height * 0.001 * amendScale;
			var uvMatrix:Matrix3D = new Matrix3D();
			if(rotation != 0)
			{
				uvMatrix.identity();
				uvMatrix.appendRotation(rotation, Vector3D.Z_AXIS);
			}
			for(var i:int=0;i<originalUVs.length;i+=2)
			{
				var u:Number = originalUVs[i];
				var v:Number = originalUVs[i+1];
				if(widthScale > 0)
				{
					u /= widthScale;
				}
				if(heightScale > 0)
				{
					v /= heightScale;
				}
				if(rotation != 0)
				{
					var uvVec:Vector3D = uvMatrix.transformVector(new Vector3D(u,v,0));
					u = uvVec.x;
					v = uvVec.y;
				}
				uvs[i] = u + deltaU;
				uvs[i+1] = v + deltaV;
			}
			
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			geometry.upload(stage3D.context3D);
			
			return true;
		}
		
		public function AutoAmendSizeForMaterialTexture(stage3D:Stage3D, forceScale:Boolean = false):Boolean
		{
			if(geometry == null || numSurfaces == 0)
			{
				return false;
			}
			
			var material:Material = getSurface(0).material;
			if(material == null)
			{
				return false;
			}
			
			var diffuse:TextureResource = null;
			if(material is LightMapMaterial)
			{
				diffuse = (material as LightMapMaterial).diffuseMap;
			}
			else if(material is TextureMaterial)
			{
				diffuse = (material as TextureMaterial).diffuseMap;
			}
			else if(material is StandardMaterial)
			{
				diffuse = (material as StandardMaterial).diffuseMap;
			}
			
			if(diffuse == null || !(diffuse is L3DBitmapTextureResource))
			{
				return false;
			}
			
			var fw:Number = (diffuse as L3DBitmapTextureResource).Width;
			var fl:Number = (diffuse as L3DBitmapTextureResource).Height;
			
			if(fw < 10 || fw > 10000 || fl < 10 || fl > 10000)
			{
				return false;
			}
			
			if(forceScale)
			{
				fw /= 10;
				fl /= 10;
			}
			
			if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			
			var vecMax:Vector3D  = new Vector3D(boundBox.maxX,boundBox.maxY,boundBox.maxZ);
			var vecMin:Vector3D  = new Vector3D(boundBox.minX,boundBox.minY,boundBox.minZ);					
			vecMax = matrix.transformVector(vecMax);
			vecMin = matrix.transformVector(vecMin);
			
			var length:Number = Math.abs(vecMax.x - vecMin.x);
			var width:Number = Math.abs(vecMax.y - vecMin.y);
			var height:Number = Math.abs(vecMax.z - vecMin.z);
			
			var positions:Vector.<Number>=geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=null;
			try
			{
				normals=geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			catch(error:Error)
			{
				return false;
			}
			var uvs:Vector.<Number>=geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);

			var normalLeftRight:Vector3D = new Vector3D(1, 0, 0);//left right
			var normalTopBottom:Vector3D = new Vector3D(0, 1, 0);//top Bottom
			var normalFrontBack:Vector3D = new Vector3D(0, 0, 1);//front back
			
			var quarterRadian:Number = Math.PI / 4;
			var invQuarterRadian:Number = Math.PI - quarterRadian;
			
			var x:Number;
			var y:Number;
			var z:Number;
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				var normal:Vector3D = new Vector3D(normals[i*3], normals[i*3 + 1], normals[i*3 + 2]);
				var u:Number = Math.abs(x - vecMin.x) / length;
				var v:Number = Math.abs(y - vecMin.y) / length;
				var angle:Number = L3DUtils.CompuRadian(normal, normalLeftRight);
				
				if (angle <= quarterRadian)
				{
					z = position.z - vecMin.z;
					y = position.y - vecMin.y;
					uvs[i*2] = 1 - y / (fl * scaleY);
					uvs[i*2 + 1] = 1 - z / (fw * scaleZ);
				}
				
				if (angle >= invQuarterRadian)
				{
					z = position.z - vecMin.z;
					y = position.y - vecMin.y;
					uvs[i*2] = y / (fl * scaleY);
					uvs[i*2 + 1] = 1 - z / (fw * scaleZ);
				}
				
				angle = L3DUtils.CompuRadian(normal, normalFrontBack);
				
				if (angle <= quarterRadian)
				{
					x = position.x - vecMin.x;
					y = position.y - vecMin.y;
					uvs[i*2] = x / (fl * scaleX);
					uvs[i*2 + 1] = 1 - y / (fw * scaleY);
				}
				
				if (angle >= invQuarterRadian)
				{
					x = position.x - vecMin.x;
					y = position.y - vecMin.y;
					uvs[i*2] = 1 - x / (fl * scaleX);
					uvs[i*2 + 1] = 1 - y / (fw * scaleY);
				}
				
				angle = L3DUtils.CompuRadian(normal, normalTopBottom);
				
				if (angle <= quarterRadian)
				{
					x = position.x - vecMin.x;
					z = position.z - vecMin.z;
					uvs[i*2] = 1 - x / (fl * scaleX);
					uvs[i*2 + 1] = 1 - z / (fw * scaleZ);
				}
				
				if (angle >= invQuarterRadian)
				{
					x = position.x - vecMin.x;
					z = position.z - vecMin.z;
					uvs[i*2] = x / (fl * scaleX);
					uvs[i*2 + 1] = 1 - z / (fw * scaleZ);
				}
			}
			
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			geometry.upload(stage3D.context3D);
			
			return true;
		}
		
		private function CompuSize():void
		{
			if(Mode == 37 || Mode == 42)
			{
				if(boundBox == null)
				{
					boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
				}
				minPosition.x = boundBox.minX;
				minPosition.y = boundBox.minY;
				minPosition.z = boundBox.minZ;
				maxPosition.x = boundBox.maxX;
				maxPosition.y = boundBox.maxY;
				maxPosition.z = boundBox.maxZ;
				return;
			}
			
			minPosition = new Vector3D();
			maxPosition = new Vector3D();
			
			var hadGotFirst:Boolean = false;
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name == "L3DTOPVIEW" || mesh.name == "L3DSHADOW")
					{
						continue;
					}
					var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
					var count:uint = vertices.length;
					for (var j:uint = 0; j < count; j += 3)
					{
						var x:Number = vertices[j];
						var y:Number = vertices[j+1];
						var z:Number = vertices[j+2];
						if(hadGotFirst)
						{
							if(x < minPosition.x)
							{
								minPosition.x = x;
							}
							if(y < minPosition.y)
							{
								minPosition.y = y;
							}
							if(z < minPosition.z)
							{
								minPosition.z = z;
							}
							if(x > maxPosition.x)
							{
								maxPosition.x = x;
							}
							if(y > maxPosition.y)
							{
								maxPosition.y = y;
							}
							if(z > maxPosition.z)
							{
								maxPosition.z = z;
							}
						}
						else
						{
							minPosition.x = maxPosition.x = x;
							minPosition.y = maxPosition.y = y;
							minPosition.z = maxPosition.z = z;
							hadGotFirst = true;
						}
					}
				}
			}
		}
		
		public function AutoAmendUVsForTexture(stage3D:Stage3D):Boolean
		{
			if(isOnComputing)
			{
				return false;
			}
			
			isOnComputing = true;
			
			var material:Material = getSurface(0).material;
			if(material == null || !(material is TextureMaterial))
			{
				return false;
			}
			
			var tex:TextureResource = (material as TextureMaterial).diffuseMap;
			if(tex == null || !(tex is L3DBitmapTextureResource))
			{
				return false;
			}
			
			var texture:L3DBitmapTextureResource = tex as L3DBitmapTextureResource;
			
			var uvs:Vector.<Number> = geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			if(originalUVs.length == 0)
			{
				for(var i:int=0;i<uvs.length;i++)
				{
					var t:Number = uvs[i];
					originalUVs.push(t);
				}
			}
			
			var amendScale:Number = Math.min(scaleX, scaleY, scaleZ);
			if(amendScale <= 0)
			{
				amendScale = Math.max(scaleX, scaleY, scaleZ);
			}
			var widthScale:Number = texture.Width * 0.001 * amendScale;
			var heightScale:Number = texture.Height * 0.001 * amendScale;			
			for(var j:int=0;j<originalUVs.length;j+=2)
			{
				var u:Number = originalUVs[j];
				var v:Number = originalUVs[j+1];
				if(widthScale > 0)
				{
				    u /= widthScale;
				}
				if(heightScale > 0)
				{
				    v /= heightScale;
				}
				uvs[j] = u;
				uvs[j+1] = v;
			}
			
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			geometry.upload(stage3D.context3D);
			
			isOnComputing = false;
			
			return true;
		}

		public function Align(mode:int = 0):void
		{	
			x = 0;
			y = 0;
			z = 0;
			scaleX = 1;
			scaleY = 1;
			scaleZ = 1;
			rotationX = 0;
			rotationY = 0;
			rotationZ = 0;
			matrix.identity();
			
			if(this.mode == 30 || this.mode == 33 || this.mode == 34 || this.mode == 35 || this.mode == 37 || this.mode == 42)
			{
				x = 0;
				y = 0;
				z = 0;
				rotationX = 0;
				rotationY = 0;
				rotationZ = 0;
				scaleX = 1;
				scaleY = 1;
				scaleZ = 1;
				for (var i:int = 0; i < numChildren; i++)
				{
					var subset:Object3D = getChildAt(i);
					if(subset is Mesh)
					{
						var mesh:Mesh = Mesh(subset);
						if(mesh.geometry == null)
						{
							for(var k:uint = 0; k < mesh.numChildren; k++)
							{
								var insubset:Object3D = mesh.getChildAt(k);
								if(insubset is Mesh)
								{
									var inmesh:Mesh = Mesh(insubset);
									if(inmesh.geometry != null)
									{
										var invertices:Vector.<Number> = inmesh.geometry.getAttributeValues(VertexAttributes.POSITION);
										var incount:uint = invertices.length;
										for (var l:uint = 0; l < incount; l += 3)
										{
											var inx:Number = invertices[l];
											var iny:Number = invertices[l+1];
											var inz:Number = invertices[l+2];
											var inv:Vector3D = inmesh.localToGlobal(new Vector3D(inx,iny,inz));
											invertices[l] = inv.x;
											invertices[l+1] = inv.y;
											invertices[l+2] = inv.z;
										}
										inmesh.geometry.setAttributeValues(VertexAttributes.POSITION, invertices);
										inmesh.x = 0;
										inmesh.y = 0;
										inmesh.z = 0;
										inmesh.rotationX = 0;
										inmesh.rotationY = 0;
										inmesh.rotationZ = 0;
										inmesh.scaleX = 1;
										inmesh.scaleY = 1;
										inmesh.scaleZ = 1;
										inmesh.matrix.identity();
									}
								}
							}
							mesh.x = 0;
							mesh.y = 0;
							mesh.z = 0;
							mesh.rotationX = 0;
							mesh.rotationY = 0;
							mesh.rotationZ = 0;
							mesh.scaleX = 1;
							mesh.scaleY = 1;
							mesh.scaleZ = 1;
							mesh.matrix.identity();
							continue;
						}
						var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
						var count:uint = vertices.length;
						for (var j:uint = 0; j < count; j += 3)
						{
							var x:Number = vertices[j];
							var y:Number = vertices[j+1];
							var z:Number = vertices[j+2];
							var v:Vector3D = mesh.localToGlobal(new Vector3D(x,y,z));
							vertices[j] = v.x;
							vertices[j+1] = v.y;
							vertices[j+2] = v.z;
							if(this.mode == 33 || this.mode == 34)
							{
								vertices[j] += 950;
								vertices[j+2] += 220;
							}
						}
						mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
						mesh.x = 0;
						mesh.y = 0;
						mesh.z = 0;
						mesh.rotationX = 0;
						mesh.rotationY = 0;
						mesh.rotationZ = 0;
						mesh.scaleX = 1;
						mesh.scaleY = 1;
						mesh.scaleZ = 1;
						mesh.matrix.identity();
					}
				}
				x = 0;
				y = 0;
				z = 0;
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			else if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			
			CompuSize();
			
			if(this.mode == 33 || this.mode == 34)
			{
				matrix.identity();
				BuildBoundBox();
				return;
			}
			
			var point:Vector3D = new Vector3D();		
			switch(mode)
			{
				case 0:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5,(maxPosition.y + minPosition.y)*0.5, minPosition.z);
				}
					break;
				case 1:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, minPosition.y, minPosition.z);
				}
					break;
				case 2:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5,(maxPosition.y + minPosition.y)*0.5, maxPosition.z);
				}
					break;
				case 3:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, maxPosition.y, maxPosition.z);
				}
					break;
				case 4:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, maxPosition.y, minPosition.z);
				}
					break;
				case 5:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, minPosition.y + 110, minPosition.z);
				}
					break;
				case 6:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, minPosition.y + 120, minPosition.z);
				}
					break;
				case 7:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5, maxPosition.y, (maxPosition.z + minPosition.z)*0.5);
				}
					break;
				default:
				{
					point = new Vector3D((maxPosition.x + minPosition.x)*0.5,(maxPosition.y + minPosition.y)*0.5, minPosition.z);
				}
					break;
			}

			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						for(var k:uint = 0; k < mesh.numChildren; k++)
						{
							var iinsubset:Object3D = mesh.getChildAt(k);
							if(iinsubset is Mesh)
							{
								var iinmesh:Mesh = Mesh(iinsubset);
								if(iinmesh.geometry != null)
								{
									var iinvertices:Vector.<Number> = iinmesh.geometry.getAttributeValues(VertexAttributes.POSITION);
									var iincount:uint = iinvertices.length;
									for (var l:uint = 0; l < iincount; l += 3)
									{
										var iinx:Number = iinvertices[l];
										var iiny:Number = iinvertices[l+1];
										var iinz:Number = iinvertices[l+2];
										var iinv:Vector3D = new Vector3D(iinx,iiny,iinz);
										iinv.x-= point.x;
										iinv.y-= point.y;
										iinv.z-= point.z;
										iinvertices[l] = iinv.x;
										iinvertices[l+1] = iinv.y;
										iinvertices[l+2] = iinv.z;
									}
									iinmesh.geometry.setAttributeValues(VertexAttributes.POSITION, iinvertices);
									iinmesh.matrix.identity();
								}
							}
						}
						continue;
					}
					var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
					var count:uint = vertices.length;
					for (var j:uint = 0; j < count; j += 3)
					{
						var x:Number = vertices[j];
						var y:Number = vertices[j+1];
						var z:Number = vertices[j+2];
						var v:Vector3D = new Vector3D(x,y,z);
						v.x-= point.x;
						v.y-= point.y;
						v.z-= point.z;
						vertices[j] = v.x;
						vertices[j+1] = v.y;
						vertices[j+2] = v.z;
					}
					mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
					mesh.matrix.identity();
				}
			}
			
			matrix.identity();
			
			BuildBoundBox();
		}		
		
		public function Mirror(axis:Vector3D):void
		{	
			if(boundBox == null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}			
			
			var mirrorPosition:Vector3D = new Vector3D((boundBox.maxX + boundBox.minX) / 2, (boundBox.maxY + boundBox.minY) / 2, (boundBox.maxZ + boundBox.minZ) / 2);
			
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
					var count:uint = vertices.length;
					for (var j:uint = 0; j < count; j += 3)
					{
						var x:Number = vertices[j];
						var y:Number = vertices[j+1];
						var z:Number = vertices[j+2];
						switch(axis)
						{
							case Vector3D.X_AXIS:
							{
								vertices[j] = mirrorPosition.x - x;
								vertices[j+1] = y;
								vertices[j+2] = z;
							}
								break;
							case Vector3D.Y_AXIS:
							{
								vertices[j] = x;
								vertices[j+1] = mirrorPosition.y - y;
								vertices[j+2] = z;
							}
								break;
							case Vector3D.Z_AXIS:
							{
								vertices[j] = x;
								vertices[j+1] = y;
								vertices[j+2] = mirrorPosition.z - z;
							}
								break;
						}
					}					
					mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);					
					var indices:Vector.<uint> = mesh.geometry.indices;
					count = indices.length;
					var invertIndices:Vector.<uint> = new Vector.<uint>();
					for (var k:uint = 0; k < count; k ++)
					{
						invertIndices.push(indices[count - 1 - k]);
					}
					mesh.geometry.indices = invertIndices;
				}
			}
			
			BuildBoundBox();
		}
		
		public function get Preview():BitmapData
		{
			return L3DMaterial.LoadBitmapData(previewBuffer);
		}
		
		public function get PreviewBuffer():ByteArray
		{
			return previewBuffer;
		}
		
		public function set PreviewBuffer(buffer:ByteArray):void
		{
			if(buffer == null || buffer.length == 0)
			{
				previewBuffer = null;
				return;
			}
			
			previewBuffer = new ByteArray();
			previewBuffer.writeBytes(buffer,0,buffer.length);
		}
		
		public function HaveSizeAmendParts():Boolean
		{		
			if(numChildren == 0)
			{
				return false;
			}
			
			for(var i:int = 0;i<numChildren;i++)
			{
				var subObject:Object3D = getChildAt(i);
				if(subObject != null && subObject is L3DMesh)
				{
					var mesh:L3DMesh = subObject as L3DMesh;
					if(mesh.MaterialSize != null && mesh.MaterialSize.length > 0)
					{
						if(mesh.MaterialSize.toUpperCase().indexOf("X") > 0)
						{
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public function AutoAmendLayers():Boolean
		{
			if(numChildren == 0)
			{
				return false;
			}
			
			var currentLayer:int = 0;
			var currentLayerPosition:Number = 0;
			
			for(var i:int = 0;i<11;i++)
			{
				var maxThickness:Number = 0;
				for(var j:int = 0;j<numChildren;j++)
				{
					var subObject:Object3D = getChildAt(j);
					if(subObject != null && subObject is L3DMesh)
					{
						var mesh:L3DMesh = subObject as L3DMesh;
						if(mesh.boundBox == null)
						{
							mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
						}
						if(mesh.layer == i)
						{							
							var thickness:Number = Math.abs(mesh.boundBox.maxY - mesh.boundBox.minY);
							if(thickness > maxThickness)
							{
								maxThickness = thickness;
							}	
							mesh.y = -currentLayerPosition + thickness / 2;
						}
					}
				}				
				currentLayerPosition += ((maxThickness + deltaLayThickness) / 2);
			}
			
			return true;
		}
		
		public function get ShowShadow():Boolean
		{
			var visible:Boolean = false;
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name == "L3DSHADOW")
					{
						visible = mesh.visible;
						break;
					}
				}
			}
			return visible;
		}
		
		public function set ShowShadow(v:Boolean):void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name == "L3DSHADOW")
					{
						mesh.visible = v;
						break;
					}
				}
			}
		}
		
		public function get ShowTopView():Boolean
		{
			var visible:Boolean = false;
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name == "L3DTOPVIEW")
					{
						visible = mesh.visible;
						break;
					}
				}
			}
			return visible;
		}
		
		public function set ShowTopView(v:Boolean):void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name == "L3DTOPVIEW")
					{
						mesh.visible = v;
					}
					else
					{
						mesh.visible = !v;
					}
				}
			}
		}
		
		public function GetLightPosition(index:int):Vector3D
		{
			if(index < 0 || index >= numChildren)
			{
				return new Vector3D();
			}
			
			var subset:Object3D = getChildAt(index);
			if(!(subset is Mesh))
			{
				return new Vector3D();
			}
			
			var mesh:Mesh = Mesh(subset);
			if(mesh.geometry == null)
			{
				return new Vector3D();
			}
			
			var position:Vector3D = new Vector3D();
			
			switch(mode)
			{
				case 2:
				{
					var meshBoundBox:BoundBox = Object3DUtils.calculateHierarchyBoundBox(this);
					position = new Vector3D((meshBoundBox.maxX + meshBoundBox.minX) * 0.5, (meshBoundBox.maxY + meshBoundBox.minY) * 0.5, meshBoundBox.minZ - 1);
					position = localToGlobal(position);
				/*	var matrix:Matrix3D = new Matrix3D();
					matrix.identity();
					matrix.appendScale(scaleX, scaleY, scaleZ);
					matrix.appendRotation(rotationX, new Vector3D(1,0,0));
					matrix.appendRotation(rotationY, new Vector3D(0,1,0));
					matrix.appendRotation(rotationZ, new Vector3D(0,0,1));
					matrix.appendTranslation(x,y,z);
					position = matrix.transformVector(position); */
				}
					break;
				default:
				{
					switch(lightMode)
					{
						case 2:
						{
							var meshBoundBox:BoundBox = Object3DUtils.calculateHierarchyBoundBox(this);
							position = new Vector3D((meshBoundBox.maxX + meshBoundBox.minX) * 0.5, (meshBoundBox.maxY + meshBoundBox.minY) * 0.5, meshBoundBox.minZ - 1);
							position = localToGlobal(position);
						/*	var matrix:Matrix3D = new Matrix3D();
							matrix.identity();
							matrix.appendScale(scaleX, scaleY, scaleZ);
							matrix.appendRotation(rotationX, new Vector3D(1,0,0));
							matrix.appendRotation(rotationY, new Vector3D(0,1,0));
							matrix.appendRotation(rotationZ, new Vector3D(0,0,1));
							matrix.appendTranslation(x,y,z);
							position = matrix.transformVector(position); */
						}
							break;
						default:
						{
							position = GetCenterPosition(index);
						}
							break;
					}					
				}
					break;
			}
			
			return position;
		}
		
		public function GetCenterPosition(index:int):Vector3D
		{
			if(index < 0 || index >= numChildren)
			{
				return new Vector3D();
			}
			
			var subset:Object3D = getChildAt(index);
			if(!(subset is Mesh))
			{
				return new Vector3D();
			}
			
			var mesh:Mesh = Mesh(subset);
			if(mesh.geometry == null)
			{
				return new Vector3D();
			}
			
			var meshBoundBox:BoundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			var center:Vector3D = new Vector3D((meshBoundBox.maxX + meshBoundBox.minX) * 0.5, (meshBoundBox.maxY + meshBoundBox.minY) * 0.5, (meshBoundBox.maxZ + meshBoundBox.minZ) * 0.5);
		/*	var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendScale(scaleX, scaleY, scaleZ);
			matrix.appendRotation(rotationX, new Vector3D(1,0,0));
			matrix.appendRotation(rotationY, new Vector3D(0,1,0));
			matrix.appendRotation(rotationZ, new Vector3D(0,0,1));
			matrix.appendTranslation(x,y,z);
			center = matrix.transformVector(center);
			
			return center;*/
			
			return mesh.localToGlobal(center);
		}
		
		public function CompuArea():Number
		{
			var area:Number = 0;
			for (var i:int = 0; i < numChildren; i++)
			{
				var subset:Object3D = getChildAt(i);
				if(subset is Mesh)
				{
					var mesh:Mesh = Mesh(subset);
					if(mesh.geometry == null)
					{
						continue;
					}
					var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
					var indices:Vector.<uint> = mesh.geometry.indices;
					var count:uint = indices.length;
					for(var j:uint = 0; j < count; j+= 3)
					{
						var i0:uint = indices[j];
						var i1:uint = indices[j + 1];
						var i2:uint = indices[j + 2];
						var v0:Vector3D = new Vector3D(vertices[i0 * 3], vertices[i0 * 3 + 1], vertices[i0 * 3 + 2]);
						var v1:Vector3D = new Vector3D(vertices[i1 * 3], vertices[i1 * 3 + 1], vertices[i1 * 3 + 2]);
						var v2:Vector3D = new Vector3D(vertices[i2 * 3], vertices[i2 * 3 + 1], vertices[i2 * 3 + 2]);
						area += CompuFaceArea(v0,v1,v2);
					}
				}
			}	
			return area;
		}
		
		public function NeedEnableEnvironmentMaterial(materialMode:int):Boolean
		{
			switch(materialMode)
			{
				case 1:
				case 2:
				case 3:
				case 7:
				case 12:
				case 15:
				case 16:
				case 17:
				case 18:
				case 30:
				case 31:
				case 32:
				case 33:
				case 37:
				case 38:
				case 39:
				case 40:
				case 41:
				case 42:
				case 43:
				case 44:
				case 45:
				{
					return true;
				}
					break;
			}
			
			return false;
		}
		
		public function GetEnvironmentReflection(materialMode:int):Number
		{
			switch(materialMode)
			{
				case 1:
				{
					return 0.50;
				}
					break;
				case 2:
				case 30:
				{
					return 0.10;
				}
					break;
				case 3:
				case 7:
				case 12:
				case 33:
				case 45:
				{
					return 0.40;
				}
					break;
				case 15:
				case 16:
				case 17:
				case 18:
				{
					return 0.40;
				}
					break;
				case 31:
				case 32:
				{
					return 0.30;
				}
					break;
				case 37:
				case 38:
				{
					return 0.40;
				}
				case 39:
				case 41:
				case 44:
				{
					return 0.40;
				}
					break;
				case 40:
				case 42:
				case 43:
				{
					return 0.08;
				}
					break;
			}
			
			return 0;
		}
		
		public function UpdateForEnviromentView(mesh:Mesh, stage3D:Stage3D):void
		{
	/*		if(mesh == null || mesh.geometry == null || mesh.numSurfaces == 0)
			{
				return;
			}
			
			var material:Material = mesh.getSurface(0).material;
			if(material == null)
			{
				return;
			}
			
			if(!L3DUtils.CheckMeshHaveNormals(mesh))
			{
				return;
			} 
			
			var materialMode:int = mesh is L3DMesh ? (mesh as L3DMesh).MaterialMode : (mesh.userData as RelatingParams).materialMode;
			var opMesh:L3DMesh = new L3DMesh();
			
			if(opMesh.NeedEnableEnvironmentMaterial(materialMode))
			{
				if(material is EnvironmentMaterial)
				{
					(material as EnvironmentMaterial).reflection = opMesh.GetEnvironmentReflection(materialMode);
					return;
				}
				
				var alpha:Number = 1;
				var alphaThreshold:Number = 0;
				var specularPower:Number = 1;
				var diffuse:TextureResource = null;
				var normal:TextureResource = null;
				var specular:TextureResource = null;
				var emission:TextureResource = null;
				var transparent:TextureResource = null;
				var lightMapChannel:int = 1;
				
				if(material is LightMapMaterial)
				{
					var checkMaterial3:LightMapMaterial = material as LightMapMaterial;
					alpha = checkMaterial3.alpha;
					alphaThreshold = checkMaterial3.alphaThreshold;		
					lightMapChannel = checkMaterial3.lightMapChannel;
					if(checkMaterial3.diffuseMap != null)
					{
					//    if(checkMaterial3.diffuseMap is BitmapTextureResource)
					//	{
						diffuse = checkMaterial3.diffuseMap;
					//	}
					}
					if(checkMaterial3.lightMap != null)
					{
					//	if(checkMaterial3.lightMap is BitmapTextureResource)
					//	{
						emission = checkMaterial3.lightMap;
					//	}
					}
					if(checkMaterial3.opacityMap != null)
					{
					//	if(checkMaterial3.opacityMap is BitmapTextureResource)
					//	{
						transparent = checkMaterial3.opacityMap;
					//	}	
					}	
				}
				else if(material is StandardMaterial)
				{
					var checkMaterial:StandardMaterial = material as StandardMaterial;
					alpha = checkMaterial.alpha;
					alphaThreshold = checkMaterial.alphaThreshold;
					specularPower = checkMaterial.specularPower;
					if(checkMaterial.diffuseMap != null)
					{
				//		if(checkMaterial.diffuseMap is BitmapTextureResource)
				//		{
						diffuse = checkMaterial.diffuseMap;
				//		}
					}
					if(checkMaterial.normalMap != null)
					{
				//		if(checkMaterial.normalMap is BitmapTextureResource)
				//		{
						normal = checkMaterial.normalMap;
				//		}
					}
					if(checkMaterial.specularMap != null)
					{
				//		if(checkMaterial.specularMap is BitmapTextureResource)
				//		{
						specular = checkMaterial.specularMap;
				//		}							
					}
					if(checkMaterial.lightMap != null)
					{
				//		if(checkMaterial.lightMap is BitmapTextureResource)
				//		{
						emission = checkMaterial.lightMap;
				//		}
					}
					if(checkMaterial.opacityMap != null)
					{
				//		if(checkMaterial.opacityMap is BitmapTextureResource)
				//		{
						transparent = checkMaterial.opacityMap;
				//		}	
					}						
				}
				else if(material is TextureMaterial)
				{
					var checkMaterial2:TextureMaterial = material as TextureMaterial;
					alpha = checkMaterial2.alpha;
					alphaThreshold = checkMaterial2.alphaThreshold;						
					if(checkMaterial2.diffuseMap != null)
					{
					//	if(checkMaterial2.diffuseMap is BitmapTextureResource)
					//	{
						diffuse = checkMaterial2.diffuseMap;
					//	}
					}
					if(checkMaterial2.opacityMap != null)
					{
					//	if(checkMaterial2.opacityMap is BitmapTextureResource)
					//	{
						transparent = checkMaterial2.opacityMap;
					//	}	
					}	
				}
				else if(material is FillMaterial)
				{
					diffuse = CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance((material as FillMaterial).color.toString(),null,stage3D,LivelyLibrary.RuntimeMode);
					alpha = (material as FillMaterial).alpha;
					alphaThreshold = alpha < 1 ? 1 : 0;
				//	alphaThreshold = 0;
				}
				
				material = new EnvironmentMaterial();
				if(diffuse == null)
				{
					diffuse = CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(0xffffff.toString(),null,stage3D,LivelyLibrary.RuntimeMode);
				}
				(material as EnvironmentMaterial).diffuseMap = diffuse;
				(material as EnvironmentMaterial).normalMap = normal;
				(material as EnvironmentMaterial).lightMap = emission;
				(material as EnvironmentMaterial).reflectionMap = specular;
				(material as EnvironmentMaterial).reflection = opMesh.GetEnvironmentReflection(materialMode);;				
				(material as EnvironmentMaterial).opacityMap = transparent;
				(material as EnvironmentMaterial).environmentMap = L3DMaterial.GetEnvironmentMap(stage3D);
			//	(material as EnvironmentMaterial).reflection = GetEnvironmentReflection(materialMode);
				(material as EnvironmentMaterial).lightMapChannel = lightMapChannel;
				if(alpha < 1)
				{
					(material as EnvironmentMaterial).opaquePass = true;
					(material as EnvironmentMaterial).alpha = alpha;
					alphaThreshold = alpha < 1 ? 1 : 0;
					(material as EnvironmentMaterial).alphaThreshold = alphaThreshold;
					(material as EnvironmentMaterial).transparentPass = true;	
				}				
			
				mesh.getSurface(0).material = material;
			}
			else
			{
				if(!(material is EnvironmentMaterial))
				{
					return;
				}
				
				var ematerial:EnvironmentMaterial = material as EnvironmentMaterial;
				var diffuse:TextureResource = ematerial.diffuseMap;
				if(diffuse == null)
				{
					diffuse = CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(0xffffff.toString(),null,stage3D,LivelyLibrary.RuntimeMode);
				}
				var normal:TextureResource = ematerial.normalMap;
				var specular:TextureResource = ematerial.reflectionMap;
				var emission:TextureResource = ematerial.lightMap;
				var transparent:TextureResource = ematerial.opacityMap;
				
				var needCheckTransparency:Boolean = true;
				if(normal == null && specular == null && emission == null && transparent == null)
				{
					material = new TextureMaterial(diffuse);
				}
				else if(normal == null && specular == null && emission == null)
				{
					material = new TextureMaterial(diffuse, transparent, ematerial.alpha);
					if(ematerial.alpha < 1 || transparent != null)
					{
						(material as TextureMaterial).opaquePass = true;
						(material as TextureMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as TextureMaterial).transparentPass = true;
					}
					needCheckTransparency = false;
				}
				else if(specular == null)
				{
					material = new LightMapMaterial(diffuse, emission, ematerial.lightMapChannel, transparent);
					if(ematerial.alpha < 1 || transparent != null)
					{
						(material as LightMapMaterial).opaquePass = true;
						(material as LightMapMaterial).alpha = ematerial.alpha;
						(material as LightMapMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as LightMapMaterial).transparentPass = true;
					}
					needCheckTransparency = false;
				}
				else
				{
					if(diffuse == null)
					{
						var diffuseBmp = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
						var colorDiffuse:BitmapTextureResource = new BitmapTextureResource(diffuseBmp);
						colorDiffuse.upload(stage3D.context3D);
						material = new StandardMaterial(colorDiffuse, null, null, null, null);
					}
					else
					{
						material = new StandardMaterial(diffuse, null, null, null, null);
					}
					if(normal == null)
					{
						var normalBmp = new BitmapData(1, 1, false, 0x7F7FFF);
						var colorNormal:BitmapTextureResource = new BitmapTextureResource(normalBmp);
						colorNormal.upload(stage3D.context3D);
						(material as StandardMaterial).normalMap = colorNormal;
					}
					else
					{
						(material as StandardMaterial).normalMap = normal;
					}
					if(specular != null)
					{
						(material as StandardMaterial).specularMap = specular;
						(material as StandardMaterial).specularPower = ematerial.reflection;
					}
					if(emission == null)
					{
						var emissionBmp = new BitmapData(1, 1, false, 0xAAAAAA);
						var colorEmission:BitmapTextureResource = new BitmapTextureResource(emissionBmp);
						colorEmission.upload(stage3D.context3D);
						(material as StandardMaterial).lightMap = colorEmission;
						(material as StandardMaterial).lightMapChannel = ematerial.lightMapChannel;
					}
					else
					{
						(material as StandardMaterial).lightMap = emission;
						(material as StandardMaterial).lightMapChannel = ematerial.lightMapChannel;
					}
					if(transparent != null)
					{
						(material as StandardMaterial).opacityMap = transparent;
						(material as StandardMaterial).alpha = ematerial.alpha;
						(material as StandardMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as StandardMaterial).opaquePass = true;
						(material as StandardMaterial).transparentPass = true;
						needCheckTransparency = false;
					}
				}
				
				if(needCheckTransparency && ematerial.alpha < 1.0)
				{
					if(material is FillMaterial)
					{	
						(material as FillMaterial).alpha = ematerial.alpha;
					}
					else if(material is StandardMaterial)
					{
						if((material as StandardMaterial).opacityMap == null)
						{
							var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
							var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
							colorOpacity.upload(stage3D.context3D);
							(material as StandardMaterial).opacityMap = colorOpacity;
						}
						(material as StandardMaterial).alpha = ematerial.alpha;
						(material as StandardMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as StandardMaterial).opaquePass = true;							
						(material as StandardMaterial).transparentPass = true;
					}
					else if(material is LightMapMaterial)
					{
						if((material as LightMapMaterial).opacityMap == null)
						{
							var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
							var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
							colorOpacity.upload(stage3D.context3D);
							(material as LightMapMaterial).opacityMap = colorOpacity;
						}
						(material as LightMapMaterial).alpha = ematerial.alpha;
						(material as LightMapMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as LightMapMaterial).opaquePass = true;							
						(material as LightMapMaterial).transparentPass = true;
					}
					else if(material is TextureMaterial)
					{
						if((material as TextureMaterial).opacityMap == null)						
						{
							var tOpacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
							var tColorOpacity:BitmapTextureResource = new BitmapTextureResource(tOpacityBmp);
							tColorOpacity.upload(stage3D.context3D);
							(material as TextureMaterial).opacityMap = tColorOpacity;
						}
						(material as TextureMaterial).alpha = ematerial.alpha;
						(material as TextureMaterial).alphaThreshold = ematerial.alphaThreshold;
						(material as TextureMaterial).opaquePass = true;
						(material as TextureMaterial).transparentPass = true;
					}
					else
					{
						material = new FillMaterial(0xffffff, ematerial.alpha);
					}
				}
				
				mesh.getSurface(0).material = material;
			}
			
			opMesh.Dispose(true); */
		}
		
		private static function CompuFaceArea(v1:Vector3D, v2:Vector3D, v3:Vector3D):Number
		{
			var d1:Vector3D = new Vector3D(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
			var d2:Vector3D = new Vector3D(v2.x - v3.x, v2.y - v3.y, v2.z - v3.z);
			var d3:Vector3D = new Vector3D(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
			var l1:Number = d1.length;
			var l2:Number = d2.length;
			var l3:Number = d3.length;
			var s:Number = (l1 + l2 + l3) / 2;
			return Math.sqrt(s * (s - l1) * (s - l2) * (s - l3));
		}
		
		public function BuildSceneBoundBox(stage3D:Stage3D, scene:Object3D):void
		{
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for each (var line:WireFrame in boundBoxLines)
				{
					if(line != null)
					{
						try
						{
					    	scene.removeChild(line);
						}
						catch(error:Error)
						{
							
						}
					}
				}
			}
			
			boundBoxLines = [];
			boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			
			var minPosition:Vector3D = new Vector3D(boundBox.minX, boundBox.minY, boundBox.minZ);
			var maxPosition:Vector3D = new Vector3D(boundBox.maxX, boundBox.maxY, boundBox.maxZ);
			
			var line0:WireFrame = BuildSceneLine(minPosition.x, minPosition.y, minPosition.z, maxPosition.x, minPosition.y, minPosition.z, 0xffffff, scene);
			var line1:WireFrame = BuildSceneLine(minPosition.x, minPosition.y, minPosition.z, minPosition.x, maxPosition.y, minPosition.z, 0xffffff, scene);
			var line2:WireFrame = BuildSceneLine(minPosition.x, minPosition.y, minPosition.z, minPosition.x, minPosition.y, maxPosition.z, 0xffffff, scene);
			var line3:WireFrame = BuildSceneLine(maxPosition.x, minPosition.y, minPosition.z, maxPosition.x, maxPosition.y, minPosition.z, 0xffffff, scene);
			var line4:WireFrame = BuildSceneLine(minPosition.x, maxPosition.y, minPosition.z, maxPosition.x, maxPosition.y, minPosition.z, 0xffffff, scene);
			var line5:WireFrame = BuildSceneLine(maxPosition.x, minPosition.y, minPosition.z, maxPosition.x, minPosition.y, maxPosition.z, 0xffffff, scene);
			var line6:WireFrame = BuildSceneLine(minPosition.x, minPosition.y, maxPosition.z, maxPosition.x, minPosition.y, maxPosition.z, 0xffffff, scene);
			var line7:WireFrame = BuildSceneLine(minPosition.x, maxPosition.y, minPosition.z, minPosition.x, maxPosition.y, maxPosition.z, 0xffffff, scene);
			var line8:WireFrame = BuildSceneLine(maxPosition.x, maxPosition.y, minPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, scene);
			var line9:WireFrame = BuildSceneLine(minPosition.x, maxPosition.y, maxPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, scene);
			var line10:WireFrame = BuildSceneLine(minPosition.x, minPosition.y, maxPosition.z, minPosition.x, maxPosition.y, maxPosition.z, 0xffffff, scene);
			var line11:WireFrame = BuildSceneLine(maxPosition.x, minPosition.y, maxPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, scene);
			
			boundBoxLines = [line0,line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11];
			
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for each (var line:WireFrame in boundBoxLines)
				{
					if(line != null)
					{
						line.visible = showBoundBox;
						UploadResources(line, stage3D.context3D);	
					}
				}
			}
		}
		
		private function BuildSceneLine(fromX:Number, fromY:Number, fromZ:Number, toX:Number, toY:Number, toZ:Number, lineColor:int, scene:Object3D):WireFrame  
		{ 
			var line:WireFrame = WireFrame.createLineStrip(Vector.<Vector3D>([new Vector3D(fromX, fromY, fromZ), new Vector3D(toX, toY, toZ)]), lineColor, 2);
			scene.addChild(line);
			return line;
		}
		
		public function BuildBoundBox():void
		{
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for each (var line:WireFrame in boundBoxLines)
				{
					if(line != null)
					{
						try
						{
							removeChild(line);
						}
						catch(error:Error)
						{
							
						}
					}
				}
			}
			
			boundBoxLines = [];
			if(boundBox==null)
			{
				boundBox = Object3DUtils.calculateHierarchyBoundBox(this);
			}
			if(boundBox==null)
			{
				return;
			}
			var minPosition:Vector3D = new Vector3D(boundBox.minX, boundBox.minY, boundBox.minZ);
			var maxPosition:Vector3D = new Vector3D(boundBox.maxX, boundBox.maxY, boundBox.maxZ);
			
		//	var thickness:Number = mode == 5 ? 1:2;
			
			var thickness:Number = 2;
			
			var line0:WireFrame = BuildLine(minPosition.x, minPosition.y, minPosition.z, maxPosition.x, minPosition.y, minPosition.z, 0xffffff, thickness);
			var line1:WireFrame = BuildLine(minPosition.x, minPosition.y, minPosition.z, minPosition.x, maxPosition.y, minPosition.z, 0xffffff, thickness);
			var line2:WireFrame = BuildLine(minPosition.x, minPosition.y, minPosition.z, minPosition.x, minPosition.y, maxPosition.z, 0xffffff, thickness);
			var line3:WireFrame = BuildLine(maxPosition.x, minPosition.y, minPosition.z, maxPosition.x, maxPosition.y, minPosition.z, 0xffffff, thickness);
			var line4:WireFrame = BuildLine(minPosition.x, maxPosition.y, minPosition.z, maxPosition.x, maxPosition.y, minPosition.z, 0xffffff, thickness);
			var line5:WireFrame = BuildLine(maxPosition.x, minPosition.y, minPosition.z, maxPosition.x, minPosition.y, maxPosition.z, 0xffffff, thickness);
			var line6:WireFrame = BuildLine(minPosition.x, minPosition.y, maxPosition.z, maxPosition.x, minPosition.y, maxPosition.z, 0xffffff, thickness);
			var line7:WireFrame = BuildLine(minPosition.x, maxPosition.y, minPosition.z, minPosition.x, maxPosition.y, maxPosition.z, 0xffffff, thickness);
			var line8:WireFrame = BuildLine(maxPosition.x, maxPosition.y, minPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, thickness);
			var line9:WireFrame = BuildLine(minPosition.x, maxPosition.y, maxPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, thickness);
			var line10:WireFrame = BuildLine(minPosition.x, minPosition.y, maxPosition.z, minPosition.x, maxPosition.y, maxPosition.z, 0xffffff, thickness);
			var line11:WireFrame = BuildLine(maxPosition.x, minPosition.y, maxPosition.z, maxPosition.x, maxPosition.y, maxPosition.z, 0xffffff, thickness);
			
			boundBoxLines = new Array(line0,line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11);
			
			if(boundBoxLines != null && boundBoxLines.length > 0)
			{
				for each (var line:WireFrame in boundBoxLines)
				{
					if(line != null)
					{
						line.visible = showBoundBox;
					}
				}
			}
		}
		
		private function BuildLine(fromX:Number, fromY:Number, fromZ:Number, toX:Number, toY:Number, toZ:Number, lineColor:int, thickness:Number = 2):WireFrame  
		{ 
			var line:WireFrame = WireFrame.createLineStrip(Vector.<Vector3D>([new Vector3D(fromX, fromY, fromZ), new Vector3D(toX, toY, toZ)]), lineColor, thickness);
			addChild(line);
			return line;
		}
		
		public function get LightsExist():Boolean
		{
			if(geometry != null && numSurfaces > 0 && isLight && lightWattage > 0)
			{
				return true;
			}
			
			if(numChildren > 0)
			{
				for(var i1:int = 0; i1<numChildren; i1++)
				{
					var subObj1:Object3D = getChildAt(i1);
					if(subObj1 != null && subObj1 is L3DMesh)
					{
						var subMesh1:L3DMesh = subObj1 as L3DMesh;
						if(subMesh1.geometry != null && subMesh1.numSurfaces > 0 && subMesh1.isLight && subMesh1.lightWattage > 0)
						{
							return true;
						}	
						if(subMesh1.numChildren > 0)
						{
							for(var i2:int = 0; i2<subMesh1.numChildren; i2++)
							{
								var subObj2:Object3D = subMesh1.getChildAt(i2);
								if(subObj2 != null && subObj2 is L3DMesh)
								{
									var subMesh2:L3DMesh = subObj2 as L3DMesh;
									if(subMesh2.geometry != null && subMesh2.numSurfaces > 0 && subMesh2.isLight && subMesh2.lightWattage > 0)
									{
										return true;
									}	
									if(subMesh2.numChildren > 0)
									{
										for(var i3:int = 0; i3<subMesh2.numChildren; i3++)
										{
											var subObj3:Object3D = subMesh2.getChildAt(i3);
											if(subObj3 != null && subObj3 is L3DMesh)
											{
												var subMesh3:L3DMesh = subObj3 as L3DMesh;
												if(subMesh3.geometry != null && subMesh3.numSurfaces > 0 && subMesh3.isLight && subMesh3.lightWattage > 0)
												{
													return true;
												}												
												if(subMesh3.numChildren > 0)
												{
													for(var i4:int = 0; i4<subMesh3.numChildren; i4++)
													{
														var subObj4:Object3D = subMesh3.getChildAt(i4);
														if(subObj4 != null && subObj4 is L3DMesh)
														{
															var subMesh4:L3DMesh = subObj4 as L3DMesh;
															if(subMesh4.geometry != null && subMesh4.numSurfaces > 0 && subMesh4.isLight && subMesh4.lightWattage > 0)
															{
																return true;
															}								
														}
													}
												}
											}
										}
									}	
								}
							}
						}						
					}
				}
			}
			
			return false;
		}
		
		public function CloneMesh(stage3D:Stage3D):L3DMesh
		{
			var vmodel:L3DModel = new L3DModel();
			vmodel.Import(this);
			var mesh:L3DMesh = vmodel.Export(stage3D, boundBoxLines != null && boundBoxLines.length > 0);
			if(mesh != null)
			{
				mesh.AutoRenewID();
			}
			vmodel.Clear();
			return mesh;
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
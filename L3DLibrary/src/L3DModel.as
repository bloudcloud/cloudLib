package
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.UIDUtil;
	
	import L3DLibrary.L3DLibraryEvent;
	
	import Parts.L3DPartCaculation;
	
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.VertexStream;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import alternativa.engine3d.shadows.OmniLightShadow;
	import alternativa.engine3d.utils.Object3DUtils;
	
	public class L3DModel extends EventDispatcher
	{
		private var subsets:Vector.<L3DSubset>;
		private var previewBuffer:ByteArray;
		public var length:int = 0;
		public var width:int = 0;
		public var height:int = 0;
		public var offGround:int = 0;
		public var offBoard:int = 0;
		public var name:String;
		public var code:String;
		public var brand:String;
		public var series:String;
		public var place:String;
		public var price:Number = 0;
		public var mode:int = 0;
		public var family:String = "";
		public var url:String = "";
		private var version:int = 11;
		private var uniqueID:String = "";
		public var windowLength:int = 0;
		public var windowHeight:int = 0;
		public var minWindowLength:int = 1500;
		public var maxWindowLength:int = 6000;
		public var minWindowHeight:int = 2000;
		public var maxWindowHeight:int = 4500;
		public var materialCode:String = "";
		public var moduleCode:String = "";
		public var moduleName:String = "";
		public var layer:int = 0;
		public var caculationBuffer:ByteArray = null;
		public var isPolyMode:Boolean = false;
		public var amendMode:Boolean = false;
		
		public function L3DModel()
		{
			Clear();
		}
		
		public function get Exist():Boolean
		{
			if(subsets == null || subsets.length == 0)
			{
				return false;
			}
			
		/*	for each(var subset:L3DSubset in subsets)
			{
				if(!subset.Exist)
				{
					return false;
				}
			}*/
			
			return true;
		}
		
		public function Clear():void
		{
			previewBuffer = null;
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
			isPolyMode = false;
			if(subsets != null)
			{
				for each(var subset:L3DSubset in subsets)
				{
					if(subset != null)
					{
						subset.Clear();
					}
				}
			}
			subsets = new Vector.<L3DSubset>();
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
			var checkBitmap:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);
			checkBitmap.draw(loaderInfo.loader);	
			
			if(checkBitmap == null)
			{
				return;
			}			
			
			var evt:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.LoadPreview);
			evt.PreviewBitmap = checkBitmap;
			this.dispatchEvent(evt);
		}

		public function get Preview():BitmapData
		{
			return L3DMaterial.LoadBitmapData(previewBuffer);
		}
		
		public function set Preview(bitmapData:BitmapData):void
		{
			previewBuffer = mode == 21 || mode == 28 ? L3DMaterial.BitmapDataToBuffer32(bitmapData) : L3DMaterial.BitmapDataToBuffer(bitmapData);		
		}
		
		public function get Version():int
		{
			return version;
		}
		
		public function Import(model:Mesh, editMode:Boolean = false, autoChangeSubsetName:Boolean = false):Boolean
		{		
			Clear();
			
			if(model == null || model.numChildren == 0)
			{
				return false;
			}
			
			if(model.boundBox == null)
			{
		    	model.boundBox = Object3DUtils.calculateHierarchyBoundBox(model);
			}
			
			if(!editMode && model is L3DMesh)
			{
			    name = (model as L3DMesh).Name;
			    code = (model as L3DMesh).Code;
			    brand = (model as L3DMesh).Brand;
			    series = (model as L3DMesh).Series;
			    place = (model as L3DMesh).Place;
			    price = (model as L3DMesh).Price;
			    mode = (model as L3DMesh).Mode;
				family = (model as L3DMesh).family;
			    windowLength = (model as L3DMesh).WindowLength;
			    windowHeight = (model as L3DMesh).WindowHeight;
			    minWindowLength = (model as L3DMesh).MinWindowLength;
			    maxWindowLength = (model as L3DMesh).MaxWindowLength;
			    minWindowHeight = (model as L3DMesh).MinWindowHeight;
			    maxWindowHeight = (model as L3DMesh).MaxWindowHeight;
			    UniqueID = (model as L3DMesh).UniqueID;
			    materialCode = (model as L3DMesh).MaterialCode;
			    moduleCode = (model as L3DMesh).moduleCode;
			    moduleName = (model as L3DMesh).moduleName;
			    layer = (model as L3DMesh).layer;
				url = (model as L3DMesh).url;
			    caculationBuffer = (model as L3DMesh).caculation == null ? null : (model as L3DMesh).caculation.ToBuffer();
			}
			
			length = int((model.boundBox.maxX - model.boundBox.minX)*model.scaleX);
			width = int((model.boundBox.maxY - model.boundBox.minY)*model.scaleY);
			height = int((model.boundBox.maxZ - model.boundBox.minZ)*model.scaleZ);
			offGround = model is L3DMesh ? (model as L3DMesh).OffGround : 0;
			offBoard = model is L3DMesh ? (model as L3DMesh).OffBoard : 0;
			isPolyMode =  model is L3DMesh ? (model as L3DMesh).isPolyMode : false;
			
			for (var i:int = 0; i < model.numChildren; i++)
			{
				var subsetMesh:Object3D = model.getChildAt(i);
				if(subsetMesh is L3DMesh)
				{
					var mesh:L3DMesh = subsetMesh as L3DMesh;
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name != "L3DSHADOW" && mesh.name != "L3DTOPVIEW")
					{
						if(autoChangeSubsetName || L3DUtils.CheckInvalidCharInWord(mesh.name) || mesh.name == null || mesh.name.length == 0)
						{
						    mesh.name = "SUBSET" + i.toString();
						}
					}
					var subset:L3DSubset = new L3DSubset();
					subset.Import(mesh);
					if(subset.Exist)
					{
						subsets.push(subset);
					}
				}
				else if(subsetMesh is Mesh)
				{
					var imesh:Mesh = Mesh(subsetMesh);
					if(imesh.geometry == null)
					{
						continue;
					}
					if(imesh.name != "L3DSHADOW" && imesh.name != "L3DTOPVIEW")
					{
						if(autoChangeSubsetName || L3DUtils.CheckInvalidCharInWord(imesh.name) || imesh.name == null || imesh.name.length == 0)
						{
						    imesh.name = "SUBSET" + i.toString();
						}
					}
					var subset:L3DSubset = new L3DSubset();
					subset.ImportMesh(imesh);
					if(subset.Exist)
					{
						subsets.push(subset);
					}
				}
			}
			
			return true;
		}
		
		public function Update(model:Mesh, autoChangeSubsetName:Boolean = false):Boolean
		{		
			Clear();
			
			if(model == null || model.numChildren == 0)
			{
				return false;
			}
			
			if(model.boundBox == null)
			{
				model.boundBox = Object3DUtils.calculateHierarchyBoundBox(model);
			}
			
			length = int((model.boundBox.maxX - model.boundBox.minX)*model.scaleX);
			width = int((model.boundBox.maxY - model.boundBox.minY)*model.scaleY);
			height = int((model.boundBox.maxZ - model.boundBox.minZ)*model.scaleZ);
			offGround = model is L3DMesh ? (model as L3DMesh).OffGround : 0;
			offBoard = model is L3DMesh ? (model as L3DMesh).OffBoard : 0;
			isPolyMode = model is L3DMesh ? (model as L3DMesh).isPolyMode : false;
			
			for (var i:int = 0; i < model.numChildren; i++)
			{
				var subsetMesh:Object3D = model.getChildAt(i);
				if(subsetMesh is Mesh)
				{
					var mesh:Mesh = Mesh(subsetMesh);
					if(mesh.geometry == null)
					{
						continue;
					}
					if(mesh.name != "L3DSHADOW" && mesh.name != "L3DTOPVIEW")
					{
						if(autoChangeSubsetName || L3DUtils.CheckInvalidCharInWord(mesh.name) || mesh.name == null || mesh.name.length == 0)
						{
						    mesh.name = "SUBSET" + i.toString();
						}
					}
					var subset:L3DSubset = new L3DSubset();
					subset.Update(mesh);
					if(subset.Exist)
					{
						subsets.push(subset);
					}
				}
			}
			
			return true;
		}
		
		public function Export(stage3D:Stage3D, buildBoundBox:Boolean = true, editMode:Boolean = false, uploadData:Boolean = true):L3DMesh
		{
			if(stage3D == null || !Exist)
			{
				return null;
			}
			
			var exportMesh:L3DMesh = new L3DMesh();
			exportMesh.name = name;
			
			for each(var subset:L3DSubset in subsets)
			{
				var mesh:L3DMesh = null;
				switch(version)
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
						mesh = subset.ExportVersionUpTo8(stage3D, editMode);
					}
						break;
					default:
					{
						mesh = subset.Export(stage3D, editMode);
					}
						break;
				}
				if(mesh != null)
				{
					exportMesh.addChild(mesh);
					if(editMode)
					{
						exportMesh.HaveOriginalTransparencyMaps.push(subset.HaveOriginalTransparencyMap);
					}
					else
					{
						mesh.caculation.CombinedMesh = exportMesh;
						mesh.WindowLength = windowLength;
						mesh.WindowHeight = windowHeight;
						mesh.MinWindowLength = minWindowLength;
						mesh.MaxWindowLength = maxWindowLength;
						mesh.MinWindowHeight = minWindowHeight;
						mesh.MaxWindowHeight = maxWindowHeight;
					}
				}
			}
			
			if(exportMesh.numChildren == 0)
			{
				return null;
			}
			
			exportMesh.Name = name;
			exportMesh.Code = code;
			exportMesh.Brand = brand;
			exportMesh.Series = series;
			exportMesh.Place = place;
			exportMesh.Price = price;
			exportMesh.Length = length;
			exportMesh.Width = width;
			exportMesh.Height = height;
			exportMesh.OffGround = offGround;
			exportMesh.OffBoard = offBoard;
			exportMesh.Mode = mode;
			exportMesh.family = family;
			exportMesh.WindowLength = windowLength;
			exportMesh.WindowHeight = windowHeight;
			exportMesh.MinWindowLength = minWindowLength;
			exportMesh.MaxWindowLength = maxWindowLength;
			exportMesh.MinWindowHeight = minWindowHeight;
			exportMesh.MaxWindowHeight = maxWindowHeight;
			exportMesh.UniqueID = uniqueID;
			if(exportMesh.UniqueID == null || exportMesh.UniqueID.length == 0)
			{
				exportMesh.AutoRenewID();
			}
			exportMesh.MaterialCode = materialCode;
			exportMesh.moduleCode = moduleCode;
			exportMesh.moduleName = moduleName;
			exportMesh.layer = layer;
			exportMesh.url = url;
			exportMesh.isPolyMode = isPolyMode;
			if(exportMesh.caculation == null)
			{
				exportMesh.caculation = new L3DPartCaculation(exportMesh, null);
			}
			exportMesh.caculation.FromBuffer(caculationBuffer);
			
			exportMesh.matrix = new Matrix3D();
			exportMesh.matrix.identity();
			
			if(version < 6 || mode == 5)
			{
				switch(mode)
				{
					case 0:
					case 3:
					case 4:
					case 8:
					case 9:
					case 11:
					{
						exportMesh.Align(0);
					}
						break;
					case 1:
					{
						exportMesh.Align(1);
					}
						break;
					case 2:
					case 7:
					{
						exportMesh.Align(2);
					}
						break;
					case 5:
					{
						exportMesh.Align(3);
					}
						break;
					case 6:
					{
						exportMesh.Align(4);
					}
						break;
					case 10:
					{
						exportMesh.Align(5);
					}
						break;
					default:
					{
						exportMesh.Align(0);
					}
						break;
				}
			}
			
			if(editMode)
			{
				exportMesh.PreviewBuffer = previewBuffer;
			}
			else
			{
				if(buildBoundBox)
				{
					exportMesh.BuildBoundBox();
				}
			}
			
			exportMesh.ShowTopView = false;			
			exportMesh.caculation.Amend();
			
			if(uploadData)
			{
				UploadResources(exportMesh, stage3D.context3D);
			}
			return exportMesh;
		}
		
		private static function UploadResources(object:Object3D, context:Context3D):void
		{
			for each (var res:Resource in object.getResources(true))
			{
				try
				{
					res.upload(context);
				}
				catch(error:Error)
				{
					
				}				
			}
		}	
		
		public function ToBuffer():ByteArray
		{
			version = 11;
			var buffer:ByteArray = new ByteArray();
			buffer.writeInt(version);
			if(previewBuffer == null || previewBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(previewBuffer.length);
				buffer.writeBytes(previewBuffer,0,previewBuffer.length);
			}
			buffer.writeInt(length);
			buffer.writeInt(width);
			buffer.writeInt(height);
			buffer.writeInt(offGround);
			buffer.writeInt(offBoard);
			WriteString(buffer, name);
			WriteString(buffer, code);
			WriteString(buffer, brand);
			WriteString(buffer, series);
			WriteString(buffer, place);
			buffer.writeFloat(price);
			buffer.writeInt(mode);
			WriteString(buffer, uniqueID);
			buffer.writeInt(windowLength);
			buffer.writeInt(windowHeight);
			buffer.writeInt(minWindowLength);
			buffer.writeInt(maxWindowLength);
			buffer.writeInt(minWindowHeight);
			buffer.writeInt(maxWindowHeight);
			WriteString(buffer, materialCode);
			WriteString(buffer, moduleCode);
			WriteString(buffer, moduleName);
			buffer.writeInt(layer);
			buffer.writeInt(isPolyMode ? 1 : 0);
			if(caculationBuffer == null || caculationBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(caculationBuffer.length);
				buffer.writeBytes(caculationBuffer,0, caculationBuffer.length);
			}
			if(subsets == null || subsets.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(subsets.length);
				for each(var subset:L3DSubset in subsets)
				{
					var subsetBuffer:ByteArray = subset.ToBuffer();
					if(subsetBuffer == null || subsetBuffer.length == 0)
					{
						buffer.writeInt(0);
					}
					else
					{
						buffer.writeInt(subsetBuffer.length);
						buffer.writeBytes(subsetBuffer,0,subsetBuffer.length);
					}
				}
			}
			return buffer;
		}
		
		public static function FromBuffer(buffer:ByteArray, amendMode:Boolean = false):L3DModel
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			
			var l3dmodel:L3DModel = new L3DModel();
			l3dmodel.amendMode = amendMode;
			l3dmodel.version = buffer.readInt();
			var l:int = buffer.readInt();
			if(l > 0)
			{
				l3dmodel.previewBuffer = new ByteArray();
				buffer.readBytes(l3dmodel.previewBuffer, 0, l);
			}
			l3dmodel.length = buffer.readInt();
			l3dmodel.width = buffer.readInt();
			l3dmodel.height = buffer.readInt();
			if(l3dmodel.version > 6)
			{
				l3dmodel.offGround = buffer.readInt();
				if(l3dmodel.version > 10)
				{
					l3dmodel.offBoard = buffer.readInt();
				}
			}
			l3dmodel.name = ReadString(buffer);
			l3dmodel.code = ReadString(buffer);
			l3dmodel.brand = ReadString(buffer);
			l3dmodel.series = ReadString(buffer);
			l3dmodel.place = ReadString(buffer);
			l3dmodel.price = buffer.readFloat();
			l3dmodel.mode = buffer.readInt();

			switch(l3dmodel.version)
			{
				case 4:
				{
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
				}
				break;
				case 5:
				{
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
					buffer.readInt();
                    l3dmodel.uniqueID = ReadString(buffer);
					l3dmodel.windowLength = buffer.readInt();
					l3dmodel.windowHeight = buffer.readInt();
					l3dmodel.minWindowLength = buffer.readInt();
					l3dmodel.maxWindowLength = buffer.readInt();
					l3dmodel.minWindowHeight = buffer.readInt();
					l3dmodel.maxWindowHeight = buffer.readInt();
					l3dmodel.materialCode = ReadString(buffer);
					l3dmodel.moduleCode = ReadString(buffer);
					l3dmodel.moduleName = ReadString(buffer);
					l3dmodel.layer = buffer.readInt();
					var count:int = buffer.readInt();
					if(count > 0)
					{
						l3dmodel.caculationBuffer = new ByteArray();
						buffer.readBytes(l3dmodel.caculationBuffer,0,count);
					}
				}
				break;
				case 6:
				case 7:
				case 8:
				case 9:
				case 10:
				case 11:
				{
					l3dmodel.uniqueID = ReadString(buffer);
					l3dmodel.windowLength = buffer.readInt();
					l3dmodel.windowHeight = buffer.readInt();
					l3dmodel.minWindowLength = buffer.readInt();
					l3dmodel.maxWindowLength = buffer.readInt();
					l3dmodel.minWindowHeight = buffer.readInt();
					l3dmodel.maxWindowHeight = buffer.readInt();
					l3dmodel.materialCode = ReadString(buffer);
					l3dmodel.moduleCode = ReadString(buffer);
					l3dmodel.moduleName = ReadString(buffer);
					l3dmodel.layer = buffer.readInt();
					if(l3dmodel.version > 9)
					{
						l3dmodel.isPolyMode = buffer.readInt() > 0;
					}
					var count:int = buffer.readInt();
					if(count > 0)
					{
						l3dmodel.caculationBuffer = new ByteArray();
						buffer.readBytes(l3dmodel.caculationBuffer,0,count);
					}
				}
				break;
			}
			var numberSubsets:int = buffer.readInt();
			if(numberSubsets > 0)
			{
				for(var i:int = 0;i< numberSubsets;i++)
				{
					var sl:int = buffer.readInt();
					if(sl > 0)
					{
						var subsetBuffer:ByteArray = new ByteArray();
						buffer.readBytes(subsetBuffer,0,sl);
						var subset:L3DSubset = null;
						switch(l3dmodel.version)
						{
							case 0:
							    {
							    	subset = L3DSubset.FromBufferVersion0(subsetBuffer, amendMode);
							    }
							break;
							case 1:
						    	{
						    		subset = L3DSubset.FromBufferVersion1(subsetBuffer, amendMode);
						    	}
							break;
							case 2:
						    	{
						    		subset = L3DSubset.FromBufferVersion2(subsetBuffer, amendMode);
						     	}
								break;
							case 3:
							case 4:
								{
								    subset = L3DSubset.FromBufferVersion3and4(subsetBuffer, amendMode);
								}
								break;
							case 5:
							    {
								    subset = L3DSubset.FromBufferVersion5(subsetBuffer, amendMode);
							    }
								break;
							case 6:
							case 7:
							    {
							    	subset = L3DSubset.FromBufferVersion6and7(subsetBuffer, amendMode);
							    }
								break;
							case 8:
						    	{
						    		subset = L3DSubset.FromBufferVersion8(subsetBuffer, amendMode);
						    	}
								break;
							case 9:
							    {
								    subset = L3DSubset.FromBufferVersion9(subsetBuffer, amendMode);
							    }
								break;
							default:
						    	{
							    	subset = L3DSubset.FromBuffer(subsetBuffer, amendMode);
						    	}
								break;
						}
						if(subset != null && subset.Exist)
						{
							l3dmodel.subsets.push(subset);
						}
					}
				}
			}
			
			return l3dmodel;
		}
		
		public static function WriteString(buffer:ByteArray, text:String):Boolean
		{
			if(buffer == null)
			{
				return false;
			}
			
			if(text == null || text.length == 0)
			{
				buffer.writeInt(0);
				return true;
			}
			
			var textBuffer:ByteArray = new ByteArray();
			textBuffer.writeUTFBytes(text);
			buffer.writeInt(textBuffer.length);
			buffer.writeBytes(textBuffer,0,textBuffer.length);
			
			return true;
		}
		
		public static function ReadString(buffer:ByteArray):String
		{
			if(buffer == null)
			{
				return "";
			}
			
			var l:int = buffer.readInt();
			if(l == 0)
			{
				return "";
			}
			
			var textBuffer:ByteArray = new ByteArray();
			buffer.readBytes(textBuffer,0,l);
			textBuffer.position = 0;
			
			return textBuffer.readUTFBytes(textBuffer.length);
		}
		
		public static function get IdentityMatrix3D():Matrix3D
		{
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			return matrix;
		}	
	}
}
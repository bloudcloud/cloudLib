package
{	
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	
	import L3DLibrary.LivelyLibrary;
	
	import Parts.L3DPartCaculation;
	
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.EnvironmentMaterial;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.singles.CL3DModuleUtil;
	
	public class L3DSubset
	{
		private var name:String;
		private var numberVertices:int;
		private var numberFaces:int;
		private var vertices:Vector.<Number>;
		private var normals:Vector.<Number>;
		private var texture0:Vector.<Number>;
		private var texture1:Vector.<Number>;
		private var texture2:Vector.<Number>;
		private var indices:Vector.<uint>;
		private var alpha:Number = 1.0;
		private var alphaThreshold:Number = 0;
		private var glossiness:Number = 100;
		private var specularPower:Number = 1;
		private var color:uint = 0xFFFFFF;
		private var transparencyColor:uint;
		private var materialMode:int = 0;
		private var isLight:Boolean = false;
		private var lightWattage:int = 50;
		private var lightColor:uint = 0xFFFFFF;
		private var lightMode:int = 0;
		private var diffuseBuffer:ByteArray;
		private var normalBuffer:ByteArray;
		private var shininessBuffer:ByteArray;
		private var specularBuffer:ByteArray;
		private var emissionBuffer:ByteArray;
		private var transparentBuffer:ByteArray;
		private var haveOriginalTransparencyMap:Boolean = false;
		private var caculationBuffer:ByteArray = null;
		private var uniqueID:String = "";
		private var moduleCode:String = "";
		private var moduleName:String = "";
		private var layer:int = 0;
		private var family:String = "";
		private var exportNormals:Boolean = true;
		private var amendMode:Boolean = false;
		
		public function L3DSubset()
		{
			Clear();
		}
		
		public function Clear():void
		{
			name = "";
			numberVertices = 0;
			numberFaces = 0;
			vertices = null;
			normals = null;
			texture0 = null;
			texture1 = null;
			texture2 = null;
			indices = null;
			alpha = 1.0;
			alphaThreshold = 0;
			glossiness = 200;
			specularPower = 1;
			materialMode = 0;
			isLight = false;
			lightWattage = 50;
			lightColor = 0xFFFFFF;
			lightMode = 0;
			if(diffuseBuffer != null)
			{
				diffuseBuffer.clear();
				diffuseBuffer = null;
			}
			if(normalBuffer != null)
			{
				normalBuffer.clear();
				normalBuffer = null;
			}
			if(shininessBuffer != null)
			{
				shininessBuffer.clear();
				shininessBuffer = null;
			}
			if(specularBuffer != null)
			{
				specularBuffer.clear();
				specularBuffer = null;
			}
			if(emissionBuffer != null)
			{
				emissionBuffer.clear();
				emissionBuffer = null;
			}
			if(transparentBuffer != null)
			{
				transparentBuffer.clear();
				transparentBuffer = null;
			}
			if(caculationBuffer != null)
			{
				caculationBuffer.clear();
				caculationBuffer = null;
			}
			uniqueID = "";
			moduleCode = "";
			moduleName = "";
			layer = 0;
			family = "";
			exportNormals = true;
		}
		
		public function get Exist():Boolean
		{
			if(numberVertices > 0 && numberFaces > 0 && vertices != null && vertices.length > 0 && indices != null && indices.length > 0)
			{
				return true;
			}
			
			return false;
		}
		
		public function get HaveOriginalTransparencyMap():Boolean
		{
			return haveOriginalTransparencyMap;
		}

		public function ImportMesh(subset:Mesh):Boolean
		{
			Clear();
			
			if(subset == null || subset.geometry == null)
			{
				return false;
			}
			
			var mesh:Mesh = Mesh(subset);
			if(mesh.geometry == null)
			{
				return false;
			}
			name = mesh.name;
			materialMode = mesh is L3DMesh ? (mesh as L3DMesh).MaterialMode : (mesh.userData as RelatingParams).materialMode;
			isLight = mesh is L3DMesh ? (mesh as L3DMesh).IsLight : (mesh.userData as RelatingParams).isLight;
			lightWattage = mesh is L3DMesh ? (mesh as L3DMesh).LightWattage : (mesh.userData as RelatingParams).lightWattage;
			lightColor = mesh is L3DMesh ? (mesh as L3DMesh).LightColor : (mesh.userData as RelatingParams).lightColor;
			family = mesh is L3DMesh ? (mesh as L3DMesh).family : "";
			numberVertices = mesh.geometry.numVertices;
			numberFaces = mesh.geometry.numTriangles;
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			var havePositions:Boolean = false;
			var haveNormals:Boolean = false;
			var haveTexture0:Boolean = false;
			var haveTexture1:Boolean = false;
			var haveTexture2:Boolean = false;			
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.POSITION:
					{
						havePositions = true;
					}
						break;
					case VertexAttributes.NORMAL:
					{
						haveNormals = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[0]:
					{
						haveTexture0 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[1]:
					{
						haveTexture1 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[2]:
					{
						haveTexture2 = true;
					}
						break;
				}
			}
			if(!havePositions)
			{
				return false;
			}
			vertices = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			if(haveNormals)
			{
				normals = mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			if(haveTexture0)
			{
				texture0 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
				if(haveTexture1)
				{
					texture1 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[1]);
					if(haveTexture2)
					{
						texture2 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[2]);
					}
				}
			}
			indices = mesh.geometry.indices;
			
			for (var i:int = 0; i < mesh.numSurfaces; i++)
			{
				var surface:Surface = mesh.getSurface(i) as Surface;
				var material:Material = surface.material;
				if (material != null) 
				{
					if(material is FillMaterial)
					{
						alpha = (material as FillMaterial).alpha;
						color = (material as FillMaterial).color;
					}
					else if(material is StandardMaterial)
					{
						var checkMaterial:StandardMaterial = material as StandardMaterial;
						alpha = checkMaterial.alpha;
						alphaThreshold = checkMaterial.alphaThreshold;
						glossiness = checkMaterial.glossiness;
						specularPower = checkMaterial.specularPower;
						if(checkMaterial.diffuseMap != null)
						{
							if(checkMaterial.diffuseMap is ExternalTextureResource)
							{
								diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.diffuseMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.normalMap != null)
						{
							if(checkMaterial.normalMap is ExternalTextureResource)
							{
								normalBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.normalMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.normalMap is BitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.normalMap is CBitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.glossinessMap != null)
						{
							if(checkMaterial.glossinessMap is ExternalTextureResource)
							{
								shininessBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.glossinessMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.glossinessMap is BitmapTextureResource)
							{
								shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.glossinessMap is CBitmapTextureResource)
							{
								shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.specularMap != null)
						{
							if(checkMaterial.specularMap is ExternalTextureResource)
							{
								specularBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.specularMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.specularMap is BitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.specularMap is CBitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.lightMap != null)
						{
							if(checkMaterial.lightMap is ExternalTextureResource)
							{
								emissionBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.lightMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.lightMap is BitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.lightMap is CBitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.opacityMap != null)
						{
							if(checkMaterial.opacityMap is ExternalTextureResource)
							{
								transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.opacityMap as ExternalTextureResource).url);
							}
							else if(checkMaterial.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as CBitmapTextureResource).data);
							}
						}						
					}
					else if(material is TextureMaterial)
					{
						var checkMaterial2:TextureMaterial = material as TextureMaterial;
						alpha = checkMaterial2.alpha;
						alphaThreshold = checkMaterial2.alphaThreshold;						
						if(checkMaterial2.diffuseMap != null)
						{
							if(checkMaterial2.diffuseMap is ExternalTextureResource)
							{
								diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial2.diffuseMap as ExternalTextureResource).url);
							}
							else if(checkMaterial2.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMaterial2.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer=L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial2.opacityMap != null)
						{
							if(checkMaterial2.opacityMap is ExternalTextureResource)
							{
								transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial2.opacityMap as ExternalTextureResource).url);
							}
							else if(checkMaterial2.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMaterial2.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer=L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as CBitmapTextureResource).data);
							}
						}	
					}
				}
			}			
			
			return Exist;
		}

		
		public function Import(subset:L3DMesh):Boolean
		{
			Clear();
			
			if(subset == null || subset.geometry == null)
			{
				return false;
			}
			
			var mesh:L3DMesh = subset;
			if(mesh.geometry == null)
			{
				return false;
			}
			name = mesh.name;
			materialMode = mesh.MaterialMode;
			isLight = mesh.IsLight;
			lightWattage = mesh.LightWattage;
			lightColor = mesh.LightColor;
			lightMode = mesh.LightMode;
			uniqueID = mesh.UniqueID;
			moduleCode = mesh.moduleCode;
			moduleName = mesh.moduleName;
			layer = mesh.layer;
			family = mesh.family;
			exportNormals = mesh.exportNormals;
			caculationBuffer = mesh.caculation.ToBuffer();
			numberVertices = mesh.geometry.numVertices;
			numberFaces = mesh.geometry.numTriangles;
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			var havePositions:Boolean = false;
			var haveNormals:Boolean = false;
			var haveTexture0:Boolean = false;
			var haveTexture1:Boolean = false;
			var haveTexture2:Boolean = false;			
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.POSITION:
					{
						havePositions = true;
					}
						break;
					case VertexAttributes.NORMAL:
					{
						haveNormals = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[0]:
					{
						haveTexture0 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[1]:
					{
						haveTexture1 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[2]:
					{
						haveTexture2 = true;
					}
						break;
				}
			}
			if(!havePositions)
			{
				return false;
			}
			vertices = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			if(haveNormals)
			{
				normals = mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			if(haveTexture0)
			{
				texture0 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
				if(haveTexture1)
				{
					texture1 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[1]);
					if(haveTexture2)
					{
						texture2 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[2]);
					}
				}
			}
			indices = mesh.geometry.indices;
			
			for (var i:int = 0; i < mesh.numSurfaces; i++)
			{
				var surface:Surface = mesh.getSurface(i) as Surface;
				var material:Material = surface.material;
				if (material != null) 
				{
					if(material is FillMaterial)
					{
						alpha = (material as FillMaterial).alpha;
						color = (material as FillMaterial).color;
					}
					else if(material is EnvironmentMaterial)
					{
						var checkMateriale:EnvironmentMaterial = material as EnvironmentMaterial;
						alpha = checkMateriale.alpha;
						alphaThreshold = checkMateriale.alphaThreshold;		
						specularPower = checkMateriale.reflection;
						if(checkMateriale.diffuseMap != null)
						{
							if(checkMateriale.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMateriale.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMateriale.normalMap != null)
						{
							if(checkMateriale.normalMap is BitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.normalMap as BitmapTextureResource).data);
							}
							else if(checkMateriale.normalMap is CBitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.normalMap as CBitmapTextureResource).data);
							}
						}
						if(checkMateriale.lightMap != null)
						{
							if(checkMateriale.lightMap is BitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.lightMap as BitmapTextureResource).data);
							}
							else if(checkMateriale.lightMap is CBitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.lightMap as CBitmapTextureResource).data);
							}
						}
						if(checkMateriale.reflectionMap != null)
						{
							if(checkMateriale.reflectionMap is BitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.reflectionMap as BitmapTextureResource).data);
							}
							else if(checkMateriale.reflectionMap is CBitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.reflectionMap as CBitmapTextureResource).data);
							}
						}
						if(checkMateriale.opacityMap != null)
						{
							if(checkMateriale.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMateriale.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.opacityMap as CBitmapTextureResource).data);
							}
						}	
					}
					else if(material is LightMapMaterial)
					{
						var checkMaterial3:LightMapMaterial = material as LightMapMaterial;
						alpha = checkMaterial3.alpha;
						alphaThreshold = checkMaterial3.alphaThreshold;						
						if(checkMaterial3.diffuseMap != null)
						{
							if(checkMaterial3.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMaterial3.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial3.lightMap != null)
						{
							if(checkMaterial3.lightMap is BitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.lightMap as BitmapTextureResource).data);
							}
							else if(checkMaterial3.lightMap is CBitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.lightMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial3.opacityMap != null)
						{
							if(checkMaterial3.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMaterial3.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.opacityMap as CBitmapTextureResource).data);
							}
						}	
					}
					else if(material is StandardMaterial)
					{
						var checkMaterial:StandardMaterial = material as StandardMaterial;
						alpha = checkMaterial.alpha;
						alphaThreshold = checkMaterial.alphaThreshold;
						glossiness = checkMaterial.glossiness;
						specularPower = checkMaterial.specularPower;
						if(checkMaterial.diffuseMap != null)
						{
                            if(checkMaterial.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.normalMap != null)
						{
                            if(checkMaterial.normalMap is BitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.normalMap is CBitmapTextureResource)
							{
								normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.glossinessMap != null)
						{
                            if(checkMaterial.glossinessMap is BitmapTextureResource)
							{
								shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.glossinessMap is CBitmapTextureResource)
							{
								shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.specularMap != null)
						{
                            if(checkMaterial.specularMap is BitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.specularMap is CBitmapTextureResource)
							{
								specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.lightMap != null)
						{
                            if(checkMaterial.lightMap is BitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.lightMap is CBitmapTextureResource)
							{
								emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial.opacityMap != null)
						{
                            if(checkMaterial.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMaterial.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as CBitmapTextureResource).data);
							}
						}						
					}
					else if(material is TextureMaterial)
					{
						var checkMaterial2:TextureMaterial = material as TextureMaterial;
						alpha = checkMaterial2.alpha;
						alphaThreshold = checkMaterial2.alphaThreshold;						
						if(checkMaterial2.diffuseMap != null)
						{
                            if(checkMaterial2.diffuseMap is BitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as BitmapTextureResource).data);
							}
							else if(checkMaterial2.diffuseMap is CBitmapTextureResource)
							{
								diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as CBitmapTextureResource).data);
							}
						}
						if(checkMaterial2.opacityMap != null)
						{
                            if(checkMaterial2.opacityMap is BitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.opacityMap as BitmapTextureResource).data);
							}
							else if(checkMaterial2.opacityMap is CBitmapTextureResource)
							{
								transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.opacityMap as CBitmapTextureResource).data);
							}
						}	
					}
				}
			}			
			
			return Exist;
		}
		
		public function Update(subset:Mesh):Boolean
		{
			Clear();
			
			if(subset == null || subset.geometry == null)
			{
				return false;
			}
			
			var mesh:Mesh = Mesh(subset);
			if(mesh.geometry == null)
			{
				return false;
			}
			name = mesh.name;
			materialMode = mesh is L3DMesh ? (mesh as L3DMesh).MaterialMode : (mesh.userData as RelatingParams).materialMode;
			isLight = mesh is L3DMesh ? (mesh as L3DMesh).IsLight : (mesh.userData as RelatingParams).isLight;
			lightWattage = mesh is L3DMesh ? (mesh as L3DMesh).LightWattage : (mesh.userData as RelatingParams).lightWattage;
			lightColor = mesh is L3DMesh ? (mesh as L3DMesh).LightColor : (mesh.userData as RelatingParams).lightColor;
			lightMode = mesh is L3DMesh ? (mesh as L3DMesh).LightMode : (mesh.userData as RelatingParams).lightMode;
			exportNormals = mesh is L3DMesh ? (mesh as L3DMesh).exportNormals : (mesh.userData as RelatingParams).exportNormals;
			family = mesh is L3DMesh ? (mesh as L3DMesh).family : "";
			numberVertices = mesh.geometry.numVertices;
			numberFaces = mesh.geometry.numTriangles;
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			var havePositions:Boolean = false;
			var haveNormals:Boolean = false;
			var haveTexture0:Boolean = false;
			var haveTexture1:Boolean = false;
			var haveTexture2:Boolean = false;
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.POSITION:
					{
						havePositions = true;
					}
						break;
					case VertexAttributes.NORMAL:
					{
						haveNormals = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[0]:
					{
						haveTexture0 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[1]:
					{
						haveTexture1 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[2]:
					{
						haveTexture2 = true;
					}
						break;
				}
			}
			if(!havePositions)
			{
				return false;
			}
			vertices = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			if(haveNormals)
			{
				normals = mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			if(haveTexture0)
			{
				texture0 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
				if(haveTexture1)
				{
					texture1 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[1]);
					if(haveTexture2)
					{
						texture2 = mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[2]);
					}
				}
			}
			indices = mesh.geometry.indices;
			
			for (var i:int = 0; i < mesh.numSurfaces; i++)
			{
				var surface:Surface = mesh.getSurface(i) as Surface;
				var material:Material = surface.material;
				if (material != null) 
				{
					if(material is FillMaterial)
					{
						alpha = (material as FillMaterial).alpha;
						color = (material as FillMaterial).color;
					}
					else if(material is StandardMaterial)
					{
						alpha = (material as StandardMaterial).alpha;
						alphaThreshold = (material as StandardMaterial).alphaThreshold;
						specularPower = (material as StandardMaterial).specularPower;
						var checkMaterial:StandardMaterial = material as StandardMaterial;
						if(checkMaterial.diffuseMap != null && checkMaterial.diffuseMap is ExternalTextureResource)
						{
							diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.diffuseMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.diffuseMap != null && checkMaterial.diffuseMap is BitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.diffuseMap != null && checkMaterial.diffuseMap is CBitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.diffuseMap as CBitmapTextureResource).data);
						}
						if(checkMaterial.normalMap != null && checkMaterial.normalMap is ExternalTextureResource)
						{
							normalBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.normalMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.normalMap != null && checkMaterial.normalMap is BitmapTextureResource)
						{
							normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.normalMap != null && checkMaterial.normalMap is CBitmapTextureResource)
						{
							normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.normalMap as CBitmapTextureResource).data);
						}
						if(checkMaterial.glossinessMap != null && checkMaterial.glossinessMap is ExternalTextureResource)
						{
							shininessBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.glossinessMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.glossinessMap != null && checkMaterial.glossinessMap is BitmapTextureResource)
						{
							shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.glossinessMap != null && checkMaterial.glossinessMap is CBitmapTextureResource)
						{
							shininessBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.glossinessMap as CBitmapTextureResource).data);
						}
						if(checkMaterial.specularMap != null && checkMaterial.specularMap is ExternalTextureResource)
						{
							specularBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.specularMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.specularMap != null && checkMaterial.specularMap is BitmapTextureResource)
						{
							specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.specularMap != null && checkMaterial.specularMap is CBitmapTextureResource)
						{
							specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.specularMap as CBitmapTextureResource).data);
						}
						if(checkMaterial.lightMap != null && checkMaterial.lightMap is ExternalTextureResource)
						{
							emissionBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.lightMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.lightMap != null && checkMaterial.lightMap is BitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.lightMap != null && checkMaterial.lightMap is CBitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.lightMap as CBitmapTextureResource).data);
						}
						if(checkMaterial.opacityMap != null && checkMaterial.opacityMap is ExternalTextureResource)
						{
							transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial.opacityMap as ExternalTextureResource).url);
						}
						else if(checkMaterial.opacityMap != null && checkMaterial.opacityMap is BitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as BitmapTextureResource).data);
						}
						else if(checkMaterial.opacityMap != null && checkMaterial.opacityMap is CBitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial.opacityMap as CBitmapTextureResource).data);
						}
					}
					else if(material is EnvironmentMaterial)
					{
						alpha = (material as EnvironmentMaterial).alpha;
						alphaThreshold = (material as EnvironmentMaterial).alphaThreshold;
						specularPower = (material as EnvironmentMaterial).reflection;
						var checkMateriale:EnvironmentMaterial = material as EnvironmentMaterial;
						if(checkMateriale.diffuseMap != null && checkMateriale.diffuseMap is ExternalTextureResource)
						{
							diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMateriale.diffuseMap as ExternalTextureResource).url);
						}
						else if(checkMateriale.diffuseMap != null && checkMateriale.diffuseMap is BitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.diffuseMap as BitmapTextureResource).data);
						}
						else if(checkMateriale.diffuseMap != null && checkMateriale.diffuseMap is CBitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.diffuseMap as CBitmapTextureResource).data);
						}
						if(checkMateriale.normalMap != null && checkMateriale.normalMap is ExternalTextureResource)
						{
							normalBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMateriale.normalMap as ExternalTextureResource).url);
						}
						else if(checkMateriale.normalMap != null && checkMateriale.normalMap is BitmapTextureResource)
						{
							normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.normalMap as BitmapTextureResource).data);
						}
						else if(checkMateriale.normalMap != null && checkMateriale.normalMap is CBitmapTextureResource)
						{
							normalBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.normalMap as CBitmapTextureResource).data);
						}
						if(checkMateriale.lightMap != null && checkMateriale.lightMap is ExternalTextureResource)
						{
							emissionBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMateriale.lightMap as ExternalTextureResource).url);
						}
						else if(checkMateriale.lightMap != null && checkMateriale.lightMap is BitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.lightMap as BitmapTextureResource).data);
						}
						else if(checkMateriale.lightMap != null && checkMateriale.lightMap is CBitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.lightMap as CBitmapTextureResource).data);
						}
						if(checkMateriale.reflectionMap != null && checkMateriale.reflectionMap is ExternalTextureResource)
						{
							specularBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMateriale.reflectionMap as ExternalTextureResource).url);
						}
						else if(checkMateriale.reflectionMap != null && checkMateriale.reflectionMap is BitmapTextureResource)
						{
							specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.reflectionMap as BitmapTextureResource).data);
						}
						else if(checkMateriale.reflectionMap != null && checkMateriale.reflectionMap is CBitmapTextureResource)
						{
							specularBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.reflectionMap as CBitmapTextureResource).data);
						}
						if(checkMateriale.opacityMap != null && checkMateriale.opacityMap is ExternalTextureResource)
						{
							transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMateriale.opacityMap as ExternalTextureResource).url);
						}
						else if(checkMateriale.opacityMap != null && checkMateriale.opacityMap is BitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.opacityMap as BitmapTextureResource).data);
						}
						else if(checkMateriale.opacityMap != null && checkMateriale.opacityMap is CBitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMateriale.opacityMap as CBitmapTextureResource).data);
						}
					}
					else if(material is LightMapMaterial)
					{
						alpha = (material as LightMapMaterial).alpha;
						alphaThreshold = (material as LightMapMaterial).alphaThreshold;
						var checkMaterial2:LightMapMaterial = material as LightMapMaterial;
						if(checkMaterial2.diffuseMap != null && checkMaterial2.diffuseMap is ExternalTextureResource)
						{
							diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial2.diffuseMap as ExternalTextureResource).url);
						}
						else if(checkMaterial2.diffuseMap != null && checkMaterial2.diffuseMap is BitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as BitmapTextureResource).data);
						}
						else if(checkMaterial2.diffuseMap != null && checkMaterial2.diffuseMap is CBitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.diffuseMap as CBitmapTextureResource).data);
						}
						if(checkMaterial2.lightMap != null && checkMaterial2.lightMap is ExternalTextureResource)
						{
							emissionBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial2.lightMap as ExternalTextureResource).url);
						}
						else if(checkMaterial2.lightMap != null && checkMaterial2.lightMap is BitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.lightMap as BitmapTextureResource).data);
						}
						else if(checkMaterial2.lightMap != null && checkMaterial2.lightMap is CBitmapTextureResource)
						{
							emissionBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.lightMap as CBitmapTextureResource).data);
						}
						if(checkMaterial2.opacityMap != null && checkMaterial2.opacityMap is ExternalTextureResource)
						{
							transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial2.opacityMap as ExternalTextureResource).url);
						}
						else if(checkMaterial2.opacityMap != null && checkMaterial2.opacityMap is BitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.opacityMap as BitmapTextureResource).data);
						}
						else if(checkMaterial2.opacityMap != null && checkMaterial2.opacityMap is CBitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial2.opacityMap as CBitmapTextureResource).data);
						}
					}
					else if(material is TextureMaterial)
					{
						alpha = (material as TextureMaterial).alpha;
						alphaThreshold = (material as TextureMaterial).alphaThreshold;
						var checkMaterial3:TextureMaterial = material as TextureMaterial;
						if(checkMaterial3.diffuseMap != null && checkMaterial3.diffuseMap is ExternalTextureResource)
						{
							diffuseBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial3.diffuseMap as ExternalTextureResource).url);
						}
						else if(checkMaterial3.diffuseMap != null && checkMaterial3.diffuseMap is BitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.diffuseMap as BitmapTextureResource).data);
						}
						else if(checkMaterial3.diffuseMap != null && checkMaterial3.diffuseMap is CBitmapTextureResource)
						{
							diffuseBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.diffuseMap as CBitmapTextureResource).data);
						}
						if(checkMaterial3.opacityMap != null && checkMaterial3.opacityMap is ExternalTextureResource)
						{
							transparentBuffer = L3DMaterial.LoadFileEncodingBuffer((checkMaterial3.opacityMap as ExternalTextureResource).url);
						}
						else if(checkMaterial3.opacityMap != null && checkMaterial3.opacityMap is BitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.opacityMap as BitmapTextureResource).data);
						}
						else if(checkMaterial3.opacityMap != null && checkMaterial3.opacityMap is CBitmapTextureResource)
						{
							transparentBuffer = L3DMaterial.BitmapDataToBuffer((checkMaterial3.opacityMap as CBitmapTextureResource).data);
						}
					}
				}
			}			
			
			return Exist;
		}		
	
		public function Export(stage3D:Stage3D, editMode:Boolean = false):L3DMesh
		{
			if(!Exist)
			{
				return null;
			}
			
			if(!editMode && (name == "L3DTOPVIEW" || (name == "L3DSHADOW" && LivelyLibrary.RuntimeMode != CL3DConstDict.RUNTIME_NORMAL)))
			{
				if(vertices != null && vertices.length > 0)
				{
					vertices.length = 0;
				}
				if(normals != null && normals.length > 0)
				{
					normals.length = 0;
				}
				if(texture0 != null && texture0.length > 0)
				{
					texture0.length = 0;
				}
				if(texture1 != null && texture1.length > 0)
				{
					texture1.length = 0;
				}
				if(texture2 != null && texture2.length > 0)
				{
					texture2.length = 0;
				}
				if(indices != null && indices.length > 0)
				{
					indices.length = 0;
				}
				if(diffuseBuffer != null && diffuseBuffer.length > 0)
				{
					diffuseBuffer.clear();
				}
				if(normalBuffer != null && normalBuffer.length > 0)
				{
					normalBuffer.clear();
				}
				if(shininessBuffer != null && shininessBuffer.length > 0)
				{
					shininessBuffer.clear();
				}
				if(specularBuffer != null && specularBuffer.length > 0)
				{
					specularBuffer.clear();
				}
				if(emissionBuffer != null && emissionBuffer.length > 0)
				{
					emissionBuffer.clear();
				}
				if(transparentBuffer != null && transparentBuffer.length > 0)
				{
					transparentBuffer.clear();
				}
				return null;
			}
			
			var mesh:L3DMesh = new L3DMesh();
			var lightMapChannel:int = 0;
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			if(texture0 != null && texture0.length > 0)
			{
				attributes.push(VertexAttributes.TEXCOORDS[0]);
				attributes.push(VertexAttributes.TEXCOORDS[0]);
				if(texture1 != null && texture1.length > 0)
				{
					attributes.push(VertexAttributes.TEXCOORDS[1]);
					attributes.push(VertexAttributes.TEXCOORDS[1]);
					lightMapChannel = 1;
					if(texture2 != null && texture2.length > 0)
					{
						attributes.push(VertexAttributes.TEXCOORDS[2]);
						attributes.push(VertexAttributes.TEXCOORDS[2]);
						lightMapChannel = 2;
					}
				}
			}
			if(normals != null && normals.length > 0)
			{
				attributes.push(VertexAttributes.NORMAL);
				attributes.push(VertexAttributes.NORMAL);
				attributes.push(VertexAttributes.NORMAL);
			}
			
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);
			mesh.geometry.numVertices = numberVertices;
			//	mesh.geometry.numTriangles = numberFaces;	
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			if(texture0 != null && texture0.length > 0)
			{
				mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
				if(texture1 != null && texture1.length > 0)
				{
					mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1], texture1);
					if(texture2 != null && texture2.length > 0)
					{
						mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[2], texture2);
					}
				}
			}
			if(normals != null && normals.length > 0)
			{
				mesh.geometry.setAttributeValues(VertexAttributes.NORMAL, normals);
			}	
			mesh.geometry.indices = indices;
			
			var texLength1:int = 512;
			var texLength2:int = 256;
			var texLength3:int = 128;
			var texLength4:int = 64;
			var texLength5:int = 32;
			
			switch(LivelyLibrary.RuntimeMode)
			{
				case 1:
				{
					texLength1 = 256;
					texLength2 = 128;
					texLength3 = 128;
					texLength4 = 64;
					texLength5 = 32;
				}
					break;
				case 2:
				{
					texLength1 = 128;
					texLength2 = 128;
					texLength3 = 128;
					texLength4 = 64;
					texLength5 = 32;
				}
					break;
				case 3:
				{
					texLength1 = 1024;
					texLength2 = 512;
					texLength3 = 256;
					texLength4 = 128;
					texLength5 = 64;
				}
					break;
			}
			
			var material:Material = null;
			
			var needCheckTransparency:Boolean = true;
			var diffuse:L3DBitmapTextureResource = null;
			if(name == "L3DSHADOW")
			{
				var diffuseBmp = new BitmapData(1, 1, false, 0x000000);
				diffuse = new L3DBitmapTextureResource(diffuseBmp, null, stage3D, false, amendMode ? texLength1 : 0);
				if(!editMode)
				{
					if(diffuseBuffer != null)
					{
						diffuseBuffer.clear();
						diffuseBuffer = null;
					}
				}
			}
			else if(diffuseBuffer != null && diffuseBuffer.length > 0)
			{
				diffuse = new L3DBitmapTextureResource(null, diffuseBuffer, stage3D, false, amendMode ? texLength1 : 0);
				if(!editMode)
				{
					if(diffuseBuffer != null)
					{
						diffuseBuffer.clear();
						diffuseBuffer = null;
					}					
				}
			}
			var normal:L3DBitmapTextureResource = null;
			if(normalBuffer != null && normalBuffer.length > 0)
			{
				normal = new L3DBitmapTextureResource(null, normalBuffer, stage3D, false, amendMode ? texLength2 : 0);
				if(!editMode)
				{
					if(normalBuffer != null)
					{
						normalBuffer.clear();
						normalBuffer = null;
					}
				}
			}
			var shininess:L3DBitmapTextureResource = null;
			if(shininessBuffer != null && shininessBuffer.length > 0)
			{
				shininess = new L3DBitmapTextureResource(null, shininessBuffer, stage3D, false, amendMode ? texLength4 : 0);
				if(!editMode)
				{
					if(shininessBuffer != null)
					{
						shininessBuffer.clear();
						shininessBuffer = null;
					}
				}
			}
			var specular:L3DBitmapTextureResource = null;
			if(specularBuffer != null && specularBuffer.length > 0)
			{
				specular = new L3DBitmapTextureResource(null, specularBuffer, stage3D, false, amendMode ? texLength4 : 0);
				if(!editMode)
				{
					if(specularBuffer != null)
					{
						specularBuffer.clear();
						specularBuffer = null;
					}
				}
			}
			var emission:CBitmapTextureResource = null;
			if(emissionBuffer != null && emissionBuffer.length > 0)
			{
				if(!editMode && CL3DModuleUtil.Instance.useSceneDefaultBakeLightTexture)
				{
					emission = LivelyLibrary.SceneBakeLightTexture(stage3D);
				}
				else
				{
					emission = new L3DBitmapTextureResource(null, emissionBuffer, stage3D, false, amendMode ? texLength2 : 0);
				}				
				if(!editMode)
				{
					if(emissionBuffer != null)
					{
						emissionBuffer.clear();
						emissionBuffer = null;
					}
				}
			}
			var transparent:L3DBitmapTextureResource = null;
			if(transparentBuffer != null && transparentBuffer.length > 0)
			{
				haveOriginalTransparencyMap = true;
				transparent = new L3DBitmapTextureResource(null, transparentBuffer, stage3D, false, amendMode ? texLength2 : 0);
				if(!editMode)
				{
					if(transparentBuffer != null)
					{
						transparentBuffer.clear();
						transparentBuffer = null;
					}
				}
			}
			
	/*		if(mesh.NeedEnableEnvironmentMaterial(materialMode) && L3DUtils.CheckMeshHaveNormals(mesh))
			{
				material = new EnvironmentMaterial();
				if(diffuse == null)
				{
					var diffuseBmp = new BitmapData(1, 1, false, color);
					diffuse = new L3DBitmapTextureResource(diffuseBmp, null, stage3D, false, amendMode ? texLength1 : 0);
				}
				(material as EnvironmentMaterial).diffuseMap = diffuse;
				(material as EnvironmentMaterial).normalMap = normal;
				(material as EnvironmentMaterial).lightMap = emission;
				(material as EnvironmentMaterial).reflectionMap = specular;
				(material as EnvironmentMaterial).reflection = mesh.GetEnvironmentReflection(materialMode);
				(material as EnvironmentMaterial).opacityMap = transparent;
				(material as EnvironmentMaterial).environmentMap = L3DMaterial.GetEnvironmentMap(stage3D);
				(material as EnvironmentMaterial).lightMapChannel = lightMapChannel;
				if(alpha < 1)
				{
					(material as EnvironmentMaterial).opaquePass = true;				
					(material as EnvironmentMaterial).alpha = alpha;
					alphaThreshold = alpha < 1 ? 1 : 0;
					(material as EnvironmentMaterial).alphaThreshold = alphaThreshold;
					(material as EnvironmentMaterial).transparentPass = true;
				}
				needCheckTransparency = false;
			}
			else */
			if(diffuse == null && normal == null && shininess == null && specular == null && emission == null && transparent == null)
			{
				material = new FillMaterial(color);
			}
			else if(normal == null && shininess == null && specular == null && emission == null && transparent == null)
			{
				material = new TextureMaterial(diffuse);
			}
			else if(normal == null && shininess == null && specular == null && emission == null)
			{
				material = new TextureMaterial(diffuse, transparent, alpha);
				if(alpha < 1 || transparent != null)
				{
					(material as TextureMaterial).opaquePass = true;
					(material as TextureMaterial).alphaThreshold = alphaThreshold;
					(material as TextureMaterial).transparentPass = true;
				}
				needCheckTransparency = false;
			}
			else if(shininess == null && specular == null)
			{
				material = new LightMapMaterial(diffuse, emission, lightMapChannel, transparent);
				if(alpha < 1 || transparent != null)
				{
					(material as LightMapMaterial).opaquePass = true;
					(material as LightMapMaterial).alpha = alpha;
					(material as LightMapMaterial).alphaThreshold = alphaThreshold;
					(material as LightMapMaterial).transparentPass = true;
				}
				needCheckTransparency = false;
			}
			else
			{
				if(diffuse == null)
				{
//					var diffuseBmp = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//					var colorDiffuse:BitmapTextureResource = new BitmapTextureResource(diffuseBmp);
					var colorDiffuse:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xcccccc,CL3DConstDict.SUFFIX_DIFFUSE,CL3DConstDict.PREFIX_FILL);
					colorDiffuse.upload(stage3D.context3D);
					material = new StandardMaterial(colorDiffuse, null, null, null, null);
				}
				else
				{
					material = new StandardMaterial(diffuse, null, null, null, null);
				}
				if(normal == null)
				{
//					var normalBmp = new BitmapData(1, 1, false, 0x7F7FFF);
//					var colorNormal:BitmapTextureResource = new BitmapTextureResource(normalBmp);
					var colorNormal:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0x7f7fff,CL3DConstDict.SUFFIX_NORMAL,CL3DConstDict.PREFIX_FILL);
					colorNormal.upload(stage3D.context3D);
					(material as StandardMaterial).normalMap = colorNormal;
				}
				else
				{
					(material as StandardMaterial).normalMap = normal;
				}
				if(shininess != null)
				{
					(material as StandardMaterial).glossinessMap = shininess;
					(material as StandardMaterial).glossiness = glossiness;
				}
				if(specular != null)
				{
					(material as StandardMaterial).specularMap = specular;
					(material as StandardMaterial).specularPower = specularPower;
				}
				if(emission == null)
				{
					if(!editMode && CL3DModuleUtil.Instance.useSceneDefaultBakeLightTexture)
					{
						(material as StandardMaterial).lightMap = LivelyLibrary.SceneBakeLightTexture(stage3D);
					}
					else
					{
//						var emissionBmp = new BitmapData(1, 1, false, 0xAAAAAA);
//						var colorEmission:BitmapTextureResource = new BitmapTextureResource(emissionBmp);
						var colorEmission:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xAAAAAA,CL3DConstDict.SUFFIX_LIGHT,CL3DConstDict.PREFIX_FILL);
						colorEmission.upload(stage3D.context3D);
						(material as StandardMaterial).lightMap = colorEmission;
					}
					(material as StandardMaterial).lightMapChannel = lightMapChannel;
				}
				else
				{
					(material as StandardMaterial).lightMap = emission;
					(material as StandardMaterial).lightMapChannel = lightMapChannel;
				}
				if(transparent != null)
				{
					(material as StandardMaterial).opacityMap = transparent;
					(material as StandardMaterial).alpha = alpha;
					(material as StandardMaterial).alphaThreshold = alphaThreshold;
					(material as StandardMaterial).opaquePass = true;
					(material as StandardMaterial).transparentPass = true;
					needCheckTransparency = false;
				}
			}
			
			if(needCheckTransparency && alpha < 1.0)
			{
				if(material is FillMaterial)
				{	
					(material as FillMaterial).color = color;
					(material as FillMaterial).alpha = alpha;
				}
				else if(material is StandardMaterial)
				{
					if((material as StandardMaterial).opacityMap == null)
					{
//						var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
						var colorOpactiy:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						colorOpacity.upload(stage3D.context3D);
						(material as StandardMaterial).opacityMap = colorOpacity;
					}
					(material as StandardMaterial).alpha = alpha;
					(material as StandardMaterial).alphaThreshold = alphaThreshold;
					(material as StandardMaterial).opaquePass = true;							
					(material as StandardMaterial).transparentPass = true;
				}
				else if(material is LightMapMaterial)
				{
					if((material as LightMapMaterial).opacityMap == null)
					{
//						var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
						var colorOpacity:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						colorOpacity.upload(stage3D.context3D);
						(material as LightMapMaterial).opacityMap = colorOpacity;
					}
					(material as LightMapMaterial).alpha = alpha;
					(material as LightMapMaterial).alphaThreshold = alphaThreshold;
					(material as LightMapMaterial).opaquePass = true;							
					(material as LightMapMaterial).transparentPass = true;
				}
				else if(material is TextureMaterial)
				{
					if((material as TextureMaterial).opacityMap == null)						
					{
//						var tOpacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var tColorOpacity:BitmapTextureResource = new BitmapTextureResource(tOpacityBmp);
						var tColorOpacity:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						tColorOpacity.upload(stage3D.context3D);
						(material as TextureMaterial).opacityMap = tColorOpacity;
					}
					(material as TextureMaterial).alpha = alpha;
					(material as TextureMaterial).alphaThreshold = alphaThreshold;
					(material as TextureMaterial).opaquePass = true;
					(material as TextureMaterial).transparentPass = true;
				}
				else
				{
					material = new FillMaterial(color, alpha);
				}
			}
			
			mesh.addSurface(material, 0, numberFaces);
			if(mesh.caculation == null)
			{
				mesh.caculation = new L3DPartCaculation(mesh, null);
			}
			mesh.caculation.FromBuffer(caculationBuffer);
			//	mesh.caculation.PartMesh = mesh;
			mesh.layer = layer;
			mesh.moduleCode = moduleCode;
			mesh.moduleName = moduleName;
			mesh.UniqueID = uniqueID;
			mesh.MaterialMode = materialMode;
			mesh.IsLight = isLight;
			mesh.LightWattage = lightWattage;
			mesh.LightColor = lightColor;
			mesh.LightMode = lightMode;
			mesh.name = name;
			mesh.exportNormals = exportNormals;
			mesh.family = family;
			mesh.matrix = new Matrix3D();
			mesh.matrix.identity();
			
			if(!editMode)
			{
				if(diffuseBuffer != null && diffuseBuffer.length > 0)
				{
					diffuseBuffer.clear();
				}
				if(normalBuffer != null && normalBuffer.length > 0)
				{
					normalBuffer.clear();
				}
				if(shininessBuffer != null && shininessBuffer.length > 0)
				{
					shininessBuffer.clear();
				}
				if(specularBuffer != null && specularBuffer.length > 0)
				{
					specularBuffer.clear();
				}
				if(emissionBuffer != null && emissionBuffer.length > 0)
				{
					emissionBuffer.clear();
				}
				if(transparentBuffer != null && transparentBuffer.length > 0)
				{
					transparentBuffer.clear();
				}
			}
			
			return mesh;
		}	
		
		public function ExportVersionUpTo8(stage3D:Stage3D, editMode:Boolean = false):L3DMesh
		{
			if(!Exist)
			{
				return null;
			}
			
			if(!editMode && (name == "L3DTOPVIEW" || (name == "L3DSHADOW" && LivelyLibrary.RuntimeMode != CL3DConstDict.RUNTIME_NORMAL)))
			{
				if(vertices != null && vertices.length > 0)
				{
					vertices.length = 0;
				}
				if(normals != null && normals.length > 0)
				{
					normals.length = 0;
				}
				if(texture0 != null && texture0.length > 0)
				{
					texture0.length = 0;
				}
				if(texture1 != null && texture1.length > 0)
				{
					texture1.length = 0;
				}
				if(texture2 != null && texture2.length > 0)
				{
					texture2.length = 0;
				}
				if(indices != null && indices.length > 0)
				{
					indices.length = 0;
				}
				if(diffuseBuffer != null && diffuseBuffer.length > 0)
				{
					diffuseBuffer.clear();
				}
				if(normalBuffer != null && normalBuffer.length > 0)
				{
					normalBuffer.clear();
				}
				if(shininessBuffer != null && shininessBuffer.length > 0)
				{
					shininessBuffer.clear();
				}
				if(specularBuffer != null && specularBuffer.length > 0)
				{
					specularBuffer.clear();
				}
				if(emissionBuffer != null && emissionBuffer.length > 0)
				{
					emissionBuffer.clear();
				}
				if(transparentBuffer != null && transparentBuffer.length > 0)
				{
					transparentBuffer.clear();
				}
				return null;
			}
			
			var mesh:L3DMesh = new L3DMesh();
			var lightMapChannel:int = 0;
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			if(texture0 != null && texture0.length > 0)
			{
				attributes.push(VertexAttributes.TEXCOORDS[0]);
				attributes.push(VertexAttributes.TEXCOORDS[0]);
				if(texture1 != null && texture1.length > 0)
				{
					attributes.push(VertexAttributes.TEXCOORDS[1]);
					attributes.push(VertexAttributes.TEXCOORDS[1]);
					lightMapChannel = 1;
					if(texture2 != null && texture2.length > 0)
					{
						attributes.push(VertexAttributes.TEXCOORDS[2]);
						attributes.push(VertexAttributes.TEXCOORDS[2]);
						lightMapChannel = 2;
					}
				}
			}
			if(normals != null && normals.length > 0)
			{
				attributes.push(VertexAttributes.NORMAL);
				attributes.push(VertexAttributes.NORMAL);
				attributes.push(VertexAttributes.NORMAL);
			}
			
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);
			mesh.geometry.numVertices = numberVertices;
			//	mesh.geometry.numTriangles = numberFaces;	
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			if(texture0 != null && texture0.length > 0)
			{
				mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
				if(texture1 != null && texture1.length > 0)
				{
					mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1], texture1);
					if(texture2 != null && texture2.length > 0)
					{
						mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[2], texture2);
					}
				}
			}
			if(normals != null && normals.length > 0)
			{
				mesh.geometry.setAttributeValues(VertexAttributes.NORMAL, normals);
			}	
			mesh.geometry.indices = indices;
			
			var texLength1:int = 512;
			var texLength2:int = 256;
			var texLength3:int = 128;
			var texLength4:int = 64;
			var texLength5:int = 32;
			
			switch(LivelyLibrary.RuntimeMode)
			{
				case 1:
				{
					var texLength1:int = 256;
					var texLength2:int = 128;
					var texLength3:int = 128;
					var texLength4:int = 64;
					var texLength5:int = 32;
				}
					break;
				case 2:
				{
					var texLength1:int = 128;
					var texLength2:int = 128;
					var texLength3:int = 128;
					var texLength4:int = 64;
					var texLength5:int = 32;
				}
					break;
			}
			
			var material:Material = null;
			
			var needCheckTransparency:Boolean = true;
			var diffuse:L3DBitmapTextureResource = null;
			if(name == "L3DSHADOW")
			{
				var diffuseBmp = new BitmapData(1, 1, false, 0x000000);
				diffuse = new L3DBitmapTextureResource(diffuseBmp, null, stage3D, false, amendMode ? texLength1 : 0);
				if(!editMode)
				{
					if(diffuseBuffer != null)
					{
						diffuseBuffer.clear();
						diffuseBuffer = null;
					}
				}
			}
			else if(diffuseBuffer != null && diffuseBuffer.length > 0)
			{
				diffuse = new L3DBitmapTextureResource(null, diffuseBuffer, stage3D, false, amendMode ? texLength1 : 0);
				if(!editMode)
				{
					if(diffuseBuffer != null)
					{
						diffuseBuffer.clear();
						diffuseBuffer = null;
					}
				}
			}
			var normal:L3DBitmapTextureResource = null;
			if(normalBuffer != null && normalBuffer.length > 0)
			{
				normal = new L3DBitmapTextureResource(null, normalBuffer, stage3D, false, amendMode ? texLength2 : 0);
				if(!editMode)
				{
					if(normalBuffer != null)
					{
						normalBuffer.clear();
						normalBuffer = null;
					}
				}
			}
			var shininess:L3DBitmapTextureResource = null;
			if(shininessBuffer != null && shininessBuffer.length > 0)
			{
				shininess = new L3DBitmapTextureResource(null, shininessBuffer, stage3D, false, amendMode ? texLength4 : 0);
				if(!editMode)
				{
					if(shininessBuffer != null)
					{
						shininessBuffer.clear();
						shininessBuffer = null;
					}
				}
			}
			var specular:L3DBitmapTextureResource = null;
			if(specularBuffer != null && specularBuffer.length > 0)
			{
				specular = new L3DBitmapTextureResource(null, specularBuffer, stage3D, false, amendMode ? texLength4 : 0);
				if(!editMode)
				{
					if(specularBuffer != null)
					{
						specularBuffer.clear();
						specularBuffer = null;
					}
				}
			}
			var emission:CBitmapTextureResource = null;
			if(emissionBuffer != null && emissionBuffer.length > 0)
			{
				if(!editMode && CL3DModuleUtil.Instance.useSceneDefaultBakeLightTexture)
				{
					emission = LivelyLibrary.SceneBakeLightTexture(stage3D);
				}
				else
				{
				    emission = new L3DBitmapTextureResource(null, emissionBuffer, stage3D, false, amendMode ? texLength2 : 0);
				}
				if(!editMode)
				{
					if(emissionBuffer != null)
					{
						emissionBuffer.clear();
						emissionBuffer = null;
					}
				}
			}
			var transparent:L3DBitmapTextureResource = null;
			if(transparentBuffer != null && transparentBuffer.length > 0)
			{
				haveOriginalTransparencyMap = true;
				transparent = new L3DBitmapTextureResource(null, transparentBuffer, stage3D, false, amendMode ? texLength2 : 0);
				if(!editMode)
				{
					if(transparentBuffer != null)
					{
						transparentBuffer.clear();
						transparentBuffer = null;
					}
				}
			}
	
	/*		if(mesh.NeedEnableEnvironmentMaterial(materialMode) && L3DUtils.CheckMeshHaveNormals(mesh))
			{
				material = new EnvironmentMaterial();
				if(diffuse == null)
				{
					var diffuseBmp = new BitmapData(1, 1, false, color);
					diffuse = new L3DBitmapTextureResource(diffuseBmp, null, stage3D, false, amendMode ? texLength1 : 0);
				}
				(material as EnvironmentMaterial).diffuseMap = diffuse;
				(material as EnvironmentMaterial).normalMap = normal;
				(material as EnvironmentMaterial).lightMap = emission;
				(material as EnvironmentMaterial).reflectionMap = specular;
				//	(material as EnvironmentMaterial).reflection = specularPower;
				(material as EnvironmentMaterial).reflection = mesh.GetEnvironmentReflection(materialMode);
				(material as EnvironmentMaterial).opacityMap = transparent;
				(material as EnvironmentMaterial).environmentMap = L3DMaterial.GetEnvironmentMap(stage3D);
				(material as EnvironmentMaterial).lightMapChannel = lightMapChannel;
				(material as EnvironmentMaterial).opaquePass = true;
				(material as EnvironmentMaterial).alpha = alpha;
				alphaThreshold = alpha < 1 ? 1 : 0;
				(material as EnvironmentMaterial).alphaThreshold = alphaThreshold;
				(material as EnvironmentMaterial).transparentPass = true;
				needCheckTransparency = false;
			}
			else */
			if(diffuse == null && normal == null && shininess == null && specular == null && emission == null && transparent == null)
			{
				material = new FillMaterial(color);
			}
			else if(normal == null && shininess == null && specular == null && emission == null && transparent == null)
			{
				material = new TextureMaterial(diffuse);
			}
			else if(normal == null && shininess == null && specular == null && emission == null)
			{
				material = new TextureMaterial(diffuse, transparent, alpha);
				(material as TextureMaterial).opaquePass = true;
				(material as TextureMaterial).alphaThreshold = alphaThreshold;
				(material as TextureMaterial).transparentPass = true;
				needCheckTransparency = false;
			}
			else if(shininess == null && specular == null)
			{
				material = new LightMapMaterial(diffuse, emission, lightMapChannel, transparent);
				(material as LightMapMaterial).opaquePass = true;
				(material as LightMapMaterial).alpha = alpha;
				(material as LightMapMaterial).alphaThreshold = alphaThreshold;
				(material as LightMapMaterial).transparentPass = true;
				needCheckTransparency = false;
			}
			else
			{
				if(diffuse == null)
				{
//					var diffuseBmp = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//					var colorDiffuse:BitmapTextureResource = new BitmapTextureResource(diffuseBmp);
					var colorDiffuse:L3DBitmapTextureResource=CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(0xcccccc.toString(),null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_DIFFUSE);
					colorDiffuse.upload(stage3D.context3D);
					material = new StandardMaterial(colorDiffuse, null, null, null, null);
				}
				else
				{
					material = new StandardMaterial(diffuse, null, null, null, null);
				}
				if(normal == null)
				{
//					var normalBmp = new BitmapData(1, 1, false, 0x7F7FFF);
//					var colorNormal:BitmapTextureResource = new BitmapTextureResource(normalBmp);
					var colorNormal:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0x7F7FFF,CL3DConstDict.SUFFIX_NORMAL,CL3DConstDict.PREFIX_FILL);
					colorNormal.upload(stage3D.context3D);
					(material as StandardMaterial).normalMap = colorNormal;
				}
				else
				{
					(material as StandardMaterial).normalMap = normal;
				}
				if(shininess != null)
				{
					(material as StandardMaterial).glossinessMap = shininess;
					(material as StandardMaterial).glossiness = glossiness;
				}
				if(specular != null)
				{
					(material as StandardMaterial).specularMap = specular;
					(material as StandardMaterial).specularPower = specularPower;
				}
				if(emission == null)
				{
					if(!editMode && CL3DModuleUtil.Instance.useSceneDefaultBakeLightTexture)
					{
						(material as StandardMaterial).lightMap = LivelyLibrary.SceneBakeLightTexture(stage3D);
					}
					else
					{
//						var emissionBmp = new BitmapData(1, 1, false, 0xAAAAAA);
//						var colorEmission:BitmapTextureResource = new BitmapTextureResource(emissionBmp);
						var colorEmission:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xAAAAAA,CL3DConstDict.SUFFIX_LIGHT,CL3DConstDict.PREFIX_FILL);
						colorEmission.upload(stage3D.context3D);
						(material as StandardMaterial).lightMap = colorEmission;
					}
					(material as StandardMaterial).lightMapChannel = lightMapChannel;
				}
				else
				{
					(material as StandardMaterial).lightMap = emission;
					(material as StandardMaterial).lightMapChannel = lightMapChannel;
				}
				if(transparent != null)
				{
					(material as StandardMaterial).opacityMap = transparent;
					(material as StandardMaterial).alpha = alpha;
					(material as StandardMaterial).alphaThreshold = alphaThreshold;
					(material as StandardMaterial).opaquePass = true;
					(material as StandardMaterial).transparentPass = true;
					needCheckTransparency = false;
				}
			}
			
			if(needCheckTransparency && alpha < 1.0)
			{
				if(material is FillMaterial)
				{	
					(material as FillMaterial).color = color;
					(material as FillMaterial).alpha = alpha;
				}
				else if(material is StandardMaterial)
				{
					if((material as StandardMaterial).opacityMap == null)
					{
//						var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
						var colorOpacity:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						colorOpacity.upload(stage3D.context3D);
						(material as StandardMaterial).opacityMap = colorOpacity;
					}
					(material as StandardMaterial).alpha = alpha;
					(material as StandardMaterial).alphaThreshold = alphaThreshold;
					(material as StandardMaterial).opaquePass = true;							
					(material as StandardMaterial).transparentPass = true;
				}
				else if(material is LightMapMaterial)
				{
					if((material as LightMapMaterial).opacityMap == null)
					{
//						var opacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var colorOpacity:BitmapTextureResource = new BitmapTextureResource(opacityBmp);
						var colorOpacity:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						colorOpacity.upload(stage3D.context3D);
						(material as LightMapMaterial).opacityMap = colorOpacity;
					}
					(material as LightMapMaterial).alpha = alpha;
					(material as LightMapMaterial).alphaThreshold = alphaThreshold;
					(material as LightMapMaterial).opaquePass = true;							
					(material as LightMapMaterial).transparentPass = true;
				}
				else if(material is TextureMaterial)
				{
					if((material as TextureMaterial).opacityMap == null)						
					{
//						var tOpacityBmp:BitmapData = new BitmapData(1, 1, false, Math.random() * 0xFFFFFF);
//						var tColorOpacity:BitmapTextureResource = new BitmapTextureResource(tOpacityBmp);
						var tColorOpacity:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_OPACITY,CL3DConstDict.PREFIX_FILL);
						tColorOpacity.upload(stage3D.context3D);
						(material as TextureMaterial).opacityMap = tColorOpacity;
					}
					(material as TextureMaterial).alpha = alpha;
					(material as TextureMaterial).alphaThreshold = alphaThreshold;
					(material as TextureMaterial).opaquePass = true;
					(material as TextureMaterial).transparentPass = true;
				}
				else
				{
					material = new FillMaterial(color, alpha);
				}
			}
			
			mesh.addSurface(material, 0, numberFaces);
			if(mesh.caculation == null)
			{
			    mesh.caculation = new L3DPartCaculation(mesh, null);
			}
			mesh.caculation.FromBufferVersionD(caculationBuffer);
		//	mesh.caculation.PartMesh = mesh;
			mesh.layer = layer;
			mesh.moduleCode = moduleCode;
			mesh.moduleName = moduleName;
			mesh.UniqueID = uniqueID;
			mesh.MaterialMode = materialMode;
			mesh.IsLight = isLight;
			mesh.LightWattage = lightWattage;
			mesh.LightColor = lightColor;
			mesh.LightMode = lightMode;
			mesh.name = name;
			mesh.exportNormals = exportNormals;
			mesh.matrix = new Matrix3D();
			mesh.matrix.identity();
			
			if(!editMode)
			{
				if(diffuseBuffer != null && diffuseBuffer.length > 0)
				{
				    diffuseBuffer.clear();
				}
				if(normalBuffer != null && normalBuffer.length > 0)
				{
					normalBuffer.clear();
				}
				if(shininessBuffer != null && shininessBuffer.length > 0)
				{
					shininessBuffer.clear();
				}
				if(specularBuffer != null && specularBuffer.length > 0)
				{
					specularBuffer.clear();
				}
				if(emissionBuffer != null && emissionBuffer.length > 0)
				{
					emissionBuffer.clear();
				}
				if(transparentBuffer != null && transparentBuffer.length > 0)
				{
					transparentBuffer.clear();
				}
			}

			return mesh;
		}	
		
		public function ToBuffer():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			L3DModel.WriteString(buffer, name);
			buffer.writeInt(numberVertices);
			buffer.writeInt(numberFaces);
			if(vertices == null || vertices.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(vertices.length);
				for each(var vertex:Number in vertices)
				{
					buffer.writeFloat(vertex);
				}
			}
			if(normals == null || normals.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(normals.length);
				for each(var normal:Number in normals)
				{
					buffer.writeFloat(normal);
				}
			}
			if(texture0 == null || texture0.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(texture0.length);
				for each(var tex0:Number in texture0)
				{
					buffer.writeFloat(tex0);
				}
			}
			if(texture1 == null || texture1.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(texture1.length);
				for each(var tex1:Number in texture1)
				{
					buffer.writeFloat(tex1);
				}
			}
			if(texture2 == null || texture2.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(texture2.length);
				for each(var tex2:Number in texture2)
				{
					buffer.writeFloat(tex2);
				}
			}
			if(indices == null || indices.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{				
				buffer.writeInt(indices.length);
				for each(var index:uint in indices)
				{
					buffer.writeUnsignedInt(index);
				}
			}
			buffer.writeFloat(alpha);
			buffer.writeFloat(alphaThreshold);
			buffer.writeFloat(glossiness);
			buffer.writeFloat(specularPower);
			buffer.writeUnsignedInt(color);
			buffer.writeUnsignedInt(transparencyColor);
			buffer.writeInt(materialMode);
			buffer.writeBoolean(isLight);
			buffer.writeInt(lightWattage);
			buffer.writeUnsignedInt(lightColor);
			buffer.writeInt(lightMode);
			L3DModel.WriteString(buffer, uniqueID);
			L3DModel.WriteString(buffer, moduleCode);
			L3DModel.WriteString(buffer, moduleName);
			buffer.writeInt(layer);
			var en:int = exportNormals ? 1 : 0;
			buffer.writeInt(en);
			L3DModel.WriteString(buffer, family);
			if(caculationBuffer == null || caculationBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(caculationBuffer.length);
				buffer.writeBytes(caculationBuffer, 0, caculationBuffer.length);
			}
			if(diffuseBuffer == null || diffuseBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(diffuseBuffer.length);
				buffer.writeBytes(diffuseBuffer,0,diffuseBuffer.length);
			}
			if(normalBuffer == null || normalBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(normalBuffer.length);
				buffer.writeBytes(normalBuffer,0,normalBuffer.length);
			}
			if(shininessBuffer == null || shininessBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(shininessBuffer.length);
				buffer.writeBytes(shininessBuffer,0,shininessBuffer.length);
			}
			if(specularBuffer == null || specularBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(specularBuffer.length);
				buffer.writeBytes(specularBuffer,0,specularBuffer.length);
			}
			if(emissionBuffer == null || emissionBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(emissionBuffer.length);
				buffer.writeBytes(emissionBuffer,0,emissionBuffer.length);
			}
			if(transparentBuffer == null || transparentBuffer.length == 0)
			{
				buffer.writeInt(0);
			}
			else
			{
				buffer.writeInt(transparentBuffer.length);
				buffer.writeBytes(transparentBuffer,0,transparentBuffer.length);
			}
			buffer.compress();
			return buffer;
		}
		
		public static function FromBuffer(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l3dsubset.lightMode = buffer.readInt();
			l3dsubset.uniqueID = L3DModel.ReadString(buffer);
			l3dsubset.moduleCode = L3DModel.ReadString(buffer);
			l3dsubset.moduleName = L3DModel.ReadString(buffer);
			l3dsubset.layer = buffer.readInt();
			l3dsubset.exportNormals = buffer.readInt() == 1;
			l3dsubset.family = L3DModel.ReadString(buffer);
			var count:int = buffer.readInt();
			if(count > 0)
			{
				l3dsubset.caculationBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.caculationBuffer, 0, count);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion9(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l3dsubset.lightMode = buffer.readInt();
			l3dsubset.uniqueID = L3DModel.ReadString(buffer);
			l3dsubset.moduleCode = L3DModel.ReadString(buffer);
			l3dsubset.moduleName = L3DModel.ReadString(buffer);
			l3dsubset.layer = buffer.readInt();
			l3dsubset.exportNormals = buffer.readInt() == 1;
			var count:int = buffer.readInt();
			if(count > 0)
			{
				l3dsubset.caculationBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.caculationBuffer, 0, count);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion8(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l3dsubset.lightMode = buffer.readInt();
			l3dsubset.uniqueID = L3DModel.ReadString(buffer);
			l3dsubset.moduleCode = L3DModel.ReadString(buffer);
			l3dsubset.moduleName = L3DModel.ReadString(buffer);
			l3dsubset.layer = buffer.readInt();
			l3dsubset.exportNormals = buffer.readInt() == 1;
			var count:int = buffer.readInt();
			if(count > 0)
			{
				l3dsubset.caculationBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.caculationBuffer, 0, count);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion6and7(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l3dsubset.lightMode = buffer.readInt();
			l3dsubset.uniqueID = L3DModel.ReadString(buffer);
			l3dsubset.moduleCode = L3DModel.ReadString(buffer);
			l3dsubset.moduleName = L3DModel.ReadString(buffer);
			l3dsubset.layer = buffer.readInt();
			var count:int = buffer.readInt();
			if(count > 0)
			{
				l3dsubset.caculationBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.caculationBuffer, 0, count);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion5(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l3dsubset.uniqueID = L3DModel.ReadString(buffer);
			l3dsubset.moduleCode = L3DModel.ReadString(buffer);
			l3dsubset.moduleName = L3DModel.ReadString(buffer);
			l3dsubset.layer = buffer.readInt();
			var count:int = buffer.readInt();
			if(count > 0)
			{
				l3dsubset.caculationBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.caculationBuffer, 0, count);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion3and4(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l3dsubset.isLight = buffer.readBoolean();
			l3dsubset.lightWattage = buffer.readInt();
			l3dsubset.lightColor = buffer.readUnsignedInt();
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}

		public static function FromBufferVersion2(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l3dsubset.materialMode = buffer.readInt();
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion1(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.name = L3DModel.ReadString(buffer);
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		public static function FromBufferVersion0(buffer:ByteArray, amendMode:Boolean = false):L3DSubset
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			buffer.uncompress();
			var l3dsubset:L3DSubset = new L3DSubset();
			l3dsubset.amendMode = amendMode;
			l3dsubset.numberVertices = buffer.readInt();
			l3dsubset.numberFaces = buffer.readInt();
			var l:int = buffer.readInt();
			if(l>0)
			{
				l3dsubset.vertices = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.vertices.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.normals = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.normals.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture0 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture0.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture1 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture1.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.texture2 = new Vector.<Number>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.texture2.push(buffer.readFloat());
				}
			}
			l = buffer.readInt();
			if(l>0)
			{
				l3dsubset.indices = new Vector.<uint>();
				for(var i:int =0;i< l;i++)
				{
					l3dsubset.indices.push(buffer.readUnsignedInt());
				}
			}
			l3dsubset.alpha = buffer.readFloat();
			l3dsubset.alphaThreshold = buffer.readFloat();
			l3dsubset.glossiness = buffer.readFloat();
			l3dsubset.specularPower = buffer.readFloat();
			l3dsubset.color = buffer.readUnsignedInt();
			l3dsubset.transparencyColor = buffer.readUnsignedInt();
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.diffuseBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.diffuseBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.normalBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.normalBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.shininessBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.shininessBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.specularBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.specularBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.emissionBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.emissionBuffer,0,l);
			}
			l = buffer.readInt();
			if(l > 0)
			{
				l3dsubset.transparentBuffer = new ByteArray();
				buffer.readBytes(l3dsubset.transparentBuffer,0,l);
			}
			
			return l3dsubset;
		}
		
		private static function coloredMaterial(color:uint, stage3D:Stage3D):TextureMaterial
		{
//			var diffuseBmp = new BitmapData(1, 1, false, color);
//			var diffuseTexture:BitmapTextureResource = new BitmapTextureResource(diffuseBmp);
			var diffuseTexture:CBitmapTextureResource=CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(color,CL3DConstDict.SUFFIX_DIFFUSE,CL3DConstDict.PREFIX_FILL);
			diffuseTexture.upload(stage3D.context3D);
			return new TextureMaterial(diffuseTexture);
		}
		
		public static function GetLightMapChannel(mesh:Mesh):int
		{
			if(mesh == null)
			{
				return 0;
			}
			
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			var havePositions:Boolean = false;
			var haveNormals:Boolean = false;
			var haveTexture0:Boolean = false;
			var haveTexture1:Boolean = false;
			var haveTexture2:Boolean = false;			
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.POSITION:
					{
						havePositions = true;
					}
						break;
					case VertexAttributes.NORMAL:
					{
						haveNormals = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[0]:
					{
						haveTexture0 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[1]:
					{
						haveTexture1 = true;
					}
						break;
					case VertexAttributes.TEXCOORDS[2]:
					{
						haveTexture2 = true;
					}
						break;
				}
			}
			
			if(haveTexture2)
			{
				return 2;
			}
			else if(haveTexture1)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
}
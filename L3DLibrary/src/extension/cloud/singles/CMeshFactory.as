package extension.cloud.singles
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.Geometry;
	
	import cloud.core.datas.maps.CHashMap;
	
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.prefabs.CPlane3D;

	public class CMeshFactory
	{
		private static var _Instance:CMeshFactory;
		public static function get Instance():CMeshFactory
		{
			return _Instance||=new CMeshFactory(new SingletonEnforce());
		}
		
		private var _defaultAttributes:Array;
		private var _currentAttributes:Array;
		private var _meshMap:CHashMap;
		
		public function get attributes():Array
		{
			return !_currentAttributes ? _defaultAttributes : _currentAttributes;
		}
		
		public function CMeshFactory(enforcer:SingletonEnforce)
		{
			_defaultAttributes=[
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.TEXCOORDS[1],
				VertexAttributes.TEXCOORDS[1],
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL
			]
			_meshMap=new CHashMap();
			CL3DClassFactory.Instance.registClassRef(CL3DConstDict.CLASSNAME_L3DMESH,L3DMesh);
			CL3DClassFactory.Instance.registClassRef(CL3DConstDict.CLASSNAME_CPLANE3D,CPlane3D);
		}
		/**
		 * 设置GPU渲染相关属性序列化标记位数组
		 * @param source	序列化标记位数组
		 * @param isUpdateDefault	是否
		 * 
		 */		
		public function setAttributes(source:Array,isUpdateDefault:Boolean=false):void
		{
			_currentAttributes=source;
			if(isUpdateDefault) 
				_defaultAttributes=source;
		}
		/**
		 * 根据唯一ID，获取模型
		 * @param id
		 * @return L3DMesh
		 * 
		 */		
		public function getMesh(id:String,className:String=CL3DConstDict.CLASSNAME_L3DMESH):L3DMesh
		{
			var mesh:L3DMesh;
			var classRef:Class;
			
			classRef=CL3DClassFactory.Instance.getClassRefByName(className);
			if(!classRef)
			{
				print("className错误,没有该类名!");
				return null;
			}
			if(!_meshMap.containsKey(id))
			{
				mesh=new classRef();
				if(mesh is L3DMesh)
				{
					mesh.UniqueID=id;
					mesh.userData7=new MeshData(id);
					mesh.geometry = new Geometry();
					mesh.geometry.addVertexStream(attributes);
					_meshMap.put(id,mesh);
				}
			}
			else
			{
				mesh=_meshMap.get(id) as L3DMesh;
			}
			return mesh;
		}
		/**
		 * 填充一个三角面(顺时针) 
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param uv11
		 * @param uv12
		 * @param uv13
		 * @param uv21
		 * @param uv22
		 * @param uv23
		 * @param nor1
		 * @param nor2
		 * @param nor3
		 * 
		 */		
		public function fillMeshTrangleByValue(meshID:String,p1:Vector3D,p2:Vector3D,p3:Vector3D,uv11:Point,uv12:Point,uv13:Point,uv21:Point,uv22:Point,uv23:Point,nor1:Vector3D,nor2:Vector3D,nor3:Vector3D):void
		{
			var meshData:MeshData=getMesh(meshID).userData7;
			var count:int=meshData.indices.length;
			meshData.vertices.push(p1.x,p1.y,p1.z);
			meshData.vertices.push(p2.x,p2.y,p2.z);
			meshData.vertices.push(p3.x,p3.y,p3.z);
			meshData.textures0.push(uv11.x,uv11.y);
			meshData.textures0.push(uv12.x,uv12.y);
			meshData.textures0.push(uv13.x,uv13.y);
			meshData.textures1.push(uv21.x,uv21.y);
			meshData.textures1.push(uv22.x,uv22.y);
			meshData.textures1.push(uv23.x,uv23.y);
			meshData.normals.push(nor1.x,nor1.y,nor1.z);
			meshData.normals.push(nor2.x,nor2.y,nor2.z);
			meshData.normals.push(nor3.x,nor3.y,nor3.z);
			meshData.indices.push(count,count+1,count+2);
		}
		/**
		 * 填充一个四边形平面（顺时针）(1 2 4  4 2 3)
		 * @param meshID
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param p4
		 * @param uv11
		 * @param uv12
		 * @param uv13
		 * @param uv14
		 * @param uv21
		 * @param uv22
		 * @param uv23
		 * @param uv24
		 * @param nor1
		 * @param nor2
		 * @param nor3
		 * @param nor4
		 * 
		 */		
		public function fillMeshPolyByValue(meshID:String,p1:Vector3D,p2:Vector3D,p3:Vector3D,p4:Vector3D,uv11:Point,uv12:Point,uv13:Point,uv14:Point,uv21:Point,uv22:Point,uv23:Point,uv24:Point,nor1:Vector3D,nor2:Vector3D,nor3:Vector3D,nor4:Vector3D):void
		{
			var meshData:MeshData=getMesh(meshID).userData7;
			var count:int=meshData.indices.length;
			meshData.vertices.push(p1.x,p1.y,p1.z);
			meshData.vertices.push(p2.x,p2.y,p2.z);
			meshData.vertices.push(p4.x,p4.y,p4.z);
			meshData.vertices.push(p4.x,p4.y,p4.z);
			meshData.vertices.push(p2.x,p2.y,p2.z);
			meshData.vertices.push(p3.x,p3.y,p3.z);
			meshData.textures0.push(uv11.x,uv11.y);
			meshData.textures0.push(uv12.x,uv12.y);
			meshData.textures0.push(uv14.x,uv14.y);
			meshData.textures0.push(uv14.x,uv14.y);
			meshData.textures0.push(uv12.x,uv12.y);
			meshData.textures0.push(uv13.x,uv13.y);
			meshData.textures1.push(uv21.x,uv21.y);
			meshData.textures1.push(uv22.x,uv22.y);
			meshData.textures1.push(uv24.x,uv24.y);
			meshData.textures1.push(uv24.x,uv24.y);
			meshData.textures1.push(uv22.x,uv22.y);
			meshData.textures1.push(uv23.x,uv23.y);
			meshData.normals.push(nor1.x,nor1.y,nor1.z);
			meshData.normals.push(nor2.x,nor2.y,nor2.z);
			meshData.normals.push(nor4.x,nor4.y,nor4.z);
			meshData.normals.push(nor4.x,nor4.y,nor4.z);
			meshData.normals.push(nor2.x,nor2.y,nor2.z);
			meshData.normals.push(nor3.x,nor3.y,nor3.z);
			
			meshData.indices.push(count,count+1,count+2,count+3,count+4,count+5);
		}
		/**
		 * 根据三角面顶点，uv，法线值集合填充模型
		 * @param meshID	模型ID
		 * @param vertices	三角面顶点坐标值集合
		 * @param uv1s	三角面第一套uv值集合
		 * @param uv2s	三角面第二套uv值集合
		 * @param nors	三角面法线值集合
		 * 
		 */		
		public function fillMeshByVector(meshID:String,vertices:Vector.<Number>,uvs1:Vector.<Number>,uvs2:Vector.<Number>,nors:Vector.<Number>):void
		{
			var meshData:MeshData=getMesh(meshID).userData7;
			var count:int=meshData.indices.length;
			var len:int=vertices.length/3;
			var i:int;
			for(i=0; i<len; i++)
			{
				meshData.vertices.push(vertices[i*3],vertices[i*3+1],vertices[i*3+2]);
				meshData.textures0.push(uvs1[i*2],uvs1[i*2+1]);
				meshData.textures1.push(uvs2[i*2],uvs2[i*2+1]);
				meshData.normals.push(nors[i*3],nors[i*3+1],nors[i*3+2]);
				meshData.indices.push(count);
				count++;
			}
		}
		/**
		 * 结束模型填充 
		 * @return Array 填充完成的所有模型
		 * 
		 */		
		public function endFillMesh():Array
		{
			var result:Array;
			var mesh:L3DMesh;
			var meshData:MeshData;
			
			for(var i:int=0; i<_meshMap.keys.length; i++)
			{
				mesh=_meshMap.get(_meshMap.keys[i]) as L3DMesh;
				meshData=mesh.userData7;
				if(meshData.verticesNum==0) continue;
				result||=[];
				mesh.geometry.numVertices = meshData.verticesNum / 3;
				mesh.geometry.setAttributeValues(VertexAttributes.POSITION, meshData.vertices);
				mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], meshData.textures0);
				mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1], meshData.textures1);
				mesh.geometry.setAttributeValues(VertexAttributes.NORMAL, meshData.normals);
				mesh.geometry.indices = meshData.indices;
				result.push(mesh);
				mesh.userData7=null;
				meshData.clear();
			}
			clearAll();
			return result;
		}
		/**
		 * 清理所有的模型数据,释放所有的模型引用
		 * 
		 */		
		public function clearAll():void
		{
			_meshMap.clear();
		}
	}
}


class MeshData
{
	private var _vertices:Vector.<Number>;
	private var _textures0:Vector.<Number>;
	private var _textures1:Vector.<Number>;
	private var _normals:Vector.<Number>;
	private var _indices:Vector.<uint>;
	
	internal var uniqueID:String;
	
	internal function get vertices():Vector.<Number>
	{
		return _vertices;
	}
	internal function get textures0():Vector.<Number>
	{
		return _textures0;
	}
	internal function get textures1():Vector.<Number>
	{
		return _textures1;
	}
	internal function get normals():Vector.<Number>
	{
		return _normals;
	}
	internal function get indices():Vector.<uint>
	{
		return _indices;
	}
	
	public function get verticesNum():uint
	{
		return _vertices.length;
	}
	
	public function MeshData(id:String)
	{
		_vertices=new Vector.<Number>();
		_textures0=new Vector.<Number>();
		_textures1=new Vector.<Number>();
		_normals=new Vector.<Number>();
		_indices=new Vector.<uint>();
	}
	
	public function clear():void
	{
		_vertices=null;
		_textures0=null;
		_textures1=null;
		_normals=null;
		_indices=null;
	}
}
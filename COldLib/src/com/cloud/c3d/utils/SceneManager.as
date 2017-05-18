package com.cloud.c3d.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;

	/**
	 * ClassName: package com.cloud.c3d.utils::SceneManager
	 *
	 * Intro:		场景管理类
	 *
	 * @date: 2014-4-17
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public final class SceneManager
	{
		public static const VERTEX_MAXVALUE:int = 65535;	
		
		private static var _instance:SceneManager;
		
		public static function get instance():SceneManager
		{
			return _instance ||= new SceneManager(new SingletonEnforce());
		}
		/**
		 *	场景batch模型容器 
		 */		
		private var _batches:Vector.<BatchVO>;
		private var _batchID:int;
		private var _scene3D:Scene3D;
		
		public function SceneManager(enforcer:SingletonEnforce)
		{
			_batches = new Vector.<BatchVO>();
		}
		
		/**
		 * 合并mesh(mesh共用同一纹理源)
		 * @param meshVec	模型集合
		 * 
		 */		
		public function batchMeshes(meshVec:Vector.<Mesh>):void
		{
			var vecLen:int = meshVec.length,subMeshLen:int,i:int,j:int;
			var vertexVec:Vector.<Number>;
			var indexVec:Vector.<uint>;
			var subMeshVec:Vector.<SubMesh>;
			var geoDic:Dictionary = new Dictionary();
			var indexDic:Dictionary = new Dictionary();
			var uvDic:Dictionary = new Dictionary();
			var vertexDic:Dictionary = new Dictionary();
			var matrix:Matrix3D;
			var subGeo:ISubGeometry;
			var num:int;
			var vertexNum:int;
			var len:int;
			var arr:Array;
			var batchVertex:Function = function(nstr:String,index:int,isComplete:Boolean):void
			{
				arr = geoDic[nstr];
				var i:int = 0;
				
				if(num == VERTEX_MAXVALUE || vertexDic[nstr] == null)
				{
					num = 0;
				}
				else
				{
					num = vertexDic[nstr].length / 13;
				}
				//转换顶点
				vertexVec = subMeshVec[index].subGeometry.vertexData.concat();
				indexVec = subMeshVec[index].subGeometry.indexData.concat();
				len = vertexVec.length / 13;
				var vec:Vector3D = new Vector3D();
				var strid:int;
				var invMatrix:Matrix3D = matrix.clone();
				invMatrix.invert();
				invMatrix.transpose();

				for(i=0; i < len; i++)
				{
					strid = i * 13;
					vec.x = vertexVec[strid];
					vec.y = vertexVec[strid+1];
					vec.z = vertexVec[strid+2];
					vec = matrix.transformVector(vec);
					vertexVec[strid] = vec.x;
					vertexVec[strid+1] = vec.y;
					vertexVec[strid+2] = vec.z;
					
					vec.x = vertexVec[strid+3];
					vec.y = vertexVec[strid+4];
					vec.z = vertexVec[strid+5];
					vec = invMatrix.deltaTransformVector(vec);
					vec.normalize();
					vertexVec[strid+3] = vec.x;
					vertexVec[strid+4] = vec.y;
					vertexVec[strid+5] = vec.z;
					
					vec.x = vertexVec[strid+6];
					vec.y = vertexVec[strid+7];
					vec.z = vertexVec[strid+8];
					vec = invMatrix.deltaTransformVector(vec);
					vec.normalize();
					vertexVec[strid+6] = vec.x;
					vertexVec[strid+7] = vec.y;
					vertexVec[strid+8] = vec.z;
				}
				
				
				vertexNum = subMeshVec[index].subGeometry.numVertices;
				if(num+vertexNum > VERTEX_MAXVALUE)
				{
					subGeo = subMeshVec[index].subGeometry.clone();
					(subGeo as SkinnedSubGeometry).updateData(vertexDic[nstr]);
					(subGeo as SkinnedSubGeometry).updateIndexData(indexDic[nstr]);
					geoDic[nstr].push(subGeo);
					
					vertexDic[nstr] = vertexVec;
					indexDic[nstr] = indexVec;
				}
				else
				{
					if(vertexDic[nstr])
					{	
						vertexDic[nstr] = vertexDic[nstr].concat(vertexVec);
						
						len = indexVec.length;
						for(i =0; i < len; i++)
						{
							indexVec[i]+= num;
						}
						indexDic[nstr] = indexDic[nstr].concat(indexVec);
					}
					else
					{
						vertexDic[nstr] = vertexVec;
						indexDic[nstr] = indexVec;
					}
				}
				if(isComplete)
				{
					for(i=0; i < subMeshLen; i++)
					{
						subGeo = subMeshVec[i].subGeometry.clone();
						nstr = subMeshVec[i].material.name;
						(subGeo as SkinnedSubGeometry).updateData(vertexDic[nstr]);
						(subGeo as SkinnedSubGeometry).updateIndexData(indexDic[nstr]);
						geoDic[nstr].push(subGeo);
					}
					
				}
			};
			//开始打包
			for(i=0; i < vecLen; i++)
			{
				matrix = meshVec[i].sceneTransform;
				subMeshVec = meshVec[i].subMeshes;
				subMeshLen = subMeshVec.length;
				for(j=0;j < subMeshLen; j++)
				{
					if(geoDic[subMeshVec[j].material.name] == null)
					{
						geoDic[subMeshVec[j].material.name] = [subMeshVec[j].material];
					}
					batchVertex(subMeshVec[j].material.name,j,(i+1)*(j+1)==vecLen*subMeshLen);
				}
			}
			//创建打包数据
			var batchVO:BatchVO;
			for(var ns:String in geoDic)
			{
				for(i=1; i < geoDic[ns].length; i++)
				{
					batchVO = new BatchVO();
					batchVO.batch = new Mesh(new Geometry(),geoDic[ns][0]);
					batchVO.batch.mouseEnabled = true;
					batchVO.batch.geometry.addSubGeometry(geoDic[ns][i]);
					batchVO.invalid = true;
					_batches.push(batchVO);
				}
			}
			
		}
		/**
		 * 更新添加Batches 
		 * @param container
		 * 
		 */		
		public function addBatches(container:ObjectContainer3D):void
		{
			var len:int = _batches.length;
			while(len-- > 0)
			{
				if(_batches[len].invalid)
				{
					container.addChild(_batches[len].batch);
					_batches[len].invalid = false;
				}
			}
		}
//		public function removeBatchesByID():void
//		{
//			
//		}
		/**
		 * 移除batch 
		 * 
		 */
		public function removeAllBatches():void
		{
			var len:int = _batches.length;
			while(len-- > 0)
			{
				if(_batches[len].batch.parent)
				{
					_batches[len].batch.parent.removeChild(_batches[len].batch);
					_batches[len].invalid = true;
				}
			}
		}
	}
}
import away3d.entities.Mesh;

class BatchVO
{
	public var batch:Mesh;
	public var invalid:Boolean = true;
}
class SingletonEnforce{}
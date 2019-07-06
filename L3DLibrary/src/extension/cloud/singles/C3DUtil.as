package extension.cloud.singles
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.utils.UIDUtil;
	
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.utils.Object3DUtils;
	
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CMathUtilForAS;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.dict.CL3DConstDict;
	

	/**
	 * 3D工具类
	 * @author cloud
	 */
	public class C3DUtil
	{
		private static var _Instance:C3DUtil;
		
		public static function get Instance():C3DUtil
		{
			return _Instance||=new C3DUtil(new SingletonEnforce());
		}
		public function C3DUtil(enforcer:SingletonEnforce)
		{
		}
		/**
		 * 通过围点数组,获取每个围点对应的UV值(基于中心点计算)
		 * @param points	围点数组
		 * @param originPt	原点坐标
		 * @param uLength	u的总长度
		 * @param vLength	v的总长度
		 * @param transMatrix	转换矩阵
		 * @return Array	围点UV数组
		 * 
		 */		
		public function getUVsByCenter(points:Array,originPt:Point,uLength:Number,vLength:Number,transMatrix:Matrix3D):Array
		{
			if(!points || !points.length || !uLength || !vLength) return null;
			var uvs:Array;
			var i:int,len:int;
			var transUV:Vector3D;
			uvs=[];
			transUV=new Vector3D();
			len=points.length;
			var inVec:Vector.<Number>=new Vector.<Number>(3);
			var outVec:Vector.<Number>=new Vector.<Number>(3);
			for(i = 0; i < len; i++)
			{
				inVec[0]=points[i].x;
				inVec[1]=points[i].y;
				inVec[2]=0;
				if(transMatrix)
				{
					transMatrix.transformVectors(inVec,outVec);
				}
				else
				{
					outVec=inVec;
				}
				transUV.setTo(((outVec[0]-originPt.x+.5)/uLength),((outVec[1]-originPt.y+.5)/vLength),0);
				uvs.push(transUV.x);
				uvs.push(transUV.y);
			}
			return uvs;
		}
		/**
		 * 获取平面3D向量围点数组的UV数组
		 * @param points	3D向量围点数组
		 * @param origin	UV原点
		 * @param uDir	u方向
		 * @param vDir		v方向
		 * @param uLimit	u方向的最大毫米值
		 * @param vLimit v方向的最大毫米值
		 * @return Array	uv数组
		 * 
		 */		
		public function getPlanPointUVsByVector3D(points:*,origin:Vector3D,uDir:Vector3D,vDir:Vector3D,uLimit:Number,vLimit:Number):Array
		{
			if(!points || !points.length || !origin || !uDir || !vDir || uLimit==0 || vLimit==0)
			{
				return null;
			}
			var result:Array;
			var tmpVec:Vector3D;
			var u:Number,v:Number;
			var i:int,len:int;
			
			result=[];
			tmpVec=new Vector3D();
			uDir.normalize();
			vDir.normalize();
			for(i=points.length-1; i>=0; i--)
			{
				tmpVec.setTo(points[i].x,points[i].y,points[i].z);
				tmpVec.decrementBy(origin);
				u=tmpVec.dotProduct(uDir)/uLimit;
				v=tmpVec.dotProduct(vDir)/vLimit;
				result.push(u,v);
			}
			return result;
		}
		/**
		 * 通过3D向量的方式,获取点的UV值
		 * @param curPoint	当前点的3D向量位置
		 * @param origin	原点的3D向量位置
		 * @param uDir	u方向的3D向量
		 * @param vDir		v方向的3D向量
		 * @param maxULength		u方向的最大位移值
		 * @param maxVLength		v方向的最大位移值
		 * @param output	u,v值的接收容器
		 * 
		 */		
		public function getUV(curPoint:Vector3D,origin:Vector3D,uDir:Vector3D,vDir:Vector3D,maxULength:Number,maxVLength:Number,output:*):void
		{
			var tmpVec:Vector3D;
			var u:Number,v:Number;
			uDir.normalize();
			vDir.normalize();
			tmpVec=curPoint.subtract(origin);
			u=tmpVec.dotProduct(uDir)/maxULength;
			v=tmpVec.dotProduct(vDir)/maxVLength;
			output.push(u,v);
		}
		/**
		 *  获取环形3D向量围点数组的UV数组
		 * @param inners	内环围点数组
		 * @param outers	外环围点数组
		 * @param uDir	u方向
		 * @param vDir		v方向
		 * @param uLimit		u方向最大值
		 * @param vLimit		v方向最大值
		 * @return Array	
		 * 
		 */		
		public function getRingPointUVsByVector3D(outers:*,inners:*,uDir:Vector3D,vDir:Vector3D,uLimit:Number,vLimit:Number):Array
		{
			if(!inners || !inners.length || !outers || !outers.length || inners.length!=outers.length || !uDir || !vDir || uLimit==0 || vLimit==0)
			{
				return null;
			}
			var result:Array;
			var tmpVec:Vector3D,origin:Vector3D;
			var u:Number,v:Number,lastU:Number,lastV:Number;
			var i:int,j:int,next:int,len:int;
			
			result=[];
			tmpVec=new Vector3D();
			lastU=0;
			uDir.normalize();
			vDir.normalize();
			len=inners.length;
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				origin=inners[i];
				result.push(lastU,lastV);
				tmpVec.setTo(outers[i].x,outers[i].y,outers[i].z);
				tmpVec.decrementBy(origin);
				u=lastU+tmpVec.dotProduct(uDir)/uLimit;
				v=tmpVec.dotProduct(vDir)/vLimit;
				result.push(u,v);
				tmpVec.setTo(outers[next].x,outers[next].y,outers[next].z);
				tmpVec.decrementBy(origin);
				u=lastU+tmpVec.dotProduct(uDir)/uLimit;
				v=tmpVec.dotProduct(vDir)/vLimit;
				result.push(u,v);
				tmpVec.setTo(inners[next].x,inners[next].y,inners[next].z);
				tmpVec.decrementBy(origin);
				u=lastU+tmpVec.dotProduct(uDir)/uLimit;
				v=tmpVec.dotProduct(vDir)/vLimit;
				result.push(u,v);
				lastU=u;
			}
			return result;
		}
		/**
		 * 根据Y轴放样标准模型，获取放样模型对象
		 * @param vertices	标准放样模型顶点坐标值集合
		 * @param path3D	路径点集合（第一个点和最后一个点只是做方向判断，不是放样路径点,并且放样路径点必须是3个以上）
		 * @param material	放样模型的材质
		 * @param uSize		纹理横向尺寸
		 * @param isPathClosure 放样路径是否闭合
		 * @param scaleRatio	坐标值缩放比例
		 * @return Mesh		放样模型对象
		 * 
		 */		
		public function getLoftMeshByYAxisMesh(vertices:Vector.<Number>,path3D:Vector.<Number>,material:Material,uSize:int,isPathClosure:Boolean,scaleRatio:Number):Mesh
		{
			var mesh:Mesh;
			var i:int,j:int,slen:int,plen:int;
			var cur:int,prev:int,next:int;
			var deepValue:Number;
			var heightValue:Number;
			var tmpVec:Vector.<Number>;
			var sectionVec:Vector.<Number>;
			var curCross:Vector3D;
			var direction:Vector3D=new Vector3D();
			var pathNormal:Vector3D,vertical:Vector3D;
			var indices:Array;
			var vSize:Number;
			
			vSize=0;
			pathNormal=CMathUtilForAS.Instance.getPointsPlanNormalVec(path3D,false,isPathClosure);
			pathNormal.negate();
			tmpVec=getSectionMeshVerticesByXZPlan(vertices);	//放样型材在XZ平面的截面闭合围点坐标值集合
			slen=tmpVec.length/2;
			plen=path3D.length/3-1;
			indices=CMathUtilForAS.Instance.getStartPosIndexByXYArray(tmpVec,true);	//放样型材围点最小坐标值的点的索引
			sectionVec=new Vector.<Number>();
			//截面围点排序
			i=indices[0];
			while(i!=indices[1])
			{
				next=i==slen-1?0:i+1;
				vSize+=CMathUtil.Instance.getDistanceByXY(tmpVec[i*2],tmpVec[i*2+1],tmpVec[next*2],tmpVec[next*2+1]);
				sectionVec.push(tmpVec[i*2],tmpVec[i*2+1]);
				i=next;
			}
			sectionVec.push(tmpVec[i*2],tmpVec[i*2+1]);
			//截面放样
			var lastU:Number,lastV:Number,curU:Number,curV:Number;
			var meshID:String;
			var vertices:Vector.<Number>;
			var uvs1:Vector.<Number>;
			var uvs2:Vector.<Number>;
			var nors:Vector.<Number>;
			var lastPointPath:Vector.<Number>;
			var curPointPath:Vector.<Number>;
			var lastNor:Vector3D;
			var curNor:Vector3D;
			var nor:Vector3D;
			
			meshID=UIDUtil.createUID();
			vertices=new Vector.<Number>();
			uvs1=new Vector.<Number>();
			uvs2=new Vector.<Number>();
			nors=new Vector.<Number>();

			for(i=0; i<slen; i++)
			{
				deepValue=sectionVec[i*2];
				heightValue=sectionVec[i*2+1];
				plen=path3D.length/3;
				//创建路径点集合
				curPointPath=CMathUtilForAS.Instance.getOffsetPoint3DsByNumber(path3D,pathNormal,heightValue,deepValue,isPathClosure);
				if(!isPathClosure)
				{
					curPointPath.splice((plen-1)*3,3);
					curPointPath.splice(0,3);
				}
				prev=i-1;
				next=i+1;
				//初始化UV
//				direction.setTo(curPointPath[3]-curPointPath[0],curPointPath[4]-curPointPath[1],curPointPath[5]-curPointPath[2]);
//				vertical=direction.crossProduct(pathNormal);
//				vertical.normalize();
//				vertical.scaleBy(deepValue);
				//计算U的初始值
//				if(isPathClosure)
//				{
//					curU=CMathUtil.Instance.getDistanceByXYZ(curPointPath[0]-path3D[0]-vertical.x,curPointPath[1]-path3D[1]-vertical.y,curPointPath[2]-path3D[2]-vertical.z,0,0,0)/uSize;
//				}
//				else
//				{
//					curU=CMathUtil.Instance.getDistanceByXYZ(curPointPath[0]-path3D[3]-vertical.x,curPointPath[1]-path3D[4]-vertical.y,curPointPath[2]-path3D[5]-vertical.z,0,0,0)/uSize;
//				}
				curU=0;
				//计算V的初始值
				if(lastPointPath!=null)
				{
					curV=lastV+CMathUtil.Instance.getDistanceByXY(sectionVec[i*2],sectionVec[i*2+1],sectionVec[prev*2],sectionVec[prev*2+1]) / vSize;
				}
				else
				{
					curV=0;
				}
				//填充模型数据集合
				plen=curPointPath.length/3;
				var tmpCurU:Number,tmpLastCurU:Number,tmpPrevU:Number,tmpLastPrevU:Number;
				tmpCurU=0;
				tmpLastCurU=0;
				if(i>0)
				{
					for(j=1; j<plen; j++)
					{
						prev=j-1;
						tmpPrevU=tmpCurU;
						tmpLastPrevU=tmpLastCurU;
						tmpCurU+=CMathUtil.Instance.getDistanceByXYZ(curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2])/uSize;
						tmpLastCurU+=CMathUtil.Instance.getDistanceByXYZ(lastPointPath[j*3],lastPointPath[j*3+1],lastPointPath[j*3+2],lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2])/uSize;
						//填充顶点值，顶点索引值，UV值，法线值
						vertices.push(
							curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2]
						);
						vertices.push(
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],
							lastPointPath[j*3],lastPointPath[j*3+1],lastPointPath[j*3+2]
						);
						uvs1.push(
							tmpPrevU,curV,
							tmpCurU,curV,
							tmpLastPrevU,lastV
						);
						uvs1.push(
							tmpLastPrevU,lastV,
							tmpCurU,curV,
							tmpLastCurU,lastV
						);
						curNor=CMathUtilForAS.Instance.crossByPosition3D(
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2],
							curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2]
						);
						curNor.normalize();
						nors.push(
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z
						);
						nors.push(
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z
						);
					}
					if(isPathClosure)
					{
						j=0;
						prev=plen-1;
						tmpPrevU=tmpCurU;
						tmpLastPrevU=tmpLastCurU;
						tmpCurU+=CMathUtil.Instance.getDistanceByXYZ(curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2])/uSize;
						tmpLastCurU+=CMathUtil.Instance.getDistanceByXYZ(lastPointPath[j*3],lastPointPath[j*3+1],lastPointPath[j*3+2],lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2])/uSize;
						//填充顶点值，顶点索引值，UV值，法线值
						vertices.push(
							curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2]
						);
						vertices.push(
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2],
							lastPointPath[j*3],lastPointPath[j*3+1],lastPointPath[j*3+2]
						);
						uvs1.push(
							tmpPrevU,curV,
							tmpCurU,curV,
							tmpLastPrevU,lastV
						);
						uvs1.push(
							tmpLastPrevU,lastV,
							tmpCurU,curV,
							tmpLastCurU,lastV
						);
						curNor=CMathUtilForAS.Instance.crossByPosition3D(
							lastPointPath[prev*3],lastPointPath[prev*3+1],lastPointPath[prev*3+2],
							curPointPath[prev*3],curPointPath[prev*3+1],curPointPath[prev*3+2],
							curPointPath[j*3],curPointPath[j*3+1],curPointPath[j*3+2]
						);
						curNor.normalize();
						nors.push(
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z
						);
						nors.push(
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z,
							curNor.x,curNor.y,curNor.z
						);
					}
				}
				lastPointPath=curPointPath;
				lastU=curU;
				lastV=curV;
			}
			//创建放样模型
			CMeshFactory.Instance.fillMeshByVector(meshID,vertices,uvs1,uvs1,nors);
			mesh=CMeshFactory.Instance.endFillMesh()[0];
			mesh.boundBox=Object3DUtils.calculateHierarchyBoundBox(mesh);
			
			if(material)
			{
				mesh.addSurface(material,0,vertices.length/9);
			}
			CMeshFactory.Instance.clearAll();
			return mesh;
		}
		/**
		 * 通过平面法线和模型原点，获取模型在XZ平面上的投影点数组集合(放样轴为y的模型顶点集合)
		 * @param vertices	模型顶点集合
		 * @param planNormal		平面法线向量
		 * @return Array
		 * 
		 */		
		private function getSectionMeshVerticesByXZPlan(vertices:Vector.<Number>):Vector.<Number>
		{
			var result:Vector.<Number>;
			var x:Number,y:Number;
			var i:int;
			result=new Vector.<Number>();
			for(i=vertices.length/3-1; i>=0; i--)
			{
				x=CMathUtil.Instance.amendInt(vertices[i*3]);
				y=CMathUtil.Instance.amendInt(vertices[i*3+2]);
				if(!hasPosition2D(x,y,result))
				{
					result.push(x,y);
				}
			}
			return result;
		}
		/**
		 * 是否有2D位置坐标 
		 * @param x
		 * @param y
		 * @param positionValues
		 * @return Boolean
		 * 
		 */		
		private function hasPosition2D(x:Number,y:Number,positionValues:Vector.<Number>):Boolean
		{
			var i:int;
			var result:Boolean;
			for(i=positionValues.length/2-1; i>=0; i--)
			{
				if(x==positionValues[i*2] && y==positionValues[i*2+1])
				{
					result=true;
					break;
				}
			}
			return result;
		}
		/**
		 * 释放模型中的所有资源 
		 * @param mesh
		 * 
		 */		
		public function releaseAllResourceByMesh(mesh:L3DMesh):void
		{
			if(!mesh) return;
			if(mesh.parent!=null)
			{
				mesh.parent.removeChild(mesh);
			}
			mesh.Dispose();
		}
		
		/**
		 * 创建板件模型  
		 * @param length
		 * @param width
		 * @param height
		 * @param matrix	
		 * @param size	板件的尺寸
		 * @param texRotation	纹理旋转角度
		 * @param frontOffsets
		 * @param backOffsets
		 * @param hasBoardEdge
		 * @return L3DMesh
		 * 
		 */			
		public function createL3DBoardMesh(paths:Array,width:Number,matrix:Matrix3D,size:Vector3D,texRotation:Number,scale:Number,uvOriginPosition:Vector3D,frontOffsets:Vector.<Number>=null,backOffsets:Vector.<Number>=null,hasBoardEdge:Boolean=true):Array
		{
			if(frontOffsets && backOffsets && frontOffsets.length!=backOffsets.length)
			{
				return null;
			}
			var frontPoints:Array,backPoints:Array;
			var i:int,prev:int,next:int,len:int;
			var tmp:Vector3D,uDir:Vector3D,vDir:Vector3D,dir:Vector3D,nor:Vector3D,uvOrigin:Vector3D;
			var uMax:Number,vMax:Number;
			var texMatrix:Matrix3D;
			
			uMax=size.x*scale;
			vMax=size.y*scale;
			if(texRotation!=0)
			{
				texMatrix=new Matrix3D();
				texMatrix.appendRotation(texRotation,Vector3D.X_AXIS);
			}
			//计算并生成外表面和地面的围点数组
			len=paths.length;
			frontPoints=[];
			backPoints=[];
			for(i=0; i<len; i++)
			{
				tmp=matrix.transformVector(new Vector3D(paths[i].x,-width*.5,paths[i].z));
				tmp.scaleBy(scale);
				frontPoints.push(tmp);
				tmp=matrix.transformVector(new Vector3D(paths[i].x,width*.5,paths[i].z));
				tmp.scaleBy(scale);
				backPoints.push(tmp);
			}
			//模型外表面的3D法线向量
			nor=CMathUtilForAS.Instance.crossByPosition3D(frontPoints[0].x,frontPoints[0].y,frontPoints[0].z,frontPoints[2].x,frontPoints[2].y,frontPoints[2].z,frontPoints[1].x,frontPoints[1].y,frontPoints[1].z);
			nor.normalize();
			//处理倒角
			len=frontPoints.length;
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				if(frontOffsets && frontOffsets[i]!=0)
				{
					dir=frontPoints[next].subtract(frontPoints[i]);
					dir.normalize();
					tmp=nor.crossProduct(dir);
					tmp.scaleBy(frontOffsets[i]*scale);
					frontPoints[i].incrementBy(tmp);
					frontPoints[next].incrementBy(tmp);
				}
				if(backOffsets && backOffsets[i]!=0)
				{
					dir=backPoints[next].subtract(backPoints[i]);
					dir.normalize();
					tmp=dir.crossProduct(nor);
					tmp.scaleBy(backOffsets[i]*scale);
					backPoints[i].incrementBy(tmp);
					backPoints[next].incrementBy(tmp);
				}
			}
			uvOrigin=uvOriginPosition?uvOriginPosition:frontPoints[0];
			//根据围点数组,创建板模型
			var mesh:L3DMesh=CMeshFactory.Instance.getMesh(CUtil.Instance.createUID());
			var vertices:Vector.<Number>=new Vector.<Number>();
			var uvs:Vector.<Number>=new Vector.<Number>();
			var normals:Vector.<Number>=new Vector.<Number>();
			
			mesh.name=CL3DConstDict.TYPE_CLAPBOARD_BODY;
			//创建外表面	
			uDir=frontPoints[1].subtract(frontPoints[0]);
			uDir.normalize();
			vDir=frontPoints[1].subtract(frontPoints[2]);
			vDir.normalize();
			if(texMatrix)
			{
				uDir=texMatrix.transformVector(uDir);
				vDir=texMatrix.transformVector(vDir);
			}
			vertices.push(frontPoints[0].x,frontPoints[0].y,frontPoints[0].z);
			vertices.push(frontPoints[1].x,frontPoints[1].y,frontPoints[1].z);
			vertices.push(frontPoints[3].x,frontPoints[3].y,frontPoints[3].z);
			vertices.push(frontPoints[3].x,frontPoints[3].y,frontPoints[3].z);
			vertices.push(frontPoints[1].x,frontPoints[1].y,frontPoints[1].z);
			vertices.push(frontPoints[2].x,frontPoints[2].y,frontPoints[2].z);
			getUV(frontPoints[0],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(frontPoints[1],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(frontPoints[3],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(frontPoints[3],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(frontPoints[1],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(frontPoints[2],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			normals.push(nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z);
			CMeshFactory.Instance.fillMeshByVector(mesh.UniqueID,vertices,uvs,uvs,normals);
			vertices.length=0;
			uvs.length=0;
			normals.length=0;
//			//创建底面
			uDir=backPoints[2].subtract(backPoints[3]);
			uDir.normalize();
			vDir=backPoints[1].subtract(backPoints[2]);
			vDir.normalize();
			if(texMatrix)
			{
				uDir=texMatrix.transformVector(uDir);
				vDir=texMatrix.transformVector(vDir);
			}
			vertices.push(backPoints[3].x,backPoints[3].y,backPoints[3].z);
			vertices.push(backPoints[2].x,backPoints[2].y,backPoints[2].z);
			vertices.push(backPoints[0].x,backPoints[0].y,backPoints[0].z);
			vertices.push(backPoints[0].x,backPoints[0].y,backPoints[0].z);
			vertices.push(backPoints[2].x,backPoints[2].y,backPoints[2].z);
			vertices.push(backPoints[1].x,backPoints[1].y,backPoints[1].z);
			getUV(backPoints[3],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(backPoints[2],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(backPoints[0],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(backPoints[0],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(backPoints[2],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			getUV(backPoints[1],uvOrigin,uDir,vDir,uMax,vMax,uvs);
			normals.push(-nor.x,-nor.y,-nor.z,-nor.x,-nor.y,-nor.z,-nor.x,-nor.y,-nor.z,-nor.x,-nor.y,-nor.z,-nor.x,-nor.y,-nor.z,-nor.x,-nor.y,-nor.z);
			CMeshFactory.Instance.fillMeshByVector(mesh.UniqueID,vertices,uvs,uvs,normals);
			vertices.length=0;
			uvs.length=0;
			normals.length=0;
			if(hasBoardEdge)
			{
				//创建板的边缘模型
				mesh=CMeshFactory.Instance.getMesh(CUtil.Instance.createUID());
				mesh.name=CL3DConstDict.TYPE_CLAPBOARD_EDGE;
				len=frontPoints.length;
				for(i=0; i<len; i++)
				{
					next=i==len-1?0:i+1;
//					uDir=frontPoints[next].subtract(frontPoints[i]);
//					uDir.normalize();
					nor=CMathUtilForAS.Instance.crossByPosition3D(frontPoints[i].x,frontPoints[i].y,frontPoints[i].z,frontPoints[next].x,frontPoints[next].y,frontPoints[next].z,backPoints[i].x,backPoints[i].y,backPoints[i].z);
					nor.normalize();
//					vDir=nor.crossProduct(uDir);
					if(texMatrix)
					{
						uDir=texMatrix.transformVector(uDir);
						vDir=texMatrix.transformVector(vDir);
					}
					vertices.push(frontPoints[i].x,frontPoints[i].y,frontPoints[i].z);
					vertices.push(backPoints[i].x,backPoints[i].y,backPoints[i].z);
					vertices.push(frontPoints[next].x,frontPoints[next].y,frontPoints[next].z);
					vertices.push(frontPoints[next].x,frontPoints[next].y,frontPoints[next].z);
					vertices.push(backPoints[i].x,backPoints[i].y,backPoints[i].z);
					vertices.push(backPoints[next].x,backPoints[next].y,backPoints[next].z);
					getUV(frontPoints[i],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					getUV(backPoints[i],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					getUV(frontPoints[next],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					getUV(frontPoints[next],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					getUV(backPoints[i],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					getUV(backPoints[next],uvOrigin,uDir,vDir,uMax,vMax,uvs);
					normals.push(nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z,nor.x,nor.y,nor.z);
					CMeshFactory.Instance.fillMeshByVector(mesh.UniqueID,vertices,uvs,uvs,normals);
				}
			}
			//
			return CMeshFactory.Instance.endFillMesh();
		}

	}
}
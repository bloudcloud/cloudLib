package cloud.core.utils
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CRay;
	import cloud.core.datas.base.CVector;

	/**
	 * 多边形处理方法工具类
	 * @author cloud
	 * 
	 */	
	public class CGPCUtil
	{
		private static var _Instance:CGPCUtil;
		
		public static function get Instance():CGPCUtil
		{
			return _Instance||=new CGPCUtil(new SingletonEnforce());
		}
		
		public function CGPCUtil(enforcer:SingletonEnforce)
		{
		}
		
		private function searchNextPointIndex(regionPoints:Array,curDir:CVector,curIndex:int,searchedMarks:Array):int
		{
			var len:int;
			var dir:CVector;
			var pos:CVector;
			var tmpDistance:Number;
			var bestDistance:Number=int.MAX_VALUE;
			var bestIndex:int=-1;
			var isSearched:Boolean;
			dir=new CVector();
			pos=new CVector();
			len=regionPoints.length;
			//正方向
			for(var i:int=0; i<len; i++)
			{
				CVector.SetTo(pos,regionPoints[i].x,regionPoints[i].y,0);
				if(isSearchedByCVector(searchedMarks[curIndex],pos,curDir) || regionPoints[curIndex].equals(regionPoints[i])) continue;
				CVector.SetTo(dir,regionPoints[i].x-regionPoints[curIndex].x,regionPoints[i].y-regionPoints[curIndex].y,0);
				tmpDistance=dir.length;
				CVector.Normalize(dir);
				if(CVector.DotValue(dir,curDir)>=1)
				{
					//找到点
					if(bestDistance>tmpDistance)
					{
						bestDistance=tmpDistance;
						bestIndex=i;
					}
				}
			}
			if(bestIndex>=0)
			{
				CVector.SetTo(pos,regionPoints[bestIndex].x,regionPoints[bestIndex].y,0);
				searchedMarks[bestIndex]||=[];
				searchedMarks[bestIndex].push(new CRay(pos.clone() as CVector,curDir.clone() as CVector));
			}
			return bestIndex;
		}
		private function isSearchedByCVector(rays:Array,sourcePos:CVector,sourceDir:CVector):Boolean
		{
			var isSearched:Boolean;
			if(rays && rays.length>0) 
			{
				for each(var ray3d:CRay in rays)
				{
					if(ray3d.isEqualByCVector(sourcePos,sourceDir))
					{
						isSearched=true;
						break;
					}
				}
			}
			return isSearched;
		}
		private function updateIntersectRegionPoints(intersectRegionPoints:Array,intersectPoints:Array,clipPoints:Array):void
		{
			var isSimilared:Boolean;
			var i:int,j:int;
			for(i=0; i<intersectPoints.length; i++)
			{
				CMathUtilForAS.Instance.amendPoint(intersectPoints[i]);
				isSimilared=false;
				for(j=0; j<intersectRegionPoints.length; j++)
				{
					if(CMathUtilForAS.Instance.equalPoints(intersectRegionPoints[j],intersectPoints[i]))
					{
						isSimilared=true;
						break;
					}
				}
				if(!isSimilared)
					intersectRegionPoints.push(intersectPoints[i]);
			}
		}
		/**
		 *  通过围点数组作为数据，根据裁切区域，将原始区域进行裁切，裁切区域围点与原始区域围点的方向必须相反（该方法不改变参数结构）
		 * @param regionPoints 原始区域围点数组
		 * @param clipPoints	裁切区域围点数组
		 * @param clipIndex 	裁切区域围点数组在容器中的索引
		 * @return Array	返回裁切后的区域数组（裁切后的区域可能为多个，所以返回的是二维数组，裁切后的数组围点方向与原始区域方向一致）
		 */		
		public function clipRegionBySlotPoints(regionPoints:Array,clipPoints:Array,clipIndex:int):Array
		{
			var result:Array;
			var tmpArr:Array;
			var i:int,j:int,k:int;
			var cur1:int,next1:int,cur2:int,next2:int;
			var clen:int,rlen:int;
			var nextIndex:int;
			var tmpPoints:Array;//两条线段的交点坐标数组
			var intersectRegionPoints:Array;//原始区域上的交点坐标数组
			var rnor:CVector;	//原始区域法线方向（正）
			var cnor:CVector;	//裁切区域法线方向（负）
			var rline:CVector;
			var cline:CVector;
			var ray1:CRay,ray2:CRay;
			var ctmpPos:CVector;
			var rtmp:CVector;
			var intersectNum1:int,intersectNum2:int;//与裁切线发出的射线相交的原始区域点的个数，用来判断裁切线是否在原始区域内
			
			ray1=new CRay();
			ray2=new CRay();
			
			tmpArr=CMathUtilForAS.Instance.getStartPosIndexByXYArray(regionPoints);
			rnor=new CVector(0,0,CMathUtilForAS.Instance.crossByPoint(regionPoints[tmpArr[1]],regionPoints[tmpArr[2]],regionPoints[tmpArr[0]]));
			CVector.Normalize(rnor);
			tmpArr=CMathUtilForAS.Instance.getStartPosIndexByXYArray(clipPoints);
			cnor=new CVector(0,0,CMathUtilForAS.Instance.crossByPoint(clipPoints[tmpArr[1]],clipPoints[tmpArr[2]],clipPoints[tmpArr[0]]));
			CVector.Normalize(cnor);
			cline=CVector.CreateOneInstance();
			rline=CVector.CreateOneInstance();
			ctmpPos=CVector.CreateOneInstance();
			rtmp=CVector.CreateOneInstance();
			clen=clipPoints.length;
			rlen=regionPoints.length;
			intersectRegionPoints=[];
			//计算交点
			for(i=0; i<clen; i++)
			{
				//裁切图形的每一条边
				intersectNum1=intersectNum2=0;
				cur1=i;
				next1=i==clen-1 ? 0 : i+1;
				//求出正反向两组线段
				CVector.SetTo(cline,clipPoints[next1].x-clipPoints[cur1].x,clipPoints[next1].y-clipPoints[cur1].y,0);
				CVector.SetTo(ctmpPos,clipPoints[cur1].x,clipPoints[cur1].y,0);
				ray1.direction=CVector.CrossValue(cnor,cline);
				ray2.direction=CVector.Negate(ray1.direction,true);
				ray1.originPos=ctmpPos;
				ray2.originPos=ctmpPos;
				//遍历原始区域围点数组，与每一条边计算交点
				for(j=0; j<rlen; j++)
				{
					cur2=j;
					next2= j==rlen-1 ? 0 : j+1;
					tmpPoints=CMathUtilForAS.Instance.lineSegmentIntersectByPoint(clipPoints[cur1],clipPoints[next1],regionPoints[cur2],regionPoints[next2]);
					if(tmpPoints)
					{
						updateIntersectRegionPoints(intersectRegionPoints,tmpPoints,clipPoints);
					}
				}
			}
			if(intersectRegionPoints.length==0) return null;
			//原始区域围点与交点合并
			var ilen:int;
			var dotValue:Number;
			var totalRegionPoints:Array=regionPoints.concat();
			ilen=intersectRegionPoints.length;
			for(i=0; i<intersectRegionPoints.length; i++)
			{
				for(j=0; j<totalRegionPoints.length; j++)
				{
					cur2=j;
					next2= j==totalRegionPoints.length-1 ? 0 : j+1;
					if(CMathUtilForAS.Instance.equalPoints(intersectRegionPoints[i],totalRegionPoints[cur2]) || CMathUtilForAS.Instance.equalPoints(intersectRegionPoints[i],totalRegionPoints[j])) break;
					CVector.SetTo(rline,totalRegionPoints[next2].x-totalRegionPoints[cur2].x,totalRegionPoints[next2].y-totalRegionPoints[cur2].y,0);
					CVector.SetTo(rtmp,intersectRegionPoints[i].x-totalRegionPoints[cur2].x,intersectRegionPoints[i].y-totalRegionPoints[cur2].y,0);
					dotValue=CVector.DotValue(rline,rtmp);
					if(rline.length*rtmp.length-dotValue<1)
					{
						if(rline.length>rtmp.length)
						{
							totalRegionPoints.splice(next2,0,intersectRegionPoints[i]);
							j++;
							break;
						}
					}
				}
			}
			var totalPointStates:Array=new Array(totalRegionPoints.length);
			//计算原始区域的分割区域数组
			var minX:Number=int.MAX_VALUE,minY:Number=int.MAX_VALUE;
			var tlen:int;
			var curIndex:int,lastIndex:int;
			var lastDir:CVector=CVector.CreateOneInstance();
			var curDir:CVector=CVector.CreateOneInstance();
			var curNor:CVector=CVector.CreateOneInstance();
			var tmpPos:CVector=CVector.CreateOneInstance();
			var count1:int,count2:int;
			var newPoints:Array;
			var searchedMarks:Array;
			var startIndex:int;
			var isClipped:Boolean;
			result=[[],[],[]];
			searchedMarks=[];
			
			tlen=totalRegionPoints.length;
			tmpArr=CMathUtilForAS.Instance.getStartPosIndexByXYArray(totalRegionPoints);
			curIndex=tmpArr[0];
			lastIndex=tmpArr[1];
			while(count1<tlen)
			{
				cur1=curIndex;
				next1=curIndex==tlen-1?0:curIndex+1;
				curIndex=next1;
				count1++;
				CVector.SetTo(tmpPos,totalRegionPoints[next1].x,totalRegionPoints[next1].y,0);
				CVector.SetTo(curDir,totalRegionPoints[next1].x-totalRegionPoints[cur1].x,totalRegionPoints[next1].y-totalRegionPoints[cur1].y,0);
				CVector.Normalize(curDir);
				if(isSearchedByCVector(searchedMarks[next1],tmpPos,curDir)) 
				{
					CVector.SetTo(lastDir,curDir.x,curDir.y,curDir.z);
					continue;
				}
				
				newPoints=[];
				CVector.SetTo(lastDir,
					curDir.y*rnor.z-curDir.z*rnor.y,
					curDir.z*rnor.x-curDir.x*rnor.z,
					curDir.x*rnor.y-curDir.y*rnor.x);
				CVector.Normalize(lastDir);
				if(!isClipped && judgePointInContainer(totalRegionPoints[cur1],intersectRegionPoints))
				{
					CVector.SetTo(tmpPos,totalRegionPoints[cur1].x,totalRegionPoints[cur1].y,0);
					if(!isSearchedByCVector(searchedMarks[cur1],tmpPos,lastDir))
					{
						isClipped=true
						result[1].push(newPoints);
						result[2].push(clipIndex);
					}
				}
				else
				{
					isClipped=false;
					result[0].push(newPoints);
				}
				
				cur2=cur1;
				next2=next1;
				startIndex=cur2;
				while(true)
				{
					CVector.SetTo(curDir,totalRegionPoints[next2].x-totalRegionPoints[cur2].x,totalRegionPoints[next2].y-totalRegionPoints[cur2].y,0);
					dotValue=CVector.DotValue(lastDir,curDir);
					CVector.SetTo(curNor,
						lastDir.y*curDir.z-lastDir.z*curDir.y,
						lastDir.z*curDir.x-lastDir.x*curDir.z,
						lastDir.x*curDir.y-lastDir.y*curDir.x);
					CVector.Normalize(curNor);
					if(dotValue==0 && CVector.Equal(curNor,rnor))
					{
						newPoints.push(totalRegionPoints[cur2]);
						CVector.SetTo(tmpPos,totalRegionPoints[cur2].x,totalRegionPoints[cur2].y,0);
						searchedMarks[cur2]||=[];
						CVector.Normalize(lastDir);
						if(!isSearchedByCVector(searchedMarks[cur2],tmpPos,lastDir))
						{
							searchedMarks[cur2].push(new CRay(tmpPos.clone() as CVector,lastDir.clone() as CVector));
						}
						CVector.SetTo(lastDir,curDir.x,curDir.y,curDir.z);
						CVector.Normalize(lastDir);
						cur2=next2;
						next2=cur2==tlen-1?0:cur2+1;
						if(cur2==startIndex) break;
					}
					else
					{
						CVector.SetTo(curDir,
							rnor.y*lastDir.z-rnor.z*lastDir.y,
							rnor.z*lastDir.x-rnor.x*lastDir.z,
							rnor.x*lastDir.y-rnor.y*lastDir.x);
						next2=searchNextPointIndex(totalRegionPoints,curDir,cur2,searchedMarks);
						if(next2<0)
						{
							curDir=CVector.Negate(curDir,true);
							next2=searchNextPointIndex(totalRegionPoints,curDir,cur2,searchedMarks);
						}
						if(next2<0)
						{
							next2=cur2==tlen-1?0:cur2+1;
						}
						newPoints.push(totalRegionPoints[cur2]);
						CVector.SetTo(tmpPos,totalRegionPoints[cur2].x,totalRegionPoints[cur2].y,0);
						searchedMarks[cur2]||=[];
						if(!isSearchedByCVector(searchedMarks[cur2],tmpPos,lastDir))
						{
							searchedMarks[cur2].push(new CRay(tmpPos.clone() as CVector,lastDir.clone() as CVector));
						}
						CVector.SetTo(lastDir,curDir.x,curDir.y,curDir.z);
						CVector.Normalize(lastDir);
						cur2=next2;
						next2=cur2==tlen-1?0:cur2+1;
						if(cur2==startIndex) break;
					}
				}
				CVector.SetTo(lastDir,totalRegionPoints[next1].x-totalRegionPoints[cur1].x,totalRegionPoints[next1].y-totalRegionPoints[cur1].y,0);
				CVector.Normalize(lastDir);
			}
			return result;
		}
		/**
		 * 判断点是否在容器中 
		 * @param p
		 * @param container
		 * @return Boolean
		 * 
		 */		
		public function judgePointInContainer(p:Point,container:Array):Boolean
		{
			var result:Boolean;
			for each(var tmp:Point in container)
			{
				if(CMathUtilForAS.Instance.equalPoints(p,tmp))
				{
					result=true;
					break;
				}
			}
			return result;
		}
		/**
		 * 求两个区域围点的交点，如果不相交返回null
		 * @param roundPoints1
		 * @param roundPoints2
		 * @return Array
		 * 
		 */		
		public function intersectRoundPoints(roundPoints1:Array,roundPoints2:Array):Array
		{
			var i:int,j:int,len1:int,len2:int,next1:int,next2:int;
			var intersectPoints:Array,tmpPoints:Array;
			//计算交点
			len1=roundPoints1.length;
			for(i=len1-1; i>=0; i--)
			{
				next1=i==len1-1 ? 0 : i+1;
				//遍历原始区域围点数组，与每一条边计算交点
				len2=roundPoints2.length;
				for(j=len2-1; j>=0; j--)
				{
					next2= j==len2-1 ? 0 : j+1;
					tmpPoints=CMathUtilForAS.Instance.lineSegmentIntersectByPoint(roundPoints1[i],roundPoints1[next1],roundPoints2[j],roundPoints2[next2]);
					if(tmpPoints)
					{
						intersectPoints||=[];
						updateIntersectRegionPoints(intersectPoints,tmpPoints,roundPoints1);
					}
				}
			}
			return intersectPoints;
		}
//		/**
//		 * 根据多边形围点数组，获取uv容器
//		 * @param points
//		 * @return 
//		 * 
//		 */		
//		public function calculatePolygonUV(points:Array,tile:matrix:Matrix3D):Vector.<Number>
//		{
//			var uvs:Vector.<Number>;
//			if(this.fuvs!=null){
//				return this.fuvs;
//			}
//			
//			if(logTile == null || tile == null)return null;			
//			
//			uvs = new Vector.<Number>();
//			
//			var vSelf:Vector3D = new Vector3D(pt.x, pt.y);
//			vSelf = matrix.transformVector(vSelf);
//			
//			var rect:Rectangle = new Rectangle(vSelf.x - logTile.length / 2, vSelf.y - logTile.width / 2,
//				logTile.length, logTile.width);
//			
//			
//			//设x0,y0为物理砖左上角点， x1,y1为逻辑砖左上角点， (u0,v0)为x1,y1对应在物理砖上的uv值
//			//设(u1,v1)为点p(x2,y2)对应在逻辑砖上的uv值， 那么求点p在物理砖上的uv值(u,v)
//			//u0=(x1-x0)/tile.length, u1=(x2-x1)/logTile.length
//			//u = (x2-x0)/tile.length = (x2-x1+x1-x0)/tile.length = (x2-x1)/tile.length + (x1-x0)/tile.length
//			//=(x2-x1)/tile.length + u0;
//			
//			for(var i:int = 0; i < fPoints.length; ++i)
//			{
//				var vec:Vector3D = new Vector3D(fPoints[i].x, fPoints[i].y);
//				vec = matrix.transformVector(vec);
//				var u:Number = (vec.x-rect.x)/tile.length; //(x2-x1)/tile.length
//				u = u + logTile.uvPoints.x;  // logTile.uvPoints.x即u0
//				uvs.push(u);
//				
//				var v:Number = (vec.y-rect.y)/tile.width;
//				v = v + logTile.uvPoints.y;
//				uvs.push(v);
//			}
//			
//			
//			return uvs;
//		}
	}
}
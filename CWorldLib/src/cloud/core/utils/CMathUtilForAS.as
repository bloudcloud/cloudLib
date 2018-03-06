package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 数学计算方法工具类（AS专用）
	 * @author cloud
	 * @2017-10-23
	 */
	public class CMathUtilForAS
	{
		private static const _CurrentPoint:Point=new Point();
		private static const _CurrentVector3D:Vector3D=new Vector3D();
		
		private static var _Instance:CMathUtilForAS;
		public static function get Instance():CMathUtilForAS
		{
			return _Instance||=new CMathUtilForAS(new SingletonEnforce());
		}
		
		public function CMathUtilForAS(enforcer:SingletonEnforce)
		{
		}
		/**
		 * Point对象转Vector3D对象 
		 * @param p
		 * @param zValue		Vector3D对象的Z值
		 * @return Vector3D
		 * 
		 */		
		public function point2Vector3D(p:Point,zValue:Number=0):Vector3D
		{
			return new Vector3D(p.x,p.y,zValue);
		}
		/**
		 *  Vector3D对象转Point对象
		 * @param v
		 * @return Point
		 * 
		 */		
		public function vector3D2Point(v:Vector3D):Point
		{
			return new Point(v.x,v.y);
		}
		/**
		 * 获取垂直向量 
		 * @param p
		 * @return Point
		 * 
		 */		
		public function getCrossPoint(p:Point):Point
		{
			return new Point(-p.y,p.x);
		}
		/**
		 * 将点整数化 
		 * @param p
		 * @param isNew	是否创建新的点对象
		 * @return Point
		 * 
		 */		
		public function amendPoint(p:Point,isNew:Boolean=false):Point
		{
			var result:Point;
			result=isNew?new Point():p;
			result.x=CMathUtil.Instance.amendInt(p.x);
			result.y=CMathUtil.Instance.amendInt(p.y);
			return result;
		}
		/**
		 * a, b为一条线段两端点  c, d为另一条线段的两端点 相交返回true, 不相交返回false  
		 * @param a	
		 * @param b
		 * @param c
		 * @param d
		 * @return Boolean
		 * 
		 */		
		public function intersect(a:Point,b:Point,c:Point,d:Point):Boolean{
			if(Math.max(a.x, b.x)<Math.min(c.x, d.x) ||
				Math.max(a.y, b.y)<Math.min(c.y, d.y) ||
				Math.max(c.x, d.x)<Math.min(a.x, b.x) ||
				Math.max(c.y, d.y)<Math.min(a.y, b.y)
			)
				return false;  
			if(crossByPoint(a, b, c)*crossByPoint(a, d, b)<0 ||
				crossByPoint(c, d, a)*crossByPoint(c, b, d)<0
			)
				return false;
			return true;
		}
		/**
		 * 判断两点是否相等 
		 * @param pa
		 * @param pb
		 * @param tolerance	 误差值
		 * @return Boolean
		 * 
		 */		
		public function equalPoints(pa:Point,pb:Point,tolerance:Number=.001):Boolean
		{
			return Math.abs(pa.x-pb.x)<=tolerance && Math.abs(pa.y-pb.y)<=tolerance;
		}
		/**
		 * 通过圆的极坐标公式，根据圆的半径和圆心角，获取圆弧上的点的坐标 
		 * @param center	圆心的坐标
		 * @param r	圆的半径
		 * @param angle	圆心角
		 * @param isDegree	圆心角是否是角度值
		 * @param isNew	是否返回新的Point对象
		 * @return Point	圆弧上的点的坐标对象
		 * 
		 */		
		public function calculatePointInRoundByRadius(center:Point,r:Number,angle:Number,isDegree:Boolean=true,isNew:Boolean=true):Point
		{
			var result:Point;
			var radian:Number;
			result=isNew?new Point():_CurrentPoint;
			result.x=center.x+r*Math.cos(radian);
			result.y=center.y+r*Math.sin(radian);
			return result;
		}
		/**
		 *	通过拐角点和拐角点两外侧的两点，求出所构成的圆弧形对应的半径 
		 * @param pCorner	拐角点坐标
		 * @param p1	拐角第一条边外侧一点
		 * @param p2	拐角第二条边外侧一点
		 * @return Number	返回所构成的圆弧形的圆心坐标以及半径，0号元素为圆心点坐标，1号元素为圆的半径
		 * 
		 */		
		public function calculateRadiusByCornerPoints(corner:Point,p1:Point,p2:Point):Array
		{
			var radius:Number;
			var pos:Point;
			var dir:Vector3D;
			var minDis:Number,p1p2Dis:Number;
			//最短一侧的边长
			minDis=Math.min(Point.distance(p2,corner),Point.distance(p1,corner));
			//利用三角函数求出半径
			p1p2Dis=Point.distance(p1,p2);
			radius=p1p2Dis*.5*p1p2Dis/minDis;
			dir=point2Vector3D(getCrossPoint(p2.subtract(p1)));
			dir.normalize();
			dir.negate();
			dir.scaleBy(Math.cos(Math.asin(p1p2Dis*.5/radius))*radius);
			pos=new Point((p1.x+p2.x)*.5+dir.x,(p1.y+p2.y)*.5+dir.y);
			return [pos,radius];
		}
		/**
		 * 均分圆弧，返回圆弧上的每一个均分点
		 * @param p1	原始弧长的起点
		 * @param p2	原始弧长的终点
		 * @param center 圆弧对应的中心点	
		 * @param radius	圆弧对应的半径
		 * @param numberArcs	均分的弧长个数
		 * @return Array	均分后的圆弧点数组
		 * 
		 */		
		public function lerpArc(p1:Point,p2:Point,center:Point,radius:Number,numberArcs:Number=10):Array
		{
			var axis:Vector3D,dir:Vector3D,centerVec:Vector3D,startVec:Vector3D;
			var result:Array;
			var startRadio:Number;
			var dotValue:Number=CMathUtilForAS.Instance.dotByPoint(center,p1,p2);
			var angle:Number=Math.acos(dotValue/radius/radius)/numberArcs;
			var matrix:Matrix3D=new Matrix3D();
			matrix.identity();
			axis=crossByPoint(p1,p2,center)>=0?new Vector3D(0,0,1):new Vector3D(0,0,-1);
			centerVec=point2Vector3D(center);
			startVec=point2Vector3D(p1);
			dir=startVec.subtract(centerVec);
			result=[];
			result.push(startVec);
//			matrix.appendTranslation(dir.x,dir.y,dir.z);
			dir.normalize();
			startRadio=Math.acos(dir.dotProduct(Vector3D.X_AXIS));
			for(var i:int=0; i<numberArcs; i++)
			{
				startRadio-=angle;
				result.push(new Vector3D(radius*Math.cos(startRadio)+centerVec.x,radius*Math.sin(startRadio)+centerVec.y));
			}
			return result;
		}
		/**
		 *  快速排斥实验，判断两个线段张成的矩形区域是否相交
		 * @param s1 第一条线段的起点
		 * @param e1 第一条线段的终点
		 * @param s2 第二条线段的起点
		 * @param e2 第二条线段的终点
		 * @return Boolean 两个线段张成的矩形区域是否相交。具有对称性，即交换两条线段（参数S1与S2交换、E1与E2交换），结果不变
		 * 
		 */		
		public function rectsIntersect(s1:Point,e1:Point,s2:Point,e2:Point):Boolean
		{
			if (Math.min(s1.y,e1.y) <= Math.max(s2.y,e2.y) &&
				Math.max(s1.y,e1.y) >= Math.min(s2.y,e2.y) &&
				Math.min(s1.x,e1.x) <= Math.max(s2.x,e2.x) &&
				Math.max(s1.x,e1.x) >= Math.min(s2.x,e2.x))
				return true;
			return false;
		}
		/**
		 * 判断一个点是否在多边形内部 
		 * @param p	一个点
		 * @param polygonPoints	多边形围点数组
		 * @return Boolean
		 * 
		 */		
		public function judgePointInPolygon(p:Point,polygonPoints:Array):Boolean
		{
			var angle:Number;
			var i:int,len:int,next:int;
			var dotValue:Number;
			len=polygonPoints.length;
			angle=0;
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				if(equalPoints(p,polygonPoints[i]) || equalPoints(p,polygonPoints[next])) break;
				dotValue=dotByPoint(p,polygonPoints[i],polygonPoints[next])/Point.distance(p,polygonPoints[i])/Point.distance(p,polygonPoints[next]);
				angle+=CMathUtil.Instance.toDegrees(Math.acos(dotValue));
				Math.acos(dotValue);
			}
			return CMathUtil.Instance.amendInt(angle)==360;
		}
		/**
		 * 求任意两线段的交点（新）
		 * @param s1 线段a 的起点
		 * @param e1 线段a 的终点
		 * @param s2 线段b 的起点
		 * @param e2 线段b 的终点
		 * @return Array 交点坐标数组（0号位置元素值为a与b平行时，a是否在b的右侧，其他元素为交点坐标，如果a与b重合，可返回2个交点）
		 * 
		 */		
		public function lineSegmentIntersectByPoint(s1:Point,e1:Point,s2:Point,e2:Point):Array{
			var results:Array;
			var c1:Number = crossByPoint(s1,e1,s2);
			var c2:Number = crossByPoint(s1,e1,e2);
			var c3:Number = crossByPoint(s2,e2,s1);
			var c4:Number = crossByPoint(s2,e2,e1);
			// 一条线段的两个端点在另一条线段的同侧，不相交。（可能需要额外处理以防止乘法溢出，视具体情况而定。）
			if (((c1 * c2) > 0) || ((c3 * c4) > 0)) return results;
			if(c1 == 0 && c2 == 0) 
			{             
				// 两条线段共线，利用快速排斥实验进一步判断。此时必有 T3 == 0 && T4 == 0。
				if(rectsIntersect(s1,e1,s2,e2))
				{
					results=[];
					if(dotByPoint(s1,s2,e2)<0)
						results.push(s1);
					if(dotByPoint(e1,s2,e2)<0)
						results.push(e1);
					if(dotByPoint(s2,s1,e1)<0)
						results.push(s2);
					if(dotByPoint(e2,s1,e1)<0)
						results.push(e2);
				}
			} 
			else
			{                                    
				// 其它情况，两条线段相交,利用面积求定比分点，算出交点坐标
				results=[];
				c1=Math.abs(c1);
				c2=Math.abs(c2);
				results.push(new Point((e2.x*c1+s2.x*c2)/(c1+c2),(e2.y*c1+s2.y*c2)/(c1+c2)));
			}
			return results;
		}
		/**
		 * 计算两个向量的外积（叉乘）。可以根据结果的符号判断三个点的位置关系  
		 * @param pa 起点
		 * @param pb 终点
		 * @param pc 直线ab外的一个点
		 * @return Number AC与向量CB的外积。如果结果为正数，表明点C在直线AB（直线方向为从A到B）的右侧； 
		 * 如果结果为负数，表明点C在直线AB（直线方向为从A到B）的左侧；如果结果为0，表明点C在直线AB上。
		 * 
		 */
		[Inline]
		public function crossByPoint(pa:Point,pb:Point,pc:Point):Number
		{
			return (pc.x - pa.x)*(pb.y - pc.y) - (pc.y - pa.y)*(pb.x - pc.x);
		}
		/**
		 * 计算两个向量的点积（点乘）。可以根据符号，判断A点投影是在BC线段的内部还是外部 
		 * @param pa 平面一点
		 * @param pb	线段上的第一个点
		 * @param pc	线段上的第二个点
		 * @return Number
		 * 
		 */	
		[Inline]
		public function dotByPoint(pa:Point,pb:Point,pc:Point):Number
		{
			return (pc.x-pa.x)*(pb.x-pa.x)+(pc.y-pa.y)*(pb.y-pa.y);
		}
		/**
		 * 根据一点，从物体集合中获取拣选到的物体 
		 * @param pos	一个点的坐标
		 * @param objects	物体集合
		 * @return Object	拣选到的物体对象
		 * 
		 */		
		public function getCollisionObject(pos:Vector3D, objects:Array):Object
		{
			var collisionObj:Object;
			var collisions:Array=new Array();
			var minX:Number=int.MAX_VALUE,minY:Number=int.MAX_VALUE;
			var maxX:Number=int.MIN_VALUE,maxY:Number=int.MIN_VALUE;
			var minArea:Number=int.MAX_VALUE;
			for each(var obj:Object in objects)
			{
				if(pos.w==0)
				{
					//2D
					for each(var point:Vector3D in obj.points)
					{
						if(minX>point.x) minX=point.x;
						if(maxX<point.x) maxX=point.x;
						if(minY>point.y) minY=point.y;
						if(maxY<point.y) maxY=point.y;
					}
					if(pos.x>minX && pos.x<maxX && pos.y>minY && pos.y<maxY)
					{
						//选中物体
						collisions.push(obj);
					}
					minX=minY=int.MAX_VALUE;
					maxX=maxY=int.MIN_VALUE;
				}
				else
				{
					//3D
				}
			}
			if(collisions.length==1)
			{
				collisionObj=collisions[0];
			}
			else if(collisions.length>1)
			{
				//选择面积最小的对象
				for each(obj in collisionObj)
				{
					if(minArea>obj.length*obj.height)
					{
						minArea=obj.length*obj.height;
						collisionObj=obj;
					}
				}
				minArea=int.MAX_VALUE;
			}
			return collisionObj;
		}
		/**
		 *  计算二维平面一方向向量的法线方向
		 * @param crossValue
		 * @param dir
		 * @return Point
		 * 
		 */		
		[Inline]
		public function calculateNormalPointByCrossValue(crossValue:Number,dir:Point):Point
		{
			return new Point(-crossValue*dir.y,crossValue*dir.x);
		}
		/**
		 * 获取围点数组中的坐标最小点为起始点（凸角点）
		 * @param xyArray	带有x,y属性的对象集合
		 * @return Array	返回数组中第一个元素为起始点的索引，第二个元素为起始点的上一个点的索引，第三个元素为起始点的下一个点的索引
		 * 
		 */		
		public function getStartPosIndexByXYArray(xyArray:Array):Array
		{
			var result:Array;
			var i:int;
			var len:int;
			var curIndex:int,prevIndex:int,nextIndex:int;
			var minPoint:Point;
			result=[];
			minPoint=new Point();
			len=xyArray.length;
			for(i=0; i<len; i++)
			{
				if(i==0)
				{
					minPoint.setTo(xyArray[0].x,xyArray[0].y);
					curIndex=i;
					prevIndex=len-1;
					nextIndex=1;
				}
				else if(xyArray[i].x<=minPoint.x && xyArray[i].y<=minPoint.y)
				{
					minPoint.setTo(xyArray[i].x,xyArray[i].y);
					curIndex=i;
					prevIndex=i==0?len-1:i-1;
					nextIndex=i==len-1?0:i+1;
				}
			}
			result[0]=curIndex;
			result[1]=prevIndex;
			result[2]=nextIndex;
			return result;
		}
		/**
		 * 获取整体偏移后的新的围点数组 
		 * @param points
		 * @param offset	偏移值（正数代表內缩，负数代表外扩）
		 * @return Array
		 * 
		 */		
		public function getOffsetPoints(points:Array,offset:Number):Array
		{
			if(!points || !points.length) return null;
			var newPoints:Array;
			var i:int,prev:int,next:int,len:int;
			var crossValue:Number,curCrossValue:Number;
			var resultIndexs:Array;
			var dir:Point,nor:Point;
			
			newPoints=[];
			dir=new Point();
			resultIndexs=getStartPosIndexByXYArray(points);
			crossValue=crossByPoint(points[resultIndexs[1]],points[resultIndexs[2]],points[resultIndexs[0]]);
			crossValue=crossValue>0?1:-1;
			len=points.length;
			for(i=0; i<len; i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
				newPoints[i]||=points[i].clone();
				newPoints[next]||=points[next].clone();
				dir.setTo(points[next].x-points[i].x,points[next].y-points[i].y);
				dir.normalize(1);
				curCrossValue=crossByPoint(points[prev],points[next],points[i]);
				nor=calculateNormalPointByCrossValue(curCrossValue,dir);
				if(crossValue*curCrossValue<0)
				{
					nor.normalize(-offset);
				}
				else
				{
					nor.normalize(offset);
				}
				newPoints[i].offset(nor.x,nor.y);
				newPoints[next].offset(nor.x,nor.y);
			}
			return newPoints;
		}
	}
}
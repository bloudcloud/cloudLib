package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CBoundBox;
	import cloud.core.datas.base.CTransform3D;

	/**
	 * 数学计算方法工具类（AS专用）
	 * @author cloud
	 * @2017-10-23
	 */
	public class CMathUtilForAS
	{
		private static const _CurrentPoint:Point=new Point();
		private static const _ZERO:Vector3D=new Vector3D();
		
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
		 * 将3D向量整数化 
		 * @param vec
		 * @param isNew
		 * @return Vector3D
		 * 
		 */		
		public function amendVector3D(vec:Vector3D,isNew:Boolean=false):Vector3D
		{
			var result:Vector3D;
			result=isNew?new Vector3D():vec;
			result.x=CMathUtil.Instance.amendInt(vec.x);
			result.y=CMathUtil.Instance.amendInt(vec.y);
			result.z=CMathUtil.Instance.amendInt(vec.z);
			return result;
		}
		/**
		 * 通过法线向量和方向向量，以及与方向向量的夹角角度值，获取对应的3D向量
		 * @param nor	法线向量
		 * @param right	右侧正向量
		 * @param degree	方向向量与右侧向量的角度值
		 * @return Vector3D
		 * 
		 */		
		public function getVector3DByNormalAndDirection(nor:Vector3D,dir:Vector3D,degree:Number):Vector3D
		{
			nor.normalize();
			dir.normalize();
			var right:Vector3D=nor.crossProduct(dir);
			var matrix:Matrix3D=new Matrix3D();
			matrix.copyColumnFrom(0,dir);
			matrix.copyColumnFrom(1,right);
			matrix.copyColumnFrom(2,nor);
			matrix.appendRotation(degree,nor);
			var result:Vector3D=matrix.transformVector(right);
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
		 * 判断2个3D向量是否相等 
		 * @param a
		 * @param b
		 * @param tolerance		误差值
		 * @return Boolean
		 * 
		 */		
		public function isEqualVector3D(a:Vector3D,b:Vector3D,tolerance:Number=.001):Boolean
		{
			return a&&b ? Math.abs(a.x-b.x)<=tolerance && Math.abs(a.y-b.y)<=tolerance && Math.abs(a.z-b.z)<=tolerance : false;
		}
		/**
		 * 2D平面方向是否正向旋转 
		 * @param firstDir
		 * @param nextDir
		 * @return Boolean
		 * 
		 */		
		public function isPositiveRotation(firstDirX:Number,firstDirY:Number,nextDirX:Number,nextDirY:Number):Boolean
		{
			return firstDirX*nextDirY-firstDirY*nextDirX;
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
		 * 求两条3D线段的交点
		 * @param a		线段1的a端点
		 * @param b		线段1的b端点
		 * @param c		线段2的c端点
		 * @param d		线段2的d端点
		 * @return Array	下标0的值为交点的位置类型，0：线段1和2不共线，1：线段1和2共线。后续下标的值为交点的3D向量坐标
		 * 
		 */		
		public function calculateSegment3DIntersect(a:Vector3D,b:Vector3D,c:Vector3D,d:Vector3D):Array
		{
			var result:Array;
			var intersectResult:Array;
			var intersect:Vector3D=new Vector3D();
			var zero:Vector3D=new Vector3D();
			var ca:Number,cb:Number,cc:Number,cd:Number;
			
			//4个点全部检测是否相交
			cc=crossByPosition3D(a.x,a.y,a.z,b.x,b.y,b.z,c.x,c.y,c.z).length;
			cd=crossByPosition3D(a.x,a.y,a.z,b.x,b.y,b.z,d.x,d.y,d.z).length;
			ca=crossByPosition3D(c.x,c.y,c.z,d.x,d.y,d.z,a.x,a.y,a.z).length;
			cb=crossByPosition3D(c.x,c.y,c.z,d.x,d.y,d.z,b.x,b.y,b.z).length;
			//不相交
			if(cc*cd>0 || ca*cb>0)
			{
				return null;
			}
			result=[];
			if(cc==0 && cd==0)
			{
				//共线
				if(CMathUtil.Instance.dotByPosition3D(a.x,a.y,a.z,c.x,c.y,c.z,d.x,d.y,d.z)>=1 && CMathUtil.Instance.dotByPosition3D(b.x,b.y,b.z,c.x,c.y,c.z,d.x,d.y,d.z)>=1)
				{
					//共线不相交
					return null;
				}
				result[0]=1;
				if(CMathUtil.Instance.dotByPosition3D(a.x,a.y,a.z,c.x,c.y,c.z,d.x,d.y,d.z)<0)
				{
					result.push(a);
				}
				if(CMathUtil.Instance.dotByPosition3D(b.x,b.y,b.z,c.x,c.y,c.z,d.x,d.y,d.z)<0)
				{
					result.push(b);
				}
				if(CMathUtil.Instance.dotByPosition3D(c.x,c.y,c.z,a.x,a.y,a.z,b.x,b.y,b.z)<0)
				{
					result.push(c);
				}
				if(CMathUtil.Instance.dotByPosition3D(d.x,d.y,d.z,a.x,a.y,a.z,b.x,b.y,b.z)<0)
				{
					result.push(d);
				}
			}
			else
			{
				result[0]=1;
				cc=Math.abs(cc);
				cd=Math.abs(cd);
				result.push(new Vector3D((a.x*cd+b.x*cc)/(cc+cd),(a.y*cd+b.y*cc)/(cc+cd),(a.z*cd+b.z*cc)/(cc+cd)));
			}
			return result;
		}

		/**
		 * 求任意两线段的交点（新）
		 * @param s1 线段a 的起点
		 * @param e1 线段a 的终点
		 * @param s2 线段b 的起点
		 * @param e2 线段b 的终点
		 * @return Array 交点数组（如果a与b重合，可返回2个交点）
		 * 
		 */		
		public function calculateSegment2DIntersect(s1:Point,e1:Point,s2:Point,e2:Point):Array{
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
		 * 根据3个2D坐标点，计算两个2D向量的外积（叉乘）。可以根据结果的符号判断三个点的位置关系  
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
		 * 根据3个3D坐标点，计算两个3D向量的叉乘
		 * @param aX	起点X坐标值
		 * @param aY	起点Y坐标值
		 * @param aZ	起点X坐标值
		 * @param bX	终点X坐标值
		 * @param bY	终点Y坐标值
		 * @param bZ	终点Z坐标值
		 * @param cX	线段ab外的点X坐标值
		 * @param cY	线段ab外的点Y坐标值
		 * @param cZ	线段ab外的点Z坐标值
		 * @return Vector3D
		 * 
		 */		
		public function crossByPosition3D(aX:Number,aY:Number,aZ:Number,bX:Number,bY:Number,bZ:Number,cX:Number,cY:Number,cZ:Number):Vector3D
		{
			return new Vector3D(
				(cY-aY)*(bZ-cZ)-(cZ-aZ)*(bY-cY)
				,(cZ-aZ)*(bX-cX)-(cX-aX)*(bZ-cZ)
				,(cX-aX)*(bY-cY)-(cY-aY)*(bX-cX)
			);
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
		 * 获取2D围点数组中的坐标最小点为起始点（凸角点）
		 * @param xyArray	带有x,y属性的对象集合
		 * @param isClosure 围点数组是否是闭合
		 * @return Array	返回数组中第一个元素为起始点的索引，第二个元素为起始点的上一个点的索引，第三个元素为起始点的下一个点的索引
		 * 
		 */		
		public function getStartPosIndexByXYArray(xyArray:*,isClosure:Boolean=true,isMinPoint:Boolean=true):Array
		{
			var result:Array;
			var i:int,cur:int;
			var len:int;
			var curIndex:int,prevIndex:int,nextIndex:int;
			var minPoint:Point=new Point();
			result=[];
			if(xyArray is Array)
			{
				if(isClosure)
				{
					len=xyArray.length;
					cur=0;
				}
				else
				{
					len=xyArray.length-1;
					cur=1;
				}
				for(i=cur; i<len; i++)
				{
					if(i==cur || (minPoint.x>=xyArray[i].x && minPoint.y>=xyArray[i].y))
					{
						minPoint.setTo(xyArray[i].x,xyArray[i].y);
						curIndex=i;
						prevIndex=i==cur?len-1:i-1;
						nextIndex=i==len-1?cur:i+1;
					}
				}
				result[0]=curIndex;
				result[1]=prevIndex;
				result[2]=nextIndex;
			}
			else if(xyArray is Vector.<Number>)
			{
				if(isClosure)
				{
					len=xyArray.length/2;
					cur=0;
				}
				else
				{
					len=xyArray.length/2-1;
					cur=1;
				}
				for(i=cur; i<len; i++)
				{
					if(i==cur || (minPoint.x>=xyArray[i*2] && minPoint.y>xyArray[i*2+1]))
					{
						minPoint.setTo(xyArray[i*2],xyArray[i*2+1]);
						curIndex=i;
						prevIndex=i==cur?len-1:i-1;
						nextIndex=i==len-1?cur:i+1;
					}
				}
				result[0]=curIndex;
				result[1]=prevIndex;
				result[2]=nextIndex;
			}
			return result;
		}
		/**
		 * 根据图形的围点数组，计算图形所在矩形包围框的尺寸 
		 * @param roundPoints	图形的围点数组
		 * @return Point	图形所在矩形包围框的尺寸 
		 * 
		 */		
		public function getSizeByRoundPoints2D(roundPoints:Array):Point
		{
			var minX:Number=0,maxX:Number=0,minY:Number=0,maxY:Number=0;
			for(var i:int=roundPoints.length-1; i>=0; i--)
			{
				if(minX>roundPoints[i].x)
				{
					minX=roundPoints[i].x;
				}
				if(maxX<roundPoints[i].x)
				{
					maxX=roundPoints[i].x;
				}
				if(minY>roundPoints[i].y)
				{
					minY=roundPoints[i].y;
				}
				if(maxY<roundPoints[i].y)
				{
					maxY=roundPoints[i].y;
				}
			}
			return new Point(maxX-minX,maxY-minY);
		}
		/**
		 * 根据图形的围点数组，计算图形所在长方体包围框的尺寸 
		 * @param roundPoints	图形的围点数组
		 * @param matrix		本地变换矩阵
		 * @return Vector3D	图形所在长方体包围框的尺寸 
		 * 
		 */
		public function getSizeByRoundPoints3D(roundPoints:*,matrix:Matrix3D):Vector3D
		{
			if(roundPoints==null)
			{
				return null;
			}
			var result:Vector3D;
			var bounds:Array=getCubeBoxVectorByVertices(roundPoints,matrix);
			var subVec:Vector3D=new Vector3D(bounds[3]-bounds[6],bounds[4]-bounds[7],bounds[5]-bounds[8]);
			var direction:Vector3D=new Vector3D();
			var normal:Vector3D=new Vector3D();
			var vertical:Vector3D=new Vector3D();
			matrix.copyColumnTo(0,direction);
			matrix.copyColumnTo(1,vertical);
			matrix.copyColumnTo(2,normal);
			result=new Vector3D(subVec.dotProduct(direction),subVec.dotProduct(vertical),subVec.dotProduct(normal));
			return result;
		}
		/**
		 * 获取空间坐标系矩阵 
		 * @param direction	方向轴向量
		 * @param normal	法线轴向量
		 * @param vertical	竖直轴向量
		 * @return Matrix3D
		 * 
		 */		
		public function getAxisMatrix3D(direction:Vector3D,normal:Vector3D,vertical:Vector3D):Matrix3D
		{
			return new Matrix3D(Vector.<Number>([
				direction.x,direction.y,direction.z,0
				,normal.x,normal.y,normal.z,0
				,vertical.x,vertical.y,vertical.z,0
				,0,0,0,1]));
		}
		/**
		 * 通过顶点3D向量数组，获取立方体包围盒的中心点，最大范围点，最小范围点
		 * @param vertices
		 * @param matrix
		 * @return Array
		 * 
		 */		
		public function getCubeBoxVectorByVertices(vertices:*,matrix:Matrix3D):Array
		{
			var result:Array;
			var i:int,end:int;
			var maxX:Number,maxY:Number,maxZ:Number,minX:Number,minY:Number,minZ:Number;
			var maxIdx:int,minIdx:int;
			var subVec:Vector3D,direction:Vector3D,vertical:Vector3D;
			var dotDir:Number,dotAxisY:Number;
			var minPosDistance:Number=int.MIN_VALUE,maxPosDistance:Number=int.MIN_VALUE;
			
			direction=new Vector3D();
			vertical=new Vector3D();
			matrix.copyColumnTo(0,direction);
			matrix.copyColumnTo(2,vertical);
			end=vertices.length-1;
			maxX=minX=vertices[end].x;
			maxY=minY=vertices[end].y;
			maxZ=minZ=vertices[end].z;
			maxIdx=minIdx=end;
			var center3D:Vector3D=getCenterByRoundPoints3D(vertices);
			for(i=end; i>=0; i--)
			{
				subVec=vertices[i].subtract(center3D);
				dotDir=subVec.dotProduct(direction);
				dotAxisY=subVec.dotProduct(vertical);
				if(dotDir<=0 && dotAxisY<=0)
				{
					if(minPosDistance<subVec.lengthSquared)
					{
						minPosDistance=subVec.lengthSquared;
						minIdx=i;
					}
				}
				if(dotDir>=0 && dotAxisY>=0)
				{
					if(maxPosDistance<subVec.lengthSquared)
					{
						maxPosDistance=subVec.lengthSquared;
						maxIdx=i;
					}
				}
			}
 			return [center3D.x,center3D.y,center3D.z,vertices[maxIdx].x,vertices[maxIdx].y,vertices[maxIdx].z,vertices[minIdx].x,vertices[minIdx].y,vertices[minIdx].z];
		}
		/**
		 * 根据闭合围点数组，获取围点中心点坐标 
		 * @param point3Ds		闭合围点数组
		 * @return Vector3D		中心点坐标
		 * 	
		 */		
		public function getCenterByRoundPoints3D(point3Ds:*):Vector3D
		{
			var center:Vector3D,tmpPos:Vector3D;
			var maxX:Number,maxY:Number,maxZ:Number,minX:Number,minY:Number,minZ:Number;
			var i:int,end:int;
			
			end=point3Ds.length-1;
			tmpPos=amendVector3D(point3Ds[end]);
			maxX=minX=tmpPos.x;
			maxY=minY=tmpPos.y;
			maxZ=minZ=tmpPos.z;
			for(i=end; i>=0; i--)
			{
				tmpPos=amendVector3D(point3Ds[i]);
				if(minX>=tmpPos.x && minY>=tmpPos.y && minZ>=tmpPos.z)
				{
					minX=tmpPos.x;
					minY=tmpPos.y;
					minZ=tmpPos.z;
				}
				if(maxX<=tmpPos.x && maxY<=tmpPos.y && maxZ<=tmpPos.z)
				{
					maxX=tmpPos.x;
					maxY=tmpPos.y;
					maxZ=tmpPos.z;
				}
			}
			return new Vector3D((maxX+minX)*.5,(maxY+minY)*.5,(maxZ+minZ)*.5);
		}
		/**
		 * 获取3D围点数组中的坐标最小点为起始点（凸角点）
		 * @param points	3D围点坐标值集合
		 * @param isClosure	是否是闭合区域围点数组
		 * @param isStartByMinPoint	起始点是否是坐标最小的点，如果为值为false表示起始点是坐标最大的点
		 * @return Array	返回数组中第一个元素为起始点的索引，第二个元素为起始点的上一个点的索引，第三个元素为起始点的下一个点的索引
		 * 
		 */	
		public function getStartPosIndexByXYZArray(points:*,isClosure:Boolean=true,isStartByMinPoint:Boolean=true):Array
		{
			var result:Array;
			var i:int,len:int,cur:int;
			var rx:Number,ry:Number,rz:Number;
			var idx:int,prev:int,next:int;
			
			if(points is Array || points is Vector.<Vector3D>)
			{
				result=[];
				if(isClosure)
				{
					len=points.length;
					cur=0;
				}
				else
				{
					len=points.length-1;
					cur=1;
				}
				for(i=cur; i<len; i++)
				{
					if(isStartByMinPoint)
					{
						if(i==cur || 
							(isStartByMinPoint && (rx>=CMathUtil.Instance.amendInt(points[i].x) && ry>=CMathUtil.Instance.amendInt(points[i].y) && rz>=CMathUtil.Instance.amendInt(points[i].z))) ||	//选坐标最小值的点
							(!isStartByMinPoint && (rx<=CMathUtil.Instance.amendInt(points[i].x) && ry<=CMathUtil.Instance.amendInt(points[i].y) && rz<=CMathUtil.Instance.amendInt(points[i].z)))	//选坐标最大值的点
						)
						{
							rx=CMathUtil.Instance.amendInt(points[i].x);
							ry=CMathUtil.Instance.amendInt(points[i].y);
							rz=CMathUtil.Instance.amendInt(points[i].z);
							idx=i;
							prev=i==cur?len-1:i-1;
							next=i==len-1?cur:i+1;
						}
					}
				}
				result[0]=idx;
				result[1]=prev;
				result[2]=next;
			}
			else if(points is Vector.<Number>)
			{
				result=[];
				if(isClosure)
				{
					len=points.length/3;
					cur=0;
				}
				else
				{
					len=points.length/3-1;
					cur=1;
				}
				for(i=cur; i<len; i++)
				{
					if(i==cur || 
						(isStartByMinPoint && (rx>=CMathUtil.Instance.amendInt(points[i*3]) && ry>=CMathUtil.Instance.amendInt(points[i*3+1]) && rz>=CMathUtil.Instance.amendInt(points[i*3+2]))) ||
						(!isStartByMinPoint && (rx<=CMathUtil.Instance.amendInt(points[i*3]) && ry<=CMathUtil.Instance.amendInt(points[i*3+1]) && rz<=CMathUtil.Instance.amendInt(points[i*3+2])))
					)
					{
						rx=CMathUtil.Instance.amendInt(points[i*3]);
						ry=CMathUtil.Instance.amendInt(points[i*3+1]);
						rz=CMathUtil.Instance.amendInt(points[i*3+2]);
						idx=i;
						prev=i==cur?len-1:i-1;
						next=i==len-1?cur:i+1;
					}
				}
				result[0]=idx;
				result[1]=prev;
				result[2]=next;
			}
			return result;
		}
		/**
		 * 为围点数组排序,围点数组排序为正向
		 * @param point3Ds	围点数组
		 * @param normal 围点平面的本地坐标轴矩阵，若原先围点数组的本地坐标轴是X,Y,Z标准轴，则该参数直接为空就可以
		 * @param vertical 
		 * @param isInSurface 平面是否是内表面
		 * @param isMinPointStart	起始点是否为坐标最小点
		 * @param isAmend		是否将排序后的围点取整
		 * @param isReverse		是否变为负向围点数组
		 * 
		 */		
		public function sortRoundPoints3D(point3Ds:*,matrix:Matrix3D,isInSurface:Boolean=true,isMinPointStart:Boolean=true,isAmend:Boolean=true):void
		{
			var i:int,len:int;
			var idx:int,prev:int,next:int;
			var isReverse:Boolean;
			var copy:Array;
			var direction:Vector3D,normal:Vector3D,vertical:Vector3D;
			
			direction=new Vector3D();
			normal=new Vector3D();
			vertical=new Vector3D();
			matrix.copyColumnTo(0,direction);
			matrix.copyColumnTo(1,normal);
			matrix.copyColumnTo(2,vertical);
			len=point3Ds.length;
			var bounds:Array=getCubeBoxVectorByVertices(point3Ds,matrix);
			var startPos:Vector3D=isMinPointStart?new Vector3D(bounds[6],bounds[7],bounds[8]):new Vector3D(bounds[3],bounds[4],bounds[5]);
			for(i=0; i<len; i++)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D(startPos,point3Ds[i]))
				{
					idx=i;
					prev=i==0?len-1:i-1;
					next=i==len-1?0:i+1;
					break;
				}
			}
			var crossVec:Vector3D=crossByPosition3D(point3Ds[prev].x,point3Ds[prev].y,point3Ds[prev].z,
																				point3Ds[next].x,point3Ds[next].y,point3Ds[next].z,
																				point3Ds[idx].x,point3Ds[idx].y,point3Ds[idx].z);
			isReverse=isInSurface?crossVec.dotProduct(normal)<0:crossVec.dotProduct(normal)>=0;
			copy=point3Ds.concat();
			if(isReverse)
			{
				copy.reverse();
			}
			for(i=0; i<len; i++)
			{
				if(i>=len-idx)
				{
					point3Ds[i]=copy[i+idx-len];
				}
				else
				{
					point3Ds[i]=copy[i+idx];
				}
				if(isAmend)
				{
					amendVector3D(point3Ds[i]);
				}
			}
		}
		
//		public function judge3DRoundPointsIsPositive(roundPoints:Array,normal:Vector3D):Boolean
//		{
//			return true;
//		}
		/**
		 * 获取围点平面的法线向量 
		 * @param points	围点数组（必须是一个平面上的围点数组）
		 * @param is2D	围点数组中的围点数据是否是2D坐标点
		 * @param isClosure 围点数组是否是闭合
		 * @return Vector3D	
		 * 
		 */		
		public function getPointsPlanNormalVec(points:*,is2D:Boolean=true,isClosure:Boolean=true):Vector3D
		{
			var nor:Vector3D;
			var indice:Array;
			var crossValue:Number;
			if(is2D)
			{
				if(points is Vector.<Number>)
				{
					indice=getStartPosIndexByXYArray(points,isClosure);
					crossValue=CMathUtil.Instance.crossByPointsXY(points[indice[1]*2],points[indice[1]*2+1],points[indice[2]*2],points[indice[2]*2+1],points[indice[0]*2],points[indice[0]*2+1]);
					nor=new Vector3D(0,0,crossValue);
				}
				else if(points is Array)
				{
					indice=getStartPosIndexByXYArray(points,isClosure);
					crossValue=crossByPoint(points[indice[1]],points[indice[2]],points[indice[0]]);
					nor=new Vector3D(0,0,crossValue);
				}
			}
			else
			{
				//3D路径点
				if(points is Vector.<Number>)
				{
					indice=getStartPosIndexByXYZArray(points,isClosure);
					nor=crossByPosition3D(
						points[indice[1]*3],points[indice[1]*3+1],points[indice[1]*3+2],
						points[indice[2]*3],points[indice[2]*3+1],points[indice[2]*3+2],
						points[indice[0]*3],points[indice[0]*3+1],points[indice[0]*3+2]
					);
				}
				else if(points is Array)
				{
					indice=getStartPosIndexByXYArray(points,isClosure);
					nor=crossByPosition3D(
						points[indice[1]].x,points[indice[1]].y,points[indice[1]].z,
						points[indice[2]].x,points[indice[2]].y,points[indice[2]].z,
						points[indice[0]].x,points[indice[0]].y,points[indice[0]].z
					);
				}
			}
			return nor;
		}
		/**
		 * 获取整体偏移后的新的围点数组 
		 * @param points
		 * @param offset	偏移值（正数代表內缩，负数代表外扩）
		 * @param isClosure	围点是否闭合
		 * @return Array
		 * 
		 */		
		public function getOffsetPoint2Ds(points:Array,offset:Number,isClosure:Boolean=true):Array
		{
			if(!points || !points.length) return null;
			var newPoints:Array;
			var i:int,prev:int,next:int,len:int;
			var crossValue:Number,curCrossValue:Number;
			var resultIndexs:Array;
			var dir:Point,nor:Point;
			
			newPoints=[];
			dir=new Point();
			crossValue=getPointsPlanNormalVec(points,true,isClosure).z>0?1:-1;
			len=points.length;
			for(i=0; i<len; i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
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
				newPoints[i]||=points[i].clone();
				newPoints[next]||=points[next].clone();
				if(!isClosure)
				{
					if(i==0)
					{
						newPoints[next].offset(nor.x,nor.y);
					}
					else if(i==len-2)
					{
						newPoints[i].offset(nor.x,nor.y);
						break;
					}
				}
				else
				{
					newPoints[next].offset(nor.x,nor.y);
					newPoints[i].offset(nor.x,nor.y);
				}
			}
			return newPoints;
		}
		/**
		 *	通过3D位置对象集合，获取偏移后的3D围点数组
		 * @param points	3D位置对象集合
		 * @param pointsNormal	3D位置对象所在面的法向量
		 * @param normalOffset	法向量方向上的偏移值
		 * @param verticalOffset	垂直方向上的偏移值
		 * @param isClosure		3D围点数组是否闭合
		 * @return Array	偏移后的3D围点数组
		 * 
		 */	
		public function getOffsetPoint3DsByVector3D(points:*,pointsNormal:Vector3D,normalOffset:Number,verticalOffset:Number,isClosure:Boolean=true):Array
		{
			if(!points || !points.length) return null;
			if(verticalOffset==0)
			{
				return points;
			}
			var result:Array;
			var i:int,prev:int,next:int,len:int,arrLen:int,cur:int;
			var direction:Vector3D,vertical:Vector3D,normal:Vector3D,planNormal:Vector3D;
			
			result=[];
			direction=new Vector3D();
			planNormal=pointsNormal.clone();
			planNormal.normalize();
			planNormal.scaleBy(normalOffset);
			len=points.length;
			for(i=0; i<len; i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
				direction.setTo(points[next].x-points[i].x,points[next].y-points[i].y,points[next].z-points[i].z);
				direction.normalize();
				vertical=direction.crossProduct(pointsNormal);
				vertical.normalize();
				vertical.scaleBy(verticalOffset);
				if(!isClosure)
				{
					if(i==1)
					{
						result[prev].x+=vertical.x;
						result[prev].y+=vertical.y;
						result[prev].z+=vertical.z;
					}
					if(i==len-3)
					{
						result[next+1]=points[next+1].clone();
						result[next+1].x+=planNormal.x+vertical.x;
						result[next+1].y+=planNormal.y+vertical.y;
						result[next+1].z+=planNormal.z+vertical.z;
					}
					if(i==len-1)
					{
						continue;
					}
				}
				arrLen=result.length;
				if(arrLen<=i)
				{
					result[i]=points[i].clone();
					result[i].x+=planNormal.x;
					result[i].y+=planNormal.y;
					result[i].z+=planNormal.z;
				}
				if(arrLen<=next)
				{
					result[next]=points[i].clone();
					result[next].x+=planNormal.x;
					result[next].y+=planNormal.y;
					result[next].z+=planNormal.z;
				}
				result[i].x+=vertical.x;
				result[i].y+=vertical.y;
				result[i].z+=vertical.z;
				result[next].x+=vertical.x;
				result[next].y+=vertical.y;
				result[next].z+=vertical.z;
			}
			return result;
		}
		/**
		 *	获取偏移后的3D围点数组
		 * @param points
		 * @param offset
		 * @param isClosure
		 * @return Vector.<Number>
		 * 
		 */		
		public function getOffsetPoint3DsByNumber(points:Vector.<Number>,pointsNormal:Vector3D,normalOffset:Number,verticalOffset:Number,isClosure:Boolean=true):Vector.<Number>
		{
			if(!points || !points.length) return null;
			
			if(verticalOffset==0)
			{
				return points.concat();
			}
			var result:Array;
			var i:int,prev:int,next:int,len:int,arrLen:int,cur:int;
			var direction:Vector3D,vertical:Vector3D,normal:Vector3D,planNormal:Vector3D;
			result=[];
			direction=new Vector3D();
			planNormal=pointsNormal.clone();
			planNormal.normalize();
			planNormal.scaleBy(normalOffset);
			len=points.length/3;
			for(i=0; i<len; i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
				direction.setTo(points[next*3]-points[i*3],points[next*3+1]-points[i*3+1],points[next*3+2]-points[i*3+2]);
				direction.normalize();
				vertical=pointsNormal.crossProduct(direction);
				vertical.normalize();
				vertical.scaleBy(verticalOffset);
				if(!isClosure)
				{
					if(i==1)
					{
						result[prev*3]+=vertical.x;
						result[prev*3+1]+=vertical.y;
						result[prev*3+2]+=vertical.z;
					}
					if(i==len-3)
					{
						result[next*3]=points[next*3]+planNormal.x+vertical.x;
						result[next*3+1]=points[next*3+1]+planNormal.y+vertical.y;
						result[next*3+2]=points[next*3+2]+planNormal.z+vertical.z;
						result[(next+1)*3]=points[(next+1)*3]+planNormal.x+vertical.x;
						result[(next+1)*3+1]=points[(next+1)*3+1]+planNormal.y+vertical.y;
						result[(next+1)*3+2]=points[(next+1)*3+2]+planNormal.z+vertical.z;
					}
					if(i==len-1)
					{
						continue;
					}
				}
				arrLen=result.length/3;
				if(arrLen<=i)
				{
					result[i*3]=points[i*3]+planNormal.x;
					result[i*3+1]=points[i*3+1]+planNormal.y;
					result[i*3+2]=points[i*3+2]+planNormal.z;
				}
				if(arrLen<=next)
				{
					result[next*3]=points[next*3]+planNormal.x;
					result[next*3+1]=points[next*3+1]+planNormal.y;
					result[next*3+2]=points[next*3+2]+planNormal.z;
				}
				result[i*3]+=vertical.x;
				result[i*3+1]+=vertical.y;
				result[i*3+2]+=vertical.z;
				result[next*3]+=vertical.x;
				result[next*3+1]+=vertical.y;
				result[next*3+2]+=vertical.z;
			}
			return Vector.<Number>(result);
		}
		/**
		 * 通过CTransform3D对象，转换Vector3D对象 
		 * @param target	目标3D向量对象
		 * @param transform	线性变换对象
		 * @return Vector3D 转换后的3D向量对象
		 * 
		 */		
		public function transformVector3DByCTransform3D(target:Vector3D,transform:CTransform3D):Vector3D
		{
			var result:Vector3D=new Vector3D();
			result.x=transform.a*target.x+transform.b*target.y+transform.c*target.z+transform.d;
			result.y=transform.e*target.x+transform.f*target.y+transform.g*target.z+transform.h;
			result.y=transform.i*target.x+transform.j*target.y+transform.k*target.z+transform.l;
			return result;
		}
		/**
		 * 获取点在线段上的投影点，返回是否超出投影距离限制以及投影点的3D坐标值
		 * @param projectDisLimit	投影距离限制
		 * @param segmentStart	线段起点坐标
		 * @param segmentEnd	线段终点坐标
		 * @param originPoint	原点坐标
		 * @return Array	
		 * 
		 */		
		public function getProjectPoint3DAtSegment(projectDisLimit:Number,segmentStart:Vector3D,segmentEnd:Vector3D,originPoint:Vector3D):Array
		{
			var result:Array;
			var dir:Vector3D;
			var dirLength:Number,distance:Number;
			var projectPoint:Vector3D;
			
			result=[];
			dir=segmentEnd.subtract(segmentStart);
			dir.normalize();
			dirLength=originPoint.subtract(segmentStart).dotProduct(dir);
			projectPoint=new Vector3D(segmentStart.x+dir.x*dirLength,segmentStart.y+dir.y*dirLength,segmentStart.z+dir.z*dirLength);
			distance=CMathUtil.Instance.getDistanceByXYZ(originPoint.x,originPoint.y,originPoint.z,projectPoint.x,projectPoint.y,projectPoint.z);
			if(distance<=projectDisLimit)
			{
				result[0]=1;
			}
			else
			{
				result[0]=0;
			}
			result[1]=projectPoint.x;
			result[2]=projectPoint.y;
			result[3]=projectPoint.z;
			return result;
		}
		/**
		 * 通过3D线性变换对象，获取3D矩阵对象 
		 * @param transform
		 * @return 
		 * 
		 */		
		public function getMatrix3DFromTransform3D(transform:CTransform3D):Matrix3D
		{
			var matrix:Matrix3D;
			var vector3d:Vector.<Number>=Vector.<Number>([transform.a, transform.e, transform.i, 0, transform.b, transform.f, transform.j, 0, transform.c, transform.g, transform.k, 0, transform.d, transform.h, transform.l, 1]);
			matrix=new Matrix3D(vector3d);
			return matrix;
		}
		/**
		 * 通过3D矩阵对象，获取3D线性变换对象 
		 * @param matrix
		 * @return CTransform3D
		 * 
		 */		
		public function getTransform3DFromMatrix3D(matrix:Matrix3D):CTransform3D
		{
			var vec:Vector.<Number>=new Vector.<Number>();
			var transform:CTransform3D = CTransform3D.CreateOneInstance();
			matrix.copyRawDataTo(vec,0);
			CTransform3D.CopyFromRowVector(transform,vec);
			return transform;
		}
		/**
		 * 根据3D截面围点坐标值集合，获取3D包围盒对象 
		 * @param point3DValues		3D轮廓围点坐标值集合
		 * @param thickness		厚度
		 * @return CBoundBox
		 * 
		 */		
		public function calculateCBoundBox3D(point3DValues:Vector.<Number>,transform:CTransform3D):CBoundBox
		{
			var i:int;
			var minX:Number,minY:Number,minZ:Number,maxX:Number,maxY:Number,maxZ:Number;
			var output:CBoundBox;
			var tmpPosition:Vector3D;
			
			if(!point3DValues || !point3DValues.length || !transform)
			{
				return null;
			}
			tmpPosition=new Vector3D();
			maxX=maxY=maxZ=int.MIN_VALUE;
			minX=minY=minZ=int.MAX_VALUE;
			for(i=point3DValues.length/3-1; i>=0; i--)
			{
				tmpPosition.setTo(point3DValues[i*3],point3DValues[i*3+1],point3DValues[i*3+2]);
				CMathUtil.Instance.transformVectorByCTransform3D(tmpPosition,transform,false,true);
				if(maxX<tmpPosition.x)
				{
					maxX=tmpPosition.x;
				}
				if(minX>tmpPosition.x)
				{
					minX=tmpPosition.x;
				}
				if(maxY<tmpPosition.y)
				{
					maxY=tmpPosition.y;
				}
				if(minY>tmpPosition.y)
				{
					minY=tmpPosition.y;
				}
				if(maxZ<tmpPosition.z)
				{
					maxZ=tmpPosition.z;
				}
				if(minZ>tmpPosition.z)
				{
					minZ=tmpPosition.z;
				}
			}
			output=new CBoundBox();
			output.maxX=maxX;
			output.minX=minX;
			output.maxY=maxY;
			output.minY=minY;
			output.maxZ=maxZ;
			output.minZ=minZ;
			return output;
		}
		/**
		 *  计算闭合图形的面积 
		 * @param roundPointValues	围点坐标值集合
		 * @param step	坐标值集合的步长
		 * @return Number
		 * 
		 */			
		public function calculateClosureGraph3DArea(roundPointValues:Vector.<Number>,step:int):Number
		{
			if(!roundPointValues||!roundPointValues.length)
			{
				return 0;
			}
			var area:Number=0,num:Number=0;
			var startResult:Array;
			var index:int,next:int,count:int;
			var cross:Vector3D;
			var planNor:Vector3D;
			
			count=roundPointValues.length/step;
			if(step==2)
			{
				startResult=getStartPosIndexByXYArray(roundPointValues);
			}
			else if(step==3)
			{
				startResult=getStartPosIndexByXYZArray(roundPointValues);
			}
			else
			{
				return 0;
			}
			planNor=crossByPosition3D(roundPointValues[step*startResult[1]],roundPointValues[step*startResult[1]+1],roundPointValues[step*startResult[1]+2]
				,roundPointValues[step*startResult[2]],roundPointValues[step*startResult[2]+1],roundPointValues[step*startResult[2]+2]
				,roundPointValues[step*startResult[0]],roundPointValues[step*startResult[0]+1],roundPointValues[step*startResult[0]+2]);
			planNor.normalize();
			index=startResult[0]==count-1?0:startResult[0]+1;
			while(true)
			{
				next=index==count-1?0:index+1;
				if(next==startResult[0])
				{
					break;
				}
				cross=crossByPosition3D(roundPointValues[step*startResult[0]],roundPointValues[step*startResult[0]+1],roundPointValues[step*startResult[0]+2]
						,roundPointValues[step*next],roundPointValues[step*next+1],roundPointValues[step*next+2]
						,roundPointValues[step*index],roundPointValues[step*index+1],roundPointValues[step*index+2]);
				num=cross.normalize();
				if(isEqualVector3D(cross,planNor))
				{
					area+=num;
				}
				else
				{
					area-=num;
				}
				index=next;
			}
			return area*.5;
		}
		
		
	}
}
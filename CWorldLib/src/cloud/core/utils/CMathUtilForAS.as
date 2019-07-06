package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import cloud.core.collections.CTreeNode;
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
		public static const ZERO:Vector3D=new Vector3D();
		public static const XAXIS_NEG:Vector3D=new Vector3D(-1,0,0);
		public static const YAXIS_NEG:Vector3D=new Vector3D(0,-1,0);
		public static const ZAXIS_NEG:Vector3D=new Vector3D(0,0,-1);
		public static const XAXIS_POS:Vector3D=new Vector3D(1,0,0);
		public static const YAXIS_POS:Vector3D=new Vector3D(0,1,0);
		public static const ZAXIS_POS:Vector3D=new Vector3D(0,0,1);
		public static const POSTIVE_AXIS:Vector3D=new Vector3D(1,1,1);
		
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
		public function amendPoint(p:Point,isNew:Boolean=false,tolerance:Number=.5):Point
		{
			var result:Point;
			result=isNew?new Point():p;
			result.x=CMathUtil.Instance.amendInt(p.x,tolerance);
			result.y=CMathUtil.Instance.amendInt(p.y,tolerance);
			return result;
		}
		/**
		 * 将3D向量整数化 
		 * @param vec
		 * @param isNew
		 * @return Vector3D
		 * 
		 */		
		public function amendVector3D(vec:Vector3D,isNew:Boolean=false,tolerance:Number=.5):Vector3D
		{
			var result:Vector3D;
			result=isNew?new Vector3D():vec;
			result.x=CMathUtil.Instance.amendInt(vec.x,tolerance);
			result.y=CMathUtil.Instance.amendInt(vec.y,tolerance);
			result.z=CMathUtil.Instance.amendInt(vec.z,tolerance);
			return result;
		}
		/**
		 * 将3D向量缩放后整数化 
		 * @param vec
		 * @param scaleRatio
		 * @param tolerance
		 * @return 
		 * 
		 */		
		public function amendVector3DByScale(vec:Vector3D,scaleRatio:Number,tolerance:Number=.5):Vector3D
		{
			var x:Number,y:Number,z:Number;
			
			x=CMathUtil.Instance.amendInt(vec.x*scaleRatio,tolerance)/scaleRatio;
			y=CMathUtil.Instance.amendInt(vec.y*scaleRatio,tolerance)/scaleRatio;
			z=CMathUtil.Instance.amendInt(vec.z*scaleRatio,tolerance)/scaleRatio;
			vec.setTo(x,y,z);
			return vec;
		}
		/**
		 * 修正2D平面围点坐标集合 
		 * @param point2Ds
		 * @param isPositive		是否遵循正向排序（值为true代表逆时针正向）
		 * @return Array
		 * 
		 */		
		public function amendRoundPoint2Ds(point2Ds:Array,isPositive:Boolean=true):Array
		{
			var cross:Vector3D;
			var isNoNeedRevert:Boolean;
			var result:Array;
			
			cross=getPointsPlanNormalVec(point2Ds,true);
			cross.normalize();
			isNoNeedRevert=CMathUtilForAS.Instance.isEqualVector3D(ZAXIS_POS,cross) && isPositive;
			if(!isNoNeedRevert)
			{
				result=point2Ds.reverse();
			}
			else
			{
				result=point2Ds;
			}
			return result;
		}
		/**
		 *  修正3D平面围点坐标集合
		 * @param point3Ds
		 * @param isPositive	 是否遵循正向排序（值为true代表逆时针正向）
		 * @param isNew	是否新建
		 * @return Vector.<Number>
		 * 
		 */		
		public function amendRoundPoint3Ds(point3Ds:Vector.<Number>,positiveNormal:Vector3D,isPositive:Boolean=true,isNew:Boolean=false):Vector.<Number>
		{
			var i:int,len:int;
			var cross:Vector3D;
			var isNoNeedRevert:Boolean;
			var result:Vector.<Number>;
			
			cross=getPointsPlanNormalVec(point3Ds,false);
			cross.normalize();
			isNoNeedRevert=CMathUtilForAS.Instance.isEqualVector3D(positiveNormal,cross) && isPositive;
			if(!isNoNeedRevert)
			{
				result=new Vector.<Number>();
				len=point3Ds.length/3;
				for(i=len-1; i>=0; i--)
				{
					result.push(point3Ds[i*3],point3Ds[i*3+1],point3Ds[i*3+2]);
				}
				if(!isNew)
				{
					point3Ds.length=0;
					for(i=0; i<len; i++)
					{
						point3Ds.push(result[i*3],result[i*3+1],result[i*3+2]);
					}
					result=point3Ds;
				}
			}
			else
			{
				result=isNew?point3Ds.concat():point3Ds;
			}
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
		 * 判断2个2D点是否相等 
		 * @param a
		 * @param b
		 * @param tolerance		误差值
		 * @return Boolean
		 * 
		 */		
		public function isEqualPoint(a:Point,b:Point,tolerance:Number=.001):Boolean
		{
			return a&&b ? Math.abs(a.x-b.x)<=tolerance && Math.abs(a.y-b.y)<=tolerance : false;
		}
		/**
		 * 2D平面方向是否正向旋转 
		 * @param firstDir
		 * @param nextDir
		 * @return Boolean
		 * 
		 */		
		public function is2DPositiveRotation(firstDirX:Number,firstDirY:Number,nextDirX:Number,nextDirY:Number):Boolean
		{
			return firstDirX*nextDirY-firstDirY*nextDirX>=0?true:false;
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
			var dotValue:Number=dotByPoint(center,p1,p2);
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
		 * 将3D坐标添加到3D坐标对象容器中，并返回是否成功添加
		 * @param vector3D		3D坐标
		 * @param container	容器
		 * @return Boolean
		 * 
		 */		
		public function addToVector3DContainer(vector3D:Vector3D,container:*):Boolean
		{
			var isHad:Boolean;
			for each(var pos:Vector3D in container)
			{
				if(isEqualVector3D(pos,vector3D))
				{
					isHad=true;
					break;
				}
			}
			if(!isHad)
			{
				container.push(vector3D);
			}
			return !isHad;
		}
		private function doCaulateIntersectedPoints(s:Vector3D,e:Vector3D,ps:Vector3D,pe:Vector3D,origin:Vector3D,numArr:Array):Boolean
		{
			var intersectResult:Array;
			var i:int,len:int;
			var dir1:Vector3D,dir2:Vector3D;
			
			intersectResult=calculateSegment3DIntersect(s,e,ps,pe);
			if(intersectResult && intersectResult.length>0)
			{
				len=intersectResult.length;
				if(len>2)
				{
					dir1=origin.subtract(intersectResult[1]);
					dir2=origin.subtract(intersectResult[2]);
					if(dir1.dotProduct(dir2)>0)
					{
						return false;
					}
					else
					{
						return true;
					}
				}
				for(i=len-1;i>=1;i--)
				{
					if(isEqualVector3D(origin,intersectResult[i]))
					{
						return true;
					}
					if(CMathUtil.Instance.isEqual(intersectResult[i].y,origin.y))
					{
						if(intersectResult[i].x<origin.x)
						{
							addToVector3DContainer(intersectResult[i],numArr[0]);
						}
						else
						{
							addToVector3DContainer(intersectResult[i],numArr[1]);
						}
					}
				}
			}
			return false;
		}
		/**
		 * 判断坐标点是否在多边形内部(用3D坐标)
		 * @param polyValues	3D图形顶点坐标集合
		 * @param px	目标点的X坐标
		 * @param py	目标点的Y坐标
		 * @param pz	目标点的Z坐标
		 * @param tangentAxis		判断用的切线轴坐标
		 * @param isIncludeOnline	点落在多边形边上，是否算做在内部
		 * @return Boolean
		 * 
		 */		
		public function judgePointInPolygonByNumber(polyValues:Vector.<Number>,px:Number,py:Number,pz:Number,invertMatrix:Matrix3D,isIncludeOnline:Boolean=true):Boolean
		{
			var i:int,len:int,next:int;
			var tmpVec:Vector3D,s:Vector3D,e:Vector3D,ps:Vector3D,pe:Vector3D,origin:Vector3D;
			var numArr:Array;
			var isOnline:Boolean;
			
			numArr=[[],[]];
			tmpVec=new Vector3D();
			tmpVec.setTo(px,py,pz);
			origin=invertMatrix.transformVector(tmpVec);
			ps=invertMatrix.transformVector(tmpVec);
			ps.x=int.MIN_VALUE;
			pe=invertMatrix.transformVector(tmpVec);
			pe.x=int.MAX_VALUE;
			len=polyValues.length/3;
			for(i=0;i<len;i++)
			{
				next=i==len-1?0:i+1;
				tmpVec.setTo(polyValues[i*3],polyValues[i*3+1],polyValues[i*3+2]);
				s=invertMatrix.transformVector(tmpVec);
				tmpVec.setTo(polyValues[next*3],polyValues[next*3+1],polyValues[next*3+2]);
				e=invertMatrix.transformVector(tmpVec);
				if(doCaulateIntersectedPoints(s,e,ps,pe,origin,numArr))
				{
					if(isIncludeOnline)
					{
						return true;
					}
				}
			}
			if((numArr[0].length%2)==0 || (numArr[1].length%2)==0)
			{
				return false;
			}
			return true;
		}
		/**
		 * 判断一个点是否在多边形内部 
		 * @param p	一个点
		 * @param polygonPoints	多边形围点数组
		 * @param axis		用于判断的坐标轴
		 * @return Boolean
		 * 
		 */		
		public function judgePointInPolygonByVector3D(p:Vector3D,polygonPoints:Vector.<Number>,axisMatrix:Matrix3D,isIncludeOnline:Boolean):Boolean
		{
			var invertMatrix:Matrix3D=axisMatrix.clone();
			invertMatrix.invert();
			return judgePointInPolygonByNumber(polygonPoints,p.x,p.y,p.z,invertMatrix,isIncludeOnline);
		}
		/**
		 * 判断两组多边形围点对象集合是否发生相交 
		 * @param polygons1	3D空间下的平面围点坐标集合
		 * @param polygons2	3D空间下的平面围点坐标集合
		 * @param axis		用于判断的坐标轴
		 * @return Boolean
		 * 
		 */		
		public function judgePolygonsIntersected(polygons1:Vector.<Number>,polygons2:Vector.<Number>,axisMatrix:Matrix3D):Boolean
		{
			var i:int,len:int;
			var result:Boolean;
			var invertMatrix:Matrix3D;
			invertMatrix=axisMatrix.clone();
			invertMatrix.invert();
			len=polygons1.length/3;
			for(i=0; i<len; i++)
			{
				result=judgePointInPolygonByNumber(polygons2,polygons1[i*3],polygons1[i*3+1],polygons1[i*3+2],invertMatrix);
				if(result)
				{
					break;
				}
			}
			return result;
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
			var va:Vector3D,vb:Vector3D,vc:Vector3D,vd:Vector3D;
			
			//4个点全部检测是否相交
			vc=crossByPosition3D(a.x,a.y,a.z,b.x,b.y,b.z,c.x,c.y,c.z);
			vd=crossByPosition3D(a.x,a.y,a.z,b.x,b.y,b.z,d.x,d.y,d.z);
			va=crossByPosition3D(c.x,c.y,c.z,d.x,d.y,d.z,a.x,a.y,a.z);
			vb=crossByPosition3D(c.x,c.y,c.z,d.x,d.y,d.z,b.x,b.y,b.z);
			//不相交
			if(vc.dotProduct(vd)>0 || va.dotProduct(vb)>0)
			{
				return null;
			}
			result=[];
			cc=vc.z;
			cd=vd.z;
			ca=va.z;
			cb=vb.z;
			vc.normalize();
			vd.normalize();
			va.normalize();
			vb.normalize();
			if(cc==0 && cd==0)
			{
				var da:Number,db:Number,dc:Number,dd:Number;
				var dir1:Vector3D,dir2:Vector3D;
				var inqueue:Function=function(result:Array,pos:Vector3D):void{
					var canPush:Boolean=true;
					for(var i:int=result.length-1; i>=1; i--)
					{
						if(isEqualVector3D(result[i],pos))
						{
							canPush=false;
							break;
						}
					}
					if(canPush)
					{
						result.push(pos.clone());
					}
				}
				dir1=c.subtract(a);
				dir1.normalize();
				dir2=d.subtract(a);
				dir2.normalize();
				da=dir1.dotProduct(dir2);
				dir1=c.subtract(b);
				dir1.normalize();
				dir2=d.subtract(b);
				dir2.normalize();
				db=dir1.dotProduct(dir2);
				dir1=a.subtract(c);
				dir1.normalize();
				dir2=b.subtract(c);
				dir2.normalize();
				dc=dir1.dotProduct(dir2);
				dir1=a.subtract(d);
				dir1.normalize();
				dir2=b.subtract(d);
				dir2.normalize();
				dd=dir1.dotProduct(dir2);
				//共线
				if(CMathUtil.Instance.isEqual(da,1) && CMathUtil.Instance.isEqual(db,1) && CMathUtil.Instance.isEqual(dc,1) && CMathUtil.Instance.isEqual(dd,1))
				{
					//共线不相交
					return null;
				}
				result[0]=1;
				if(da<=0)
				{
					inqueue(result,a);
				}
				if(db<=0)
				{
					inqueue(result,b);
				}
				if(dc<=0)
				{
					inqueue(result,c);
				}
				if(dd<=0)
				{
					inqueue(result,d);
				}
			}
			else
			{
				result[0]=0;
				cc=Math.abs(cc);
				cd=Math.abs(cd);
				result.push(new Vector3D(CMathUtil.Instance.amendInt((ca*b.x-cb*a.x)/(ca-cb)),
					CMathUtil.Instance.amendInt((ca*b.y-cb*a.y)/(ca-cb)),
					CMathUtil.Instance.amendInt((ca*b.z-cb*a.z)/(ca-cb))));
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
		public function crossByPoint(pa:*,pb:*,pc:*):Number
		{
			return (pc.x - pa.x)*(pb.y - pc.y) - (pc.y - pa.y)*(pb.x - pc.x);
		}
		/**
		 * 根据3个3D坐标点，计算两个3D向量的叉乘 (逆时针正向规则)
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
		 *  通过2个向量获取对应的向量积
		 * @param va
		 * @param vb
		 * @param output
		 * @return Vector3D
		 * 
		 */		
		public function crossByVector3D(va:Vector3D,vb:Vector3D,output:Vector3D=null):Vector3D
		{
			var result:Vector3D=!output?new Vector3D():output;
			result.setTo(va.y*vb.z-va.z*vb.y,va.z*vb.x-va.x*vb.z,va.x*vb.y-va.y*vb.x);
			return result;
		}
		/**
		 * 计算两个2D向量的点积（点乘）。可以根据符号，判断A点投影是在BC线段的内部还是外部 
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
		 * 计算两个3D向量的点积（点乘）。
		 * @param a		空间内一点
		 * @param b		线段上的第一个点
		 * @param c		线段上的第二个点
		 * @param isNormal	是否单位化
		 * @return Number	点积的值
		 * 
		 */		
		public function dotByPosition3D(a:Vector3D,b:Vector3D,c:Vector3D,isNormal:Boolean=false):Number
		{
			var dotValue:Number=(b.x-a.x)*(c.x-a.x)+(b.y-a.y)*(c.y-a.y)+(b.z-a.z)*(c.z-a.z);
			return (isNormal && dotValue!=0)?(dotValue/Vector3D.distance(a,b)/Vector3D.distance(a,c)):dotValue;
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
			var center3D:Vector3D=getCenterByRoundPointsVector3D(vertices);
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
		 * 获取2D围点集合区域的中心点坐标
		 * @param point2Ds
		 * @return Vector3D
		 * 
		 */		
		public function getCenterByRoundPoints2D(point2Ds:*):Vector3D
		{
			var center:Vector3D,tmpPos:*;
			var maxX:Number,maxY:Number,minX:Number,minY:Number;
			var i:int;
			
			maxX=maxY=int.MIN_VALUE;
			minX=minY=int.MAX_VALUE;
			for(i=point2Ds.length-1; i>=0; i--)
			{
				tmpPos=point2Ds[i];
				if(minX>=tmpPos.x)
				{
					minX=tmpPos.x;
				}
				if(minY>=tmpPos.y)
				{
					minY=tmpPos.y;
				}
				if(maxX<=tmpPos.x)
				{
					maxX=tmpPos.x;
				}
				if(maxY<=tmpPos.y)
				{
					maxY=tmpPos.y;
				}
			}
			return new Vector3D((maxX+minX)*.5,(maxY+minY)*.5);
		}
		/**
		 * 根据闭合围点数组，获取围点中心点坐标 
		 * @param point3Ds		闭合围点数组
		 * @return Vector3D		中心点坐标
		 * 	
		 */		
		public function getCenterByRoundPointsVector3D(point3Ds:*):Vector3D
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
		 * 获取闭合围点的中心点 
		 * @param pointValues	闭合围点坐标值容器
		 * @return Vector3D
		 * 
		 */		
		public function getCenter3DByRoundPointsValue(pointValues:Vector.<Number>):Vector3D
		{
			var maxX:Number,maxY:Number,maxZ:Number,minX:Number,minY:Number,minZ:Number;
			var i:int,len:int;
			
			maxX=maxY=maxZ=int.MIN_VALUE;
			minX=minY=minZ=int.MAX_VALUE;
			len=pointValues.length/3;
			for(i=0; i<len; i++)
			{
				if(minX>=pointValues[i*3])
				{
					minX=pointValues[i*3];
				}
				if(minY>=pointValues[i*3+1])
				{
					minY=pointValues[i*3+1];
				}
				if(minZ>=pointValues[i*3+2])
				{
					minZ=pointValues[i*3+2];
				}
				if(maxX<=pointValues[i*3])
				{
					maxX=pointValues[i*3];
				}
				if(maxY<=pointValues[i*3+1])
				{
					maxY=pointValues[i*3+1];
				}
				if(maxZ<=pointValues[i*3+2])
				{
					maxZ=pointValues[i*3+2];
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
							(isStartByMinPoint && (rx>=points[i].x && ry>=points[i].y && rz>=points[i].z)) ||	//选坐标最小值的点
							(!isStartByMinPoint && (rx<=points[i].x && ry<=points[i].y && rz<=points[i].z))	//选坐标最大值的点
						)
						{
							rx=points[i].x;
							ry=points[i].y;
							rz=points[i].z;
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
						(isStartByMinPoint && (rx>=points[i*3] && ry>=points[i*3+1] && rz>=points[i*3+2])) ||
						(!isStartByMinPoint && (rx<=points[i*3] && ry<=points[i*3+1] && rz<=points[i*3+2]))
					)
					{
						rx=points[i*3];
						ry=points[i*3+1];
						rz=points[i*3+2];
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
				if(isEqualVector3D(startPos,point3Ds[i]))
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
		 * 获取围点平面的法线向量 （逆时针正向规则）
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
				else if(points is Array || points is Vector.<Vector3D>)
				{
					indice=getStartPosIndexByXYZArray(points,isClosure);
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
//		public function getOffsetPoint3DsByNumber():Vector.<Number>
//		{
		/**
		 * 获取偏移后的3D围点数组 
		 * @param points	3D围点坐标值集合
		 * @param pointsNormal	围点坐标所在平面的3D法向量
		 * @param normalOffset	法向量方向上的偏移值
		 * @param verticalOffset	垂直于围线方向上的偏移值（缩放值）
		 * @param isClosure		3D围点坐标值集合是否是闭合图形
		 * @return Vector.<Number>	返回新的缩放后的3D围点坐标值集合
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
			var prevPos:Vector3D,curPos:Vector3D,nextPos:Vector3D,tmpPos:Vector3D;
			var direction:Vector3D,ver1:Vector3D,ver2:Vector3D,normal:Vector3D,planNormal:Vector3D;
			
			result=[];
			direction=new Vector3D();
			planNormal=pointsNormal.clone();
			planNormal.normalize();
			planNormal.scaleBy(normalOffset);
			len=points.length/3;
			prevPos=new Vector3D();
			curPos=new Vector3D();
			nextPos=new Vector3D();
			for(i=0; i<len; i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
				prevPos.setTo(points[prev*3],points[prev*3+1],points[prev*3+2]);
				curPos.setTo(points[i*3],points[i*3+1],points[i*3+2]);
				nextPos.setTo(points[next*3],points[next*3+1],points[next*3+2]);
				direction.setTo(points[i*3]-points[prev*3],points[i*3+1]-points[prev*3+1],points[i*3+2]-points[prev*3+2]);
				direction.normalize();
				ver1=pointsNormal.crossProduct(direction);
				ver1.normalize();
				ver1.scaleBy(verticalOffset);
				direction.setTo(points[next*3]-points[i*3],points[next*3+1]-points[i*3+1],points[next*3+2]-points[i*3+2]);
				direction.normalize();
				ver2=pointsNormal.crossProduct(direction);
				ver2.normalize();
				ver2.scaleBy(verticalOffset);
				if(!isClosure)
				{
					if(i==0)
					{
						if(normalOffset!=0)
						{
							result.push(points[i*3]+ver2.x+planNormal.x,points[i*3+1]+ver2.y+planNormal.y,points[i*3+2]+ver2.z+planNormal.z);
						}
						else
						{
							result.push(points[i*3]+ver2.x,points[i*3+1]+ver2.y,points[i*3+2]+ver2.z);
						}
					}
					else if(i==len-1)
					{
						if(normalOffset!=0)
						{
							result.push(points[i*3]+ver1.x+planNormal.x,points[i*3+1]+ver1.y+planNormal.y,points[i*3+2]+ver1.z+planNormal.z);
						}
						else
						{
							result.push(points[i*3]+ver1.x,points[i*3+1]+ver1.y,points[i*3+2]+ver1.z);
						}
					}
					else
					{
						tmpPos=getCornerPos(prevPos,curPos,ver1,curPos,nextPos,ver2);
						if(normalOffset!=0)
						{
							result.push(tmpPos.x+planNormal.x,tmpPos.y+planNormal.y,tmpPos.z+planNormal.z);
						}
						else
						{
							result.push(tmpPos.x,tmpPos.y,tmpPos.z);
						}
					}
				}
				else
				{
					tmpPos=getCornerPos(prevPos,curPos,ver1,curPos,nextPos,ver2);
					if(normalOffset!=0)
					{
						result.push(tmpPos.x+planNormal.x,tmpPos.y+planNormal.y,tmpPos.z+planNormal.z);
					}
					else
					{
						result.push(tmpPos.x,tmpPos.y,tmpPos.z);
					}
				}
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
		 * @return Array	第一个索引0表示在投影距离限制外，1表示在投影距离限制内；第二个索引代表投影点的X坐标值；第三个索引代表投影点的Y坐标值，第四个索引代表投影点在线段上还是线段外
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
			if(distance<=projectDisLimit && dotByPosition3D(projectPoint,segmentStart,segmentEnd)<=0)
			{
				result[0]=distance;
			}
			else
			{
				result[0]=-distance;
			}
			result[1]=CMathUtil.Instance.amendInt(projectPoint.x,.0001);
			result[2]=CMathUtil.Instance.amendInt(projectPoint.y,.0001);
			result[3]=CMathUtil.Instance.amendInt(projectPoint.z,.0001);
			var d1:Vector3D=projectPoint.subtract(segmentStart);
			var d2:Vector3D=projectPoint.subtract(segmentEnd);
			result[4]=d1.dotProduct(d2)<=0;
			return result;
		}
		/**
		 * 获取平面上的投影点坐标 
		 * @param originPoint	原点坐标
		 * @param polygonNormal	平面法线
		 * @param polygonPoint	平面上一点
		 * @return Vector3D
		 * 
		 */		
		public function getProjectPoint3DByPolygon(originPoint:Vector3D,polygonNormal:Vector3D,polygonPoint:Vector3D):Vector3D
		{
			var projectPoint:Vector3D;
			var tmpDir:Vector3D;
			var normalLength:Number;
			
			polygonNormal.normalize();
			tmpDir=polygonPoint.subtract(originPoint);
			normalLength=tmpDir.dotProduct(polygonNormal);
			projectPoint=new Vector3D(originPoint.x+polygonNormal.x*normalLength,originPoint.y+polygonNormal.y*normalLength,originPoint.z+polygonNormal.z*normalLength);
			return projectPoint;
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
		/**
		 * 移除所有的树形节点
		 * @param rootNode
		 * 
		 */	
		public function removeAllTreeNode(node:CTreeNode):Boolean
		{
			if(node.parent)
			{
				node.parent.removeChild(node);
				node.parent=null;
			}
			return false;
		}
		/**
		 * 通过线条获取线性变换矩阵 
		 * @param start	线段起点
		 * @param end		线段终点
		 * @param lineNormal	线段的法线向量
		 * @return Matrix3D
		 * 
		 */		
		public function getMatrix3DBySegment(start:Vector3D,end:Vector3D,lineNormal:Vector3D):Matrix3D
		{
			var matrix:Matrix3D;
			var dir:Vector3D,right:Vector3D;
			
			lineNormal.normalize();
			dir=new Vector3D();
			dir.setTo(end.x-start.x,end.y-start.y,end.z-start.z);
			dir.normalize();
			right=dir.crossProduct(lineNormal);
			right.w=0;
			matrix=new Matrix3D();
			matrix.identity();
			matrix.copyColumnFrom(0,dir);
			matrix.copyColumnFrom(1,right);
			matrix.copyColumnFrom(2,lineNormal);
			matrix.appendTranslation((start.x+end.x)*.5,(start.y+end.y)*.5,(start.z+end.z)*.5);
			return matrix;
		}
		/**
		 * 将坐标对象容器转换成数值容器
		 * @param positionContainer	坐标对象容器,例如:Array,Vector.<Point>,Vector.<Vector3D>等
		 * @param containerLength	坐标对象容器的长度
		 * @param step	新容器步长,必须大于0
		 * @return Vector.<Number>
		 * 
		 */		
		public function change2NumberVector(positionContainer:*,containerLength:int,step:int):Vector.<Number>
		{
			var i:int,len:int;
			var result:Vector.<Number>;
			
			if(step<1)
			{
				//步长必须大于0
				return null;
			}
			result=new Vector.<Number>();
			for(i=0; i<containerLength; i++)
			{
				if(step==2)
				{
					result.push(positionContainer[i].x,positionContainer[i].y);
				}
				else if(step==3)
				{
					result.push(positionContainer[i].x,positionContainer[i].y,positionContainer[i].hasOwnProperty("z")?positionContainer[i].z:0);
				}
			}
			return result;
		}
		/**
		 * 将数值容器转换成3D坐标对象容器
		 * @param valueContainer	数值容器
		 * @param step	新容器步长,必须大于0
		 * @return Vector.<Vector3D>
		 * 
		 */		
		public function change2Vector3Ds(valueContainer:Vector.<Number>,step:int):Vector.<Vector3D>
		{
			var i:int,len:int;
			var result:Vector.<Vector3D>;
			
			if(step<1)
			{
				//步长必须大于0
				return null;
			}
			result=new Vector.<Vector3D>();
			len=valueContainer.length/step;
			for(i=0; i<len; i++)
			{
				if(step==2)
				{
					result.push(new Vector3D(valueContainer[i*step],valueContainer[i*step+1]));
				}
				else if(step==3)
				{
					result.push(new Vector3D(valueContainer[i*step],valueContainer[i*step+1],valueContainer[i*step+2]));
				}
			}
			return result;
		}
		/**
		 * 两个闭合区域是否相似 
		 * @param points1
		 * @param points2
		 * @return Boolean
		 * 
		 */		
		public function isSimilarRoundPoints(points1:Vector.<Number>,points2:Vector.<Number>):Boolean
		{
			var i:int,j:int,len1:int,len2:int,prev1:int,next1:int,prev2:int,next2:int;
			var s1:Vector3D,e1:Vector3D,s2:Vector3D,e2:Vector3D;
			
			s1=new Vector3D();
			e1=new Vector3D();
			s2=new Vector3D();
			e2=new Vector3D();
			len1=points1.length/3;
			len2=points2.length/3;
			for(i=0; i<len1; i++)
			{
				prev1=i==0?len1-1:i-1;
				next1=i==len1-1?0:i+1;
				s1.setTo(points1[prev1*3],points1[prev1*3+1],points1[prev1*3+2]);
				e1.setTo(points1[i*3],points1[i*3+1],points1[i*3+2]);
				for(j=0;j<len2;j++)
				{
					prev2=j==0?len2-1:j-1;
					next2=j==len2-1?0:j+1;
					s2.setTo(points2[prev2*3],points2[prev2*3+1],points2[prev2*3+2]);
					e2.setTo(points2[j*3],points2[j*3+1],points2[j*3+2]);
					if(isEqualVector3D(s1,s2) && isEqualVector3D(e1,e2))
					{
						//前一线条相同，判断后一线条是否相同
						s1.setTo(points1[i*3],points1[i*3+1],points1[i*3+2]);
						e1.setTo(points1[next1*3],points1[next1*3+1],points1[next1*3+2]);
						s2.setTo(points2[j*3],points2[j*3+1],points2[j*3+2]);
						e2.setTo(points2[next2*3],points2[next2*3+1],points2[next2*3+2]);
						if(isEqualVector3D(s1,s2) && isEqualVector3D(e1,e2))
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		/**
		 * 为数组每个元素执行回调函数，如果回调函数返回true，则中断遍历并返回发生中断的数组索引
		 * @param array
		 * @param startIndex
		 * @param index
		 * @param callback
		 * @param callbackParams
		 * @return int
		 * 
		 */		
		public function foreachArrayCallback(array:Array,startIndex:int,index:int,callback:Function,callbackParams:Array):int
		{
			var len:int=array.length;
			var next:int=index==len-1?0:index+1;
			var params:Array=callbackParams?callbackParams.concat():null;
			if(params)
			{
				params.unshift(array,index);
			}
			if(callback.apply(null,params))
			{
				return index;
			}
			if(next!=startIndex)
			{
				return foreachArrayCallback(array,startIndex,next,callback,callbackParams);
			}
			return -1;
		}
		/**
		 * 获取两线的缩放夹角点 
		 * @param start1
		 * @param end1
		 * @param vertical1
		 * @param start2
		 * @param end2
		 * @param vertical2
		 * @return Vector3D
		 * 
		 */		
		public function getCornerPos(start1:Vector3D,end1:Vector3D,vertical1:Vector3D,start2:Vector3D,end2:Vector3D,vertical2:Vector3D):Vector3D
		{
			var dir1:Vector3D,dir2:Vector3D;
			var newStart1:Vector3D,newEnd1:Vector3D,newStart2:Vector3D,newEnd2:Vector3D;
			var intersectResult:Array;
			
			dir1=end1.subtract(start1);
			dir1.normalize();
			dir2=end2.subtract(start2);
			dir2.normalize();
			if(CMathUtil.Instance.isEqual(dir1.dotProduct(dir2),1) || CMathUtil.Instance.isEqual(dir1.dotProduct(dir2),-1))
			{
				//两条线共线平行，返回交点坐标
				return end1.add(vertical1);
			}
			newStart1=start1.add(vertical1);
			newEnd1=end1.add(vertical1);
			dir1.setTo(newEnd1.x-newStart1.x,newEnd1.y-newStart1.y,newEnd1.z-newStart1.z);
			dir1.normalize();
			newStart1.setTo(newStart1.x+dir1.x*int.MIN_VALUE,newStart1.y+dir1.y*int.MIN_VALUE,newStart1.z+dir1.z*int.MIN_VALUE);
			newEnd1.setTo(newEnd1.x+dir1.x*int.MAX_VALUE,newEnd1.y+dir1.y*int.MAX_VALUE,newEnd1.z+dir1.z*int.MAX_VALUE);
			newStart2=start2.add(vertical2);
			newEnd2=end2.add(vertical2);
			dir2.setTo(newEnd2.x-newStart2.x,newEnd2.y-newStart2.y,newEnd2.z-newStart2.z);
			dir2.normalize();
			newStart2.setTo(newStart2.x+dir2.x*int.MIN_VALUE,newStart2.y+dir2.y*int.MIN_VALUE,newStart2.z+dir2.z*int.MIN_VALUE);
			newEnd2.setTo(newEnd2.x+dir2.x*int.MAX_VALUE,newEnd2.y+dir2.y*int.MAX_VALUE,newEnd2.z+dir2.z*int.MAX_VALUE);
			intersectResult=calculateSegment3DIntersect(newStart1,newEnd1,newStart2,newEnd2);
			return intersectResult[1];
		}
		/**
		 * 倒置数值容器 
		 * @param source
		 * @param step
		 * @param isNew
		 * @return Vector.<Number>
		 * 
		 */		
		public function revertNumberVerctor(source:Vector.<Number>,step:int,isNew:Boolean=true):Vector.<Number>
		{
			var result:Vector.<Number>;
			var tmpPos:Vector3D;
			var tmpContainer:Vector.<Vector3D>;
			var i:int,len:int;
			
			if(step>3 || step<1)
			{
				return null;
			}
			tmpContainer=new Vector.<Vector3D>();
			len=source.length/step;
			for(i=0;i<len;i++)
			{
				switch(step)
				{
					case 1:
						tmpPos=new Vector3D(source[i*step]);
						break;
					case 2:
						tmpPos=new Vector3D(source[i*step],source[i*step+1]);
						break;
					case 3:
						tmpPos=new Vector3D(source[i*step],source[i*step+1],source[i*step+2]);
						break;
				}
				tmpContainer.push(tmpPos);
			}
			tmpContainer.reverse();
			if(isNew)
			{
				result=new Vector.<Number>();
			}
			else
			{
				result=source;
				source.length=0;
			}
			for(i=0;i<len;i++)
			{
				switch(step)
				{
					case 1:
						result.push(tmpContainer[i].x);
						break;
					case 2:
						result.push(tmpContainer[i].x,tmpContainer[i].y);
						break;
					case 3:
						result.push(tmpContainer[i].x,tmpContainer[i].y,tmpContainer[i].z);
						break;
				}
			}
			return result;
		}
	}
}
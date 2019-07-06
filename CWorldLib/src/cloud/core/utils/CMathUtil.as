package cloud.core.utils
{
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.dict.CConst;
	
	/**
	 *  数学方法工具类
	 * @author cloud
	 */
	public class CMathUtil
	{
		private static var _Instance:CMathUtil;
		
		public static function get Instance():CMathUtil
		{
			return _Instance ||= new CMathUtil(new SingletonEnforce());
		}

		public function CMathUtil(enforcer:SingletonEnforce)
		{
		}
		
		/**
		 *  将浮点数整数化
		 * @param val
		 * @return Number
		 * 
		 */		
		public function amendInt(val:Number,tolerance:Number=.5):Number
		{
			return Number(val>0?int(val+tolerance):int(val-tolerance));
		}
		
		/**
		 * 角度转弧度 
		 * @param degrees
		 * @return Number
		 * 
		 */		
		public function toRadians(degrees:Number):Number
		{
			return degrees * CConst.DEGREES_TO_RADIANS;
		}
		/**
		 * 弧度转角度 
		 * @param radians
		 * @return Number
		 * 
		 */		
		public function toDegrees(radians:Number,isInt:Boolean=true):Number
		{
			return isInt?amendInt(radians * CConst.RADIANS_TO_DEGREES):radians * CConst.RADIANS_TO_DEGREES;
		}

		/**
		 * 求直线方程K值,即斜率
		 * 垂直于X轴的线段值为正无穷或负无穷
		 * @param _pointA  线段上的一个点
		 * @param _pointB  线段上的一个点
		 * @return  返回斜率k
		 * 
		 */		
		public function lineK(x1:Number,y1:Number,x2:Number,y2:Number):Number{
			return x1-x2==0?CConst.TAN_RADIAN_90:(y1-y2)/(x1-x2);
		}
		/**
		 * 用XYZ坐标获取两点间的距离 
		 * @param x1
		 * @param y1
		 * @param z1
		 * @param x2
		 * @param y2
		 * @param z2
		 * @return Number
		 * 
		 */		
		public function getDistanceByXYZ(x1:Number,y1:Number,z1:Number,x2:Number,y2:Number,z2:Number):Number
		{
			return Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
		}
		/**
		 *	用XY坐标获取两点间的距离 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return N	umber
		 * 
		 */		
		public function getDistanceByXY(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			return Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
		}
		
		/**
		 * 根据对称轴关系,计算镜像后的路径点容器
		 * @param pathContainer	 路径点容器
		 * @param originPos		对称点坐标
		 * @param isHorizontal		水平轴对称
		 * @param isVerticalAxis	竖直轴对称
		 * @param isNew 是否创建新的容器
		 * @return Vector.<Number>
		 * 
		 */		
		public function calMirrorByAxis(pathContainer:Vector.<Number>,originPos:*,isHorizontal:Boolean,isVerticalAxis:Boolean,isNew:Boolean):Vector.<Number>
		{
			var resultContainer:Vector.<Number>;
			var count:uint = pathContainer.length;
			resultContainer= isNew ? pathContainer.concat() : pathContainer;
			for (var j:uint = 0; j < count; j += 3)
			{
				var x:Number = resultContainer[j];
				var y:Number = resultContainer[j+1];
				var z:Number = resultContainer[j+2];
				if(isHorizontal)
					resultContainer[j+2]=originPos.z*2-z;
				if(isVerticalAxis)
					resultContainer[j]=originPos.x*2-x;
			}
			return resultContainer;
		}
		
		/**
		 * 计算两个2D向量的外积（叉乘）。可以根据结果的符号判断三个点的位置关系  
		 * @param pa 起点
		 * @param pb 终点
		 * @param pc 线段ab外的一个点
		 * @return Number AC与向量CB的外积。如果结果为正数，表明点C在直线AB（直线方向为从A到B）的右侧； 
		 * 如果结果为负数，表明点C在直线AB（直线方向为从A到B）的左侧；如果结果为0，表明点C在直线AB上。
		 * 
		 */
		[Inline]
		public function crossByPointsXY(aX:Number,aY:Number,bX:Number,bY:Number,cX:Number,cY:Number):Number
		{
			return (cX - aX) * (bY - cY) - (cY - aY) * (bX - cX);
		}
		/**
		 *  计算两个3D向量的内积（ab点乘ac）
		 * @param aX	起点X坐标值
		 * @param aY	起点Y坐标值
		 * @param aZ	起点X坐标值
		 * @param bX	终点1X坐标值
		 * @param bY	终点1Y坐标值
		 * @param bZ	终点1Z坐标值
		 * @param cX	终点2X坐标值
		 * @param cY	终点2Y坐标值
		 * @param cZ 	终点2Z坐标值
		 * @return Number	
		 * 
		 */		
		public function dotByPosition3D(aX:Number,aY:Number,aZ:Number,bX:Number,bY:Number,bZ:Number,cX:Number,cY:Number,cZ:Number):Number
		{
			return (bX-aX)*(cX-aX)+(bY-aY)*(cY-aY)+(bZ-aZ)*(cZ-aZ);
		}
		/**
		 * 比较两个值是否相似 
		 * @param a
		 * @param b
		 * @param tolerance
		 * @return Boolean
		 * 
		 */	
		public function isEqual(a:Number,b:Number,tolerance:Number=.0001):Boolean
		{
			return (Math.abs(a-b))<=tolerance;
		}
		/**
		 * 计算两个向量的叉乘值，并更新输出向量
		 * @param v1	向量1
		 * @param v2	向量2
		 * @param cross	叉乘向量
		 * 
		 */		
		public function calculateCrossVector3D(v1:*,v2:*,cross:*):void
		{
			if(!v1||!v2||!cross)
			{
				return;
			}
			cross.x=v1.y*v2.z-v1.z*v2.y;
			cross.y=v1.z*v2.x-v1.x*v2.z;
			cross.z=v1.x*v2.y-v1.y*v2.x;
		}
		/**
		 * 通过CTransform3D对象转换3D向量对象 
		 * @param vec	3D向量对象
		 * @param transform	线性变换对象（3*4矩阵）
		 * @param isNew	是否返回一个新的3D向量对象
		 * @return *
		 * 
		 */		
		public function transformVectorByCTransform3D(vec:*,transform:CTransform3D,isNew:Boolean=true,isNeedInvert:Boolean=false):*
		{
			var realTransform:CTransform3D;
			var newVec:*=isNew ? vec.clone() : vec;
			var x:Number=vec.x;
			var y:Number=vec.y;
			var z:Number=vec.z;
			if(isNeedInvert)
			{
				realTransform=CTransform3D.CreateOneInstance();
				CTransform3D.Copy(realTransform,transform);
				CTransform3D.Invert(realTransform);
			}
			else
			{
				realTransform=transform;
			}
			newVec.x=realTransform.a*x+realTransform.b*y+realTransform.c*z+realTransform.d;
			newVec.y=realTransform.e*x+realTransform.f*y+realTransform.g*z+realTransform.h;
			newVec.z=realTransform.i*x+realTransform.j*y+realTransform.k*z+realTransform.l;
			return newVec;
		}
		/**
		 * 计算3D线性变换对象的值 
		 * @param transform
		 * @param xAxis
		 * @param yAxis
		 * @param zAxis
		 * @param position
		 * @param isNew
		 * @return CTransform3D
		 * 
		 */		
		public function calculateTransform3D(transform:CTransform3D,xAxis:*,yAxis:*,zAxis:*,position:*,isNew:*=false):CTransform3D
		{
			var result:CTransform3D=isNew ? CTransform3D.CreateOneInstance() as CTransform3D : transform;
			result.a=xAxis.x;
			result.b=yAxis.x;
			result.c=zAxis.x;
			result.d=position.x;
			result.e=xAxis.y;
			result.f=yAxis.y;
			result.g=zAxis.y;
			result.h=position.y;
			result.i=xAxis.z;
			result.j=yAxis.z;
			result.k=zAxis.z;
			result.l=position.z;
			return result;
		}
		/**
		 * 解析3D线性变换对象 
		 * @param transform
		 * @param xAxis
		 * @param yAxis
		 * @param zAxis
		 * @param position
		 * 
		 */		
		public function decomposeTransform3D(transform:*,xAxis:*,yAxis:*,zAxis:*,position:*):void
		{
			if(!transform||!xAxis||!yAxis||!zAxis||!position)
			{
				return;
			}
			xAxis.x=transform.a;
			yAxis.x=transform.b;
			zAxis.x=transform.c;
			position.x=transform.d;
			xAxis.y=transform.e;
			yAxis.y=transform.f;
			zAxis.y=transform.g;
			position.y=transform.h;
			xAxis.z=transform.i;
			yAxis.z=transform.j;
			zAxis.z=transform.k;
			position.z=transform.l;
		}
		
		
	}
}
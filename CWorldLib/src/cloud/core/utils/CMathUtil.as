package cloud.core.utils
{
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
		public function amendInt(val:Number):Number
		{
			return Number(val>0?int(val+.5):int(val-.5));
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
		public function toDegrees(radians:Number):Number
		{
			return radians * CConst.RADIANS_TO_DEGREES;
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
		 * 计算两个向量的外积（叉乘）。可以根据结果的符号判断三个点的位置关系  
		 * @param pa 起点
		 * @param pb 终点
		 * @param pc 直线ab外的一个点
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
		 * 比较两个值是否相似 
		 * @param a
		 * @param b
		 * @param tolerance
		 * @return Boolean
		 * 
		 */	
		[Inline]
		public function equalByValue(a:Number,b:Number,tolerance:Number=.001):Boolean
		{
			return Math.abs(a-b)<=.001;
		}
	}
}
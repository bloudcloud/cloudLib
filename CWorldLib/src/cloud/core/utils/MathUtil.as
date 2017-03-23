package cloud.core.utils
{
	/**
	 *  数学工具
	 * @author cloud
	 */
	public class MathUtil
	{
		/**
		 * tan(89.999)
		 */		
		public static const TAN_RADIAN_90:Number=57295.77950726455;
		public static const RADIANS_TO_DEGREES:Number = 180/Math.PI;
		public static const DEGREES_TO_RADIANS:Number = Math.PI/180;
		
		public function MathUtil()
		{
		}
		/**
		 * 角度转弧度 
		 * @param degrees
		 * @return Number
		 * 
		 */		
		public static function toRadians(degrees:Number):Number
		{
			return degrees * DEGREES_TO_RADIANS;
		}
		/**
		 * 弧度转角度 
		 * @param radians
		 * @return Number
		 * 
		 */		
		public static function toDegrees(radians:Number):Number
		{
			return radians * RADIANS_TO_DEGREES;
		}
		/**
		 * 求直线方程K值,即斜率
		 * 垂直于X轴的线段值为正无穷或负无穷
		 * @param _pointA  线段上的一个点
		 * @param _pointB  线段上的一个点
		 * @return  返回斜率k
		 * 
		 */		
		public static function lineK(x1:Number,y1:Number,x2:Number,y2:Number):Number{
			return x1-x2==0?TAN_RADIAN_90:(y1-y2)/(x1-x2);
		}
		/**
		 * 用坐标获取两点间的距离 
		 * @param x1
		 * @param y1
		 * @param z1
		 * @param x2
		 * @param y2
		 * @param z2
		 * @return Number
		 * 
		 */		
		public static function getDistanceByXYZ(x1:Number,y1:Number,z1:Number,x2:Number,y2:Number,z2:Number):Number
		{
			return Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
		}
		
		/**
		 * 求两根直线的交点
		 * @param _pointA1  直线A上的一点
		 * @param _pointA2  直线A上的一点
		 * @param _pointB1  直线B上的一点
		 * @param _pointB2  直线B上的一点
		 * @return  返回交点坐标，null 两线平行
		 * 
		 */		
		public static function lineIntersection(ax1:Number,ay1:Number,ax2:Number,ay2:Number,bx1:Number,by1:Number,bx2:Number,by2:Number):Vector2D
		{
			var aK:Number = lineK(ax1,ay1,ax2,ay2);
			var bK:Number = lineK(bx1,by1,bx2,by2);
			if(isNaN(aK) || isNaN(bK) || Math.abs(aK-bK)<0.001)
			{
				return null;
			}
			var point:Vector2D = new Vector2D();
			var aB:Number;
			var bB:Number;
			///////////////////////////////////////////////////////start
			var negativeTan:Number=-TAN_RADIAN_90;
			if(aK>=TAN_RADIAN_90||aK<=negativeTan)
			{
				//a垂直
				point.x=ax1;
				bB = by1 - bK*bx1;
				point.y = bK*point.x+bB;
			}
			else if(bK>=TAN_RADIAN_90||bK<=negativeTan)
			{
				//b垂直
				point.x = bx1;
				aB =  ay1 - aK*ax1;
				point.y = aK*point.x+aB;
			}
			else
			{
				//不垂直的两条线
				aB = ay1 - aK*ax1;
				bB = by1 - bK*bx1;
				point.x  =  (bB-aB)/(aK-bK);
				point.y = point.x*aK+aB;
			}
			return point;
		}

	}
}
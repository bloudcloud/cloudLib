package cloud.core.singleton
{
	import flash.geom.Vector3D;
	
	import cloud.core.utils.MathUtil;
	import cloud.core.utils.Ray3D;

	/**
	 *  3D向量工具
	 * @author cloud
	 */
	public class CVector3DUtil
	{
		public static const NEGATIVE_X_AXIS:Vector3D = new Vector3D(-1,0,0);
		public static const NEGATIVE_Y_AXIS:Vector3D = new Vector3D(0,-1,0);
		public static const NEGATIVE_Z_AXIS:Vector3D = new Vector3D(0,0,-1);
		public static const X_AXIS:Vector3D = new Vector3D(1,0,0);
		public static const Y_AXIS:Vector3D = new Vector3D(0,1,0);
		public static const Z_AXIS:Vector3D = new Vector3D(0,0,1);
		public static const ZERO:Vector3D = new Vector3D();
		public static const RAY_3D:Ray3D = new Ray3D();
		
		private static var _instance:CVector3DUtil;
		
		public static function get instance():CVector3DUtil
		{
			return _instance ||= new CVector3DUtil(new SingletonEnforce());
		}
		
		public function CVector3DUtil(enforcer:SingletonEnforce)
		{
		}
		/**
		 * 用向量方法获取点到线段的距离 
		 * @param a	线上a点
		 * @param b	线上b点
		 * @param p	空间一点
		 * @return Number 最短距离
		 * 
		 */		
		public function getPointToSegmentDistanceByVector(a:Vector3D,b:Vector3D,p:Vector3D):Number
		{
			var returnLength:Number;
			var product:Number;
			var scale:Number;
			var ap:Vector3D = p.subtract(a);
			var ab:Vector3D = b.subtract(a);
			var ac:Vector3D = ab.clone();
			product=ap.dotProduct(ab);
			scale=product / ab.lengthSquared;
			if(scale<=0)
			{
				returnLength = ap.length;
			}
			else if(scale>=1)
			{
				returnLength = p.subtract(b).length;
			}
			else
			{
				ac.scaleBy(scale);
				returnLength=ac.subtract(ap).length;
			}
			return returnLength;
		}
		/**
		 * 在XY平面内计算轴方向与当前方向的夹角
		 * @param dir	当前方向
		 * @param axis	轴方向
		 * @param isDegreeORRadian	ture返回角度值，false返回弧度值
		 * @return Number	夹角
		 * 
		 */		
		public function calculateRotationByAxis(dir:Vector3D,axis:Vector3D,isDegreeORRadian:Boolean=true):Number
		{
			var angle:Number;
			var len:Number = dir.length;
			var dot:Number = dir.dotProduct(axis);
			var cosValue:Number = dot / len;
			var nor:Vector3D=dir.crossProduct(axis);
			if(nor.dotProduct(NEGATIVE_Z_AXIS)<0)
				angle=isDegreeORRadian ? MathUtil.instance.toDegrees(Math.acos(cosValue))*-1 : Math.acos(cosValue)*-1;
			else
				angle=isDegreeORRadian ? MathUtil.instance.toDegrees(Math.acos(cosValue)) : Math.acos(cosValue);
			return angle;
		}
		/**
		 * 将2D点坐标转换成3D点坐标
		 * @param roundPoints
		 * @return Vector.<Vector3D>
		 * 
		 */		
		public function transformPointsToVector3Ds(roundPoints:Array):Vector.<Vector3D>
		{
			var len:int=roundPoints.length;
			var points:Vector.<Vector3D>=new Vector.<Vector3D>(len);
			for(var i:int=0; i<len; i++)
			{
				points[i]=new Vector3D(roundPoints[i].x,roundPoints[i].y,0);
			}
			return points;
		}

	}
}
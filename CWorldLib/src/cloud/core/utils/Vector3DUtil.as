package cloud.core.utils
{
	import flash.geom.Vector3D;

	/**
	 *  3D向量工具
	 * @author cloud
	 */
	public class Vector3DUtil
	{
		public static const NEGATIVE_X_AXIS:Vector3D = new Vector3D(-1,0,0);
		public static const NEGATIVE_Y_AXIS:Vector3D = new Vector3D(0,-1,0);
		public static const NEGATIVE_Z_AXIS:Vector3D = new Vector3D(0,0,-1);
		public static const X_AXIS:Vector3D = new Vector3D(1,0,0);
		public static const Y_AXIS:Vector3D = new Vector3D(0,1,0);
		public static const Z_AXIS:Vector3D = new Vector3D(0,0,1);
		public static const ZERO:Vector3D = new Vector3D();
		public static const RAY_3D:Ray3D = new Ray3D();
		/**
		 * 用向量方法获取点到线段的距离 
		 * @param a	线上a点
		 * @param b	线上b点
		 * @param p	空间一点
		 * @return Number 最短距离
		 * 
		 */		
		public static function getPointToSegmentDistanceByVector(a:Vector3D,b:Vector3D,p:Vector3D):Number
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
		public static function calculateRotationByAxis(dir:Vector3D,axis:Vector3D,isDegreeORRadian:Boolean=true):Number
		{
			var angle:Number;
			var len:Number = dir.length;
			var dot:Number = axis.dotProduct(dir);
			var cosValue:Number = dot / len;
			var nor:Vector3D=axis.crossProduct(dir);
			if(nor.dotProduct(Vector3D.Z_AXIS)<0)
				angle=isDegreeORRadian ? MathUtil.toDegrees(Math.acos(cosValue))*-1 : Math.acos(cosValue)*-1;
			else
				angle=isDegreeORRadian ? MathUtil.toDegrees(Math.acos(cosValue)) : Math.acos(cosValue);
			return angle;
		}
		
		public function Vector3DUtil()
		{
		}
	}
}
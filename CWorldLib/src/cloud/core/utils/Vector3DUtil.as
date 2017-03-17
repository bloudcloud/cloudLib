package cloud.core.utils
{
	import flash.geom.Vector3D;

	/**
	 *  3D向量工具
	 * @author cloud
	 */
	public class Vector3DUtil
	{
		public static const ZERO:Vector3D = new Vector3D();
		public static const AXIS_X:Vector3D = new Vector3D(1,0,0);
		public static const AXIS_Y:Vector3D = new Vector3D(0,1,0);
		public static const AXIS_Z:Vector3D = new Vector3D(0,0,1);
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
		
		public function Vector3DUtil()
		{
		}
	}
}
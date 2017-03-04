package cloud.core.utils
{
	import flash.geom.Vector3D;
	
	public class CMathUtil
	{
		
		public function CMathUtil()
		{
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
	}
}
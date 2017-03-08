package cloud.core.utils
{
	import flash.geom.Vector3D;
	
	public class CMathUtil
	{
		public static const RADIANS_TO_DEGREES:Number = 180/Math.PI;
		public static const DEGREES_TO_RADIANS:Number = Math.PI/180;
		
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
		
	}
}
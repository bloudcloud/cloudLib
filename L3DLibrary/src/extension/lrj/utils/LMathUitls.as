package extension.lrj.utils
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class LMathUitls
	{
		private static var _Instance:LMathUitls;
		
		public static function get Instance():LMathUitls
		{
			return _Instance || new LMathUitls();
		}
		
		public function LMathUitls()
		{
		}
		
		/**
		 * 2D下点到直线垂点坐标 
		 * @param start
		 * @param end
		 * @param target
		 * @return 
		 * 
		 */		
		public function getVerticalPoint2D(start:Point, end:Point, target:Point):Point 
		{
			var result:Point;
			
			var dx:Number = start.x - end.x;
			var dy:Number = start.y - end.y;
			
			if(Math.abs(dx) < 0.00000001 && Math.abs(dy) < 0.00000001)
			{
				result = start;
				return result;
			}
			
			var u:Number = (target.x - start.x) * (start.x -end.x) + (target.y - start.y) * (start.y - end.y);
			
			u = u / ((dx * dx) + (dy * dy));
			
			result.x = start.x + u * dx;
			result.y = start.y + u * dy;
			
			return result;
		}
		
		/**
		 * 3D下点到直线垂点坐标 
		 * @param start
		 * @param end
		 * @param target
		 * @return 
		 * 
		 */		
		public function getVerticalPoint3D(start:Vector3D, end:Vector3D, target:Vector3D):Vector3D
		{
			var result:Vector3D;
			
			var dx:Number = start.x - end.x;
			var dy:Number = start.y - end.y;
			var dz:Number = start.z - end.z;
			
			if(Math.abs(dx) < 0.00000001 && Math.abs(dy) < 0.00000001 && Math.abs(dz) < 0.00000001)
			{
				result = start;
				return result;
			}
			
			var u:Number = (target.x - start.x) * (start.x - end.x) + (target.y - start.y) * (start.y - end.y) + (target.z - start.z) * (start.z - end.z);
			u = u / ((dx*dx) + (dy*dy) + (dz*dz));
			
			result.x = start.x + u * dx;
			result.y = start.y + u * dy;
			result.z = start.z + u * dz;
			
			return result;
		}
		
		/**
		 * 2D下获取线段中点 
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public function getMidpoint2D(start:Point, end:Point):Point
		{
			var result:Point;
			
			var dx:Number = (start.x + end.x) / 2;
			var dy:Number = (start.y + end.y) / 2;
			
			result.x = dx;
			result.y = dy;
			
			return result;
		}
		
		/**
		 * 3d下 获取线段中点
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public function getMidpoint3D(start:Vector3D, end:Vector3D):Vector3D
		{
			var result:Vector3D;
			
			var dx:Number = (start.x + end.x) / 2;
			var dy:Number = (start.y + end.y) / 2;
			var dz:Number = (start.z + end.z) / 2;
			
			result.x = dx;
			result.y = dy;
			result.z = dz;
			
			return result;
		}
	
	}
}
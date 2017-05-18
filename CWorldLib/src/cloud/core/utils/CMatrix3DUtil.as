package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class CMatrix3DUtil
	{
		/**
		 * 单位矩阵 
		 */		
		public const matrix3D:Matrix3D=new Matrix3D();
		
		private static var _instance:CMatrix3DUtil;
		public static function get instance():CMatrix3DUtil
		{
			return _instance ||= new CMatrix3DUtil();
		}
		
		public function CMatrix3DUtil()
		{
		}
		
		public function eular2Matrix(v:Vector3D):Matrix3D
		{
			var sx:Number = Math.sin(v.x);
			var sy:Number = Math.sin(v.y);
			var sz:Number = Math.sin(v.z);
			
			var cx:Number = Math.cos(v.x);
			var cy:Number = Math.cos(v.y);
			var cz:Number = Math.cos(v.z);
			
			var m10:Number = sx*sy*cz - cx*sz;
			var m11:Number = sx*sy*sz + cx*cz;
			var m20:Number = cx*sy*cz + sx*sz;
			var m21:Number = cx*sy*sz - sx*cz;
			
			var list:Vector.<Number> = new Vector.<Number>();
			list.push(cy*cz,cy*sz,-sy);
			list.push(0);
			
			list.push(m10, m11,sx*cy);
			list.push(0);
			
			list.push(m20, m21,cx*cy);
			list.push(0);
			
			list.push(0,0,0,1);
			
			return new Matrix3D(list);
		}
	}
}
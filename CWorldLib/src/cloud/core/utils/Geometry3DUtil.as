package cloud.core.utils
{
	import flash.geom.Vector3D;

	/**
	 *  3D网格工具
	 * @author cloud
	 */
	public class Geometry3DUtil
	{
		/**
		 * 射线与平面是否相交，相交则返回交点坐标向量
		 * @param ray	射线
		 * @param planePos	平面上一点
		 * @param planeNormal	平面的法线
		 * @param intersectPos	相交点
		 * @return Boolean 是否相交
		 * 
		 */		
		public static function intersectPlaneByRay(ray:Ray3D,planePos:Vector3D,planeNormal:Vector3D,intersectPos:Vector3D):Boolean
		{
			var tmpVec:Vector3D;
			var rp2cp:Vector3D=planePos.subtract(ray.originPos);
			var normalDir:Vector3D=ray.direction.clone();
			normalDir.normalize();
			var t:Number=planeNormal.dotProduct(rp2cp)/planeNormal.dotProduct(normalDir);
			if(t>=0)
			{
				normalDir.scaleBy(t);
				tmpVec=ray.originPos.add(normalDir);
				intersectPos.copyFrom(tmpVec);
				return true;
			}
			return false;
		}
		
	}
}
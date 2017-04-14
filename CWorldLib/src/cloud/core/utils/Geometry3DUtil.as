package cloud.core.utils
{
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.Transform3D;

	/**
	 *  3D网格工具
	 * @author cloud
	 */
	public class Geometry3DUtil
	{
		private static const VEC:Vector3D=new Vector3D();
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
		/**
		 * 通过Transform3D对象转换Vector3D对象,返回转换后的新Vector3D对象
		 * @param vec
		 * @param transform
		 * @return Vector3D
		 * 
		 */		
		public static function transformVectorByTransform3D(vec:Vector3D,transform:Transform3D,isNew:Boolean=true):Vector3D
		{
			VEC.x=transform.a*vec.x+transform.b*vec.y+transform.c*vec.z+transform.d;
			VEC.y=transform.e*vec.x+transform.f*vec.y+transform.g*vec.z+transform.h;
			VEC.z=transform.i*vec.x+transform.j*vec.y+transform.k*vec.z+transform.l;
			return isNew ? VEC.clone() : VEC;
		}
	}
}
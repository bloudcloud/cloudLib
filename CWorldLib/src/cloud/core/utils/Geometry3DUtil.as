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
		public static const TRANSFORM:Transform3D=new Transform3D();
		public static const INVERSTRANSFORM:Transform3D=new Transform3D();
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
		private static function updateTransForm(x:Number,y:Number,z:Number,rotation:Number):void
		{
			var cosX:Number = 1;
			var sinX:Number = 0;
			var cosY:Number = 1;
			var sinY:Number = 0;
			var cosZ:Number = Math.cos(MathUtil.toDegrees(rotation));
			var sinZ:Number = Math.sin(MathUtil.toDegrees(rotation));
			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			var cosYscaleX:Number = cosY;
			var sinXscaleY:Number = sinX;
			var cosXscaleY:Number = cosX;
			var cosXscaleZ:Number = cosX;
			var sinXscaleZ:Number = sinX;
			TRANSFORM.a = cosZ*cosYscaleX;
			TRANSFORM.b = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			TRANSFORM.c = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			TRANSFORM.d = x;
			TRANSFORM.e = sinZ*cosYscaleX;
			TRANSFORM.f = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			TRANSFORM.g = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			TRANSFORM.h = y;
			TRANSFORM.i = -sinY;
			TRANSFORM.j = cosY*sinXscaleY;
			TRANSFORM.k = cosY*cosXscaleZ;
			TRANSFORM.l = z;
		}
		/**
		 * 线性变换 
		 * @param x	x变换
		 * @param y	y变换
		 * @param z	z变换
		 * @param rotation	旋转变换角度值
		 * @param isNew 是否为创建新的转换后的Vector3D对象
		 * @return Vector3D
		 * 
		 */		
		public static function transformVector(vec:Vector3D,x:Number,y:Number,z:Number,rotation:Number,isNew:Boolean=true):Vector3D
		{
			updateTransForm(x,y,z,rotation);
			return transformVectorByTransform3D(vec,TRANSFORM,isNew);
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
			VEC.w=0;
			return isNew ? VEC.clone() : VEC;
		}

	}
}
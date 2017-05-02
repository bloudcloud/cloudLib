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
		private static var _invalidPosition:Boolean;
		private static var _posX:Number=0;
		private static var _posY:Number=0;
		private static var _posZ:Number=0;
		private static var _rotation:Number=0;
		private static const _TRANSFORM:Transform3D=new Transform3D();
		private static const _INVERSTRANSFORM:Transform3D=new Transform3D();
		
		public static function get INVERSTRANSFORM():Transform3D
		{
			if(_invalidPosition)
			{
				updateTransform();
			}
			return _INVERSTRANSFORM;
		}

		public static function get TRANSFORM():Transform3D
		{
			if(_invalidPosition)
			{
				updateTransform();
			}
			return _TRANSFORM;
		}

		private static function get rotationZ():Number
		{
			return _rotation;
		}

		private static function set rotationZ(value:Number):void
		{
			if(_rotation!=value)
			{
				_rotation = value;
				_invalidPosition=true;
			}
		}

		private static function get posZ():Number
		{
			return _posZ;
		}

		private static function set posZ(value:Number):void
		{
			if(_posZ!=value)
			{
				_posZ = value;
				_invalidPosition=true;
			}
		}

		private static function get posY():Number
		{
			return _posY;
		}

		private static function set posY(value:Number):void
		{
			if(_posY!=value)
			{
				_posY = value;
				_invalidPosition=true;
			}
		}

		private static function get posX():Number
		{
			return _posX;
		}

		private static function set posX(value:Number):void
		{
			if(_posX!=value)
			{
				_posX = value;
				_invalidPosition=true;
			}
		}
		
		private static function updateTransform():void
		{
			_invalidPosition=false;
			var cosX:Number = 1;
			var sinX:Number = 0;
			var cosY:Number = 1;
			var sinY:Number = 0;
			var cosZ:Number = Math.cos(MathUtil.toRadians(rotationZ));
			var sinZ:Number = Math.sin(MathUtil.toRadians(rotationZ));
			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			var cosYscaleX:Number = cosY;
			var sinXscaleY:Number = sinX;
			var cosXscaleY:Number = cosX;
			var cosXscaleZ:Number = cosX;
			var sinXscaleZ:Number = sinX;
			_TRANSFORM.a = cosZ*cosYscaleX;
			_TRANSFORM.b = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			_TRANSFORM.c = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			_TRANSFORM.d = _posX;
			_TRANSFORM.e = sinZ*cosYscaleX;
			_TRANSFORM.f = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			_TRANSFORM.g = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			_TRANSFORM.h = _posY;
			_TRANSFORM.i = -sinY;
			_TRANSFORM.j = cosY*sinXscaleY;
			_TRANSFORM.k = cosY*cosXscaleZ;
			_TRANSFORM.l = _posZ;
			// Inverse matrix
			var sinXsinY:Number = sinX*sinY;
			cosYscaleX = cosY;
			cosXscaleY = cosX;
			sinXscaleZ = -sinX;
			cosXscaleZ = cosX;
			_INVERSTRANSFORM.a = cosZ*cosYscaleX;
			_INVERSTRANSFORM.b = sinZ*cosYscaleX;
			_INVERSTRANSFORM.c = -sinY;
			_INVERSTRANSFORM.d = -_INVERSTRANSFORM.a*_posX - _INVERSTRANSFORM.b*_posY - _INVERSTRANSFORM.c*_posZ;
			_INVERSTRANSFORM.e = sinXsinY*cosZ - sinZ*cosXscaleY;
			_INVERSTRANSFORM.f = cosZ*cosXscaleY + sinXsinY*sinZ;
			_INVERSTRANSFORM.g = sinX*cosY;
			_INVERSTRANSFORM.h = -_INVERSTRANSFORM.e*_posX - _INVERSTRANSFORM.f*_posY - _INVERSTRANSFORM.g*_posZ;
			_INVERSTRANSFORM.i = cosZ*sinY*cosXscaleZ - sinZ*sinXscaleZ;
			_INVERSTRANSFORM.j = cosZ*sinXscaleZ + sinY*sinZ*cosXscaleZ;
			_INVERSTRANSFORM.k = cosY*cosXscaleZ;
			_INVERSTRANSFORM.l = -_INVERSTRANSFORM.i*_posX - _INVERSTRANSFORM.j*_posY - _INVERSTRANSFORM.k*_posZ;
		}
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
			posX=x;
			posY=y;
			posZ=z;
			rotationZ=rotation;
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
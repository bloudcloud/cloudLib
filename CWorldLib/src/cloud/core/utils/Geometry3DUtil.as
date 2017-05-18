package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import cloud.core.dataStruct.CTransform3D;

	/**
	 *  3D网格工具
	 * @author cloud
	 */
	public class Geometry3DUtil
	{
		private static var _instance:Geometry3DUtil;
		
		public static function get instance():Geometry3DUtil
		{
			return _instance ||= new Geometry3DUtil(new SingletonEnforce());
		}
		
		private const _vector3d:Vector3D=new Vector3D();
		private const _matrix3d:Matrix3D=new Matrix3D();
		private const _transform3d:CTransform3D=new CTransform3D();
		private const _inverseTransform3d:CTransform3D=new CTransform3D();
		
		private var _invalidPosition:Boolean;
		private var _posX:Number=0;
		private var _posY:Number=0;
		private var _posZ:Number=0;
		private var _rotationX:Number=0;
		private var _rotationY:Number=0;
		private var _rotationZ:Number=0;
		private var _scaleX:Number=1;
		private var _scaleY:Number=1;
		private var _scaleZ:Number=1;
		
		private function get inverseTransform3d():CTransform3D
		{
			if(_invalidPosition)
			{
				updateTransform();
			}
			return _inverseTransform3d;
		}
		private function get transform3d():CTransform3D
		{
			if(_invalidPosition)
			{
				updateTransform();
			}
			return _transform3d;
		}
		private function get scaleX():Number
		{
			return _scaleX;
		}
		private function set scaleX(value:Number):void
		{
			if(_scaleX!=value)
			{
				_scaleX = value;
				_invalidPosition=true;
			}
		}
		private function get scaleY():Number
		{
			return _scaleY;
		}
		private function set scaleY(value:Number):void
		{
			if(_scaleY!=value)
			{
				_scaleY = value;
				_invalidPosition=true;
			}
		}
		private function get scaleZ():Number
		{
			return _scaleZ;
		}
		private function set scaleZ(value:Number):void
		{
			if(_scaleZ!=value)
			{
				_scaleZ = value;
				_invalidPosition=true;
			}
		}
		private function get rotationX():Number
		{
			return _rotationX;
		}
		private function set rotationX(value:Number):void
		{
			if(_rotationX!=value)
			{
				_rotationX = value;
				_invalidPosition=true;
			}
		}
		private function get rotationY():Number
		{
			return _rotationY;
		}
		private function set rotationY(value:Number):void
		{
			if(_rotationY!=value)
			{
				_rotationY = value;
				_invalidPosition=true;
			}
		}
		private function get rotationZ():Number
		{
			return _rotationZ;
		}
		private function set rotationZ(value:Number):void
		{
			if(_rotationZ!=value)
			{
				_rotationZ = value;
				_invalidPosition=true;
			}
		}
		private function get posZ():Number
		{
			return _posZ;
		}
		private function set posZ(value:Number):void
		{
			if(_posZ!=value)
			{
				_posZ = value;
				_invalidPosition=true;
			}
		}
		private function get posY():Number
		{
			return _posY;
		}
		private function set posY(value:Number):void
		{
			if(_posY!=value)
			{
				_posY = value;
				_invalidPosition=true;
			}
		}
		private function get posX():Number
		{
			return _posX;
		}
		private function set posX(value:Number):void
		{
			if(_posX!=value)
			{
				_posX = value;
				_invalidPosition=true;
			}
		}
		
		public function Geometry3DUtil(enforcer:SingletonEnforce)
		{
		}
		private function updateTransform():void
		{
			_invalidPosition=false;
			var cosX:Number = Math.cos(MathUtil.instance.toRadians(_rotationX));
			var sinX:Number = Math.sin(MathUtil.instance.toRadians(_rotationX));
			var cosY:Number = Math.cos(MathUtil.instance.toRadians(_rotationY));
			var sinY:Number = Math.sin(MathUtil.instance.toRadians(_rotationY));
			var cosZ:Number = Math.cos(MathUtil.instance.toRadians(_rotationZ));
			var sinZ:Number = Math.sin(MathUtil.instance.toRadians(_rotationZ));
			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			var cosYscaleX:Number = cosY*_scaleX;
			var sinXscaleY:Number = sinX*_scaleY;
			var cosXscaleY:Number = cosX*_scaleY;
			var cosXscaleZ:Number = cosX*_scaleZ;
			var sinXscaleZ:Number = sinX*_scaleZ;
			transform3d.a = cosZ*cosYscaleX;
			transform3d.b = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			transform3d.c = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			transform3d.d = _posX;
			transform3d.e = sinZ*cosYscaleX;
			transform3d.f = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			transform3d.g = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			transform3d.h = _posY;
			transform3d.i = -sinY*_scaleX;
			transform3d.j = cosY*sinXscaleY;
			transform3d.k = cosY*cosXscaleZ;
			transform3d.l = _posZ;
			// Inverse
			var sinXsinY:Number = sinX*sinY;
			cosYscaleX = cosY/_scaleX;
			cosXscaleY = cosX/_scaleY;
			sinXscaleZ = -sinX/_scaleZ;
			cosXscaleZ = cosX/_scaleZ;
			inverseTransform3d.a = cosZ*cosYscaleX;
			inverseTransform3d.b = sinZ*cosYscaleX;
			inverseTransform3d.c = -sinY/_scaleX;
			inverseTransform3d.d = -inverseTransform3d.a*_posX - inverseTransform3d.b*_posY - inverseTransform3d.c*_posZ;
			inverseTransform3d.e = sinXsinY*cosZ/_scaleY - sinZ*cosXscaleY;
			inverseTransform3d.f = cosZ*cosXscaleY + sinXsinY*sinZ/_scaleY;
			inverseTransform3d.g = sinX*cosY/_scaleY;
			inverseTransform3d.h = -inverseTransform3d.e*_posX - inverseTransform3d.f*_posY - inverseTransform3d.g*_posZ;
			inverseTransform3d.i = cosZ*sinY*cosXscaleZ - sinZ*sinXscaleZ;
			inverseTransform3d.j = cosZ*sinXscaleZ + sinY*sinZ*cosXscaleZ;
			inverseTransform3d.k = cosY*cosXscaleZ;
			inverseTransform3d.l = -inverseTransform3d.i*_posX - inverseTransform3d.j*_posY - inverseTransform3d.k*_posZ;
		}
		/**
		 * 生成Tansform3D对象 
		 * @param px
		 * @param py
		 * @param pz
		 * @param rx
		 * @param ry
		 * @param rz
		 * @param sx
		 * @param sy
		 * @param sz
		 * @param isNew 是否新创建一个CTransform3D对象
		 * @return CTransform3D
		 * 
		 */		
		public function composeTransform(px:Number=0,py:Number=0,pz:Number=0,rx:Number=0,ry:Number=0,rz:Number=0,sx:Number=1,sy:Number=1,sz:Number=1,isNew:Boolean=false):CTransform3D
		{
			posX=px;
			posY=py;
			posZ=pz;
			rotationX=rx;
			rotationY=ry;
			rotationZ=rz;
			scaleX=sx;
			scaleY=sy;
			scaleZ=sz;
			var tmp:CTransform3D=transform3d;
			if(isNew)
			{
				tmp=new CTransform3D();
				tmp.copy(_transform3d);
			}
			return tmp;
		}
		/**
		 * 生成逆转换的Tansform3D对象 
		 * @param px
		 * @param py
		 * @param pz
		 * @param rx
		 * @param ry
		 * @param rz
		 * @param sx
		 * @param sy
		 * @param sz
		 * @param isNew 是否新创建一个CTransform3D对象
		 * @return CTransform3D
		 * 
		 */		
		public function composeInverseTransform(px:Number=0,py:Number=0,pz:Number=0,rx:Number=0,ry:Number=0,rz:Number=0,sx:Number=1,sy:Number=1,sz:Number=1,isNew:Boolean=false):CTransform3D
		{
			posX=px;
			posY=py;
			posZ=pz;
			rotationX=rx;
			rotationY=ry;
			rotationZ=rz;
			scaleX=sx;
			scaleY=sy;
			scaleZ=sz;
			var tmp:CTransform3D=inverseTransform3d;
			if(isNew)
			{
				tmp=new CTransform3D();
				tmp.copy(_inverseTransform3d);
			}
			return tmp;
		}
		/**
		 * CTransform3D对象转换成Matrix3D对象 
		 * @param transform3d
		 * @return Matrix3D
		 * 
		 */		
		public function getMatrix3DByTransform3D(transform3d:CTransform3D,isNew:Boolean=false):Matrix3D
		{
			var vector3d:Vector.<Number>=Vector.<Number>([transform3d.a, transform3d.e, transform3d.i, 0, transform3d.b, transform3d.f, transform3d.j, 0, transform3d.c, transform3d.g, transform3d.k, 0, transform3d.d, transform3d.h, transform3d.l, 1]);
			if(isNew)
			{
				return new Matrix3D(vector3d);
			}
			_matrix3d.copyRawDataFrom(vector3d);
			return _matrix3d;
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
		public function intersectPlaneByRay(ray:Ray3D,planePos:Vector3D,planeNormal:Vector3D,intersectPos:Vector3D):Boolean
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
		public function transformVector(vec:Vector3D,x:Number,y:Number,z:Number,rotation:Number,isNew:Boolean=true):Vector3D
		{
			posX=x;
			posY=y;
			posZ=z;
			rotationZ=rotation;
			return transformVectorByCTransform3D(vec,transform3d,isNew);
		}
		/**
		 * 通过CTransform3D对象转换Vector3D对象,返回转换后的新Vector3D对象
		 * @param vec
		 * @param transform
		 * @return Vector3D
		 * 
		 */		
		public function transformVectorByCTransform3D(vec:Vector3D,transform:CTransform3D,isNew:Boolean=true):Vector3D
		{
			_vector3d.x=transform.a*vec.x+transform.b*vec.y+transform.c*vec.z+transform.d;
			_vector3d.y=transform.e*vec.x+transform.f*vec.y+transform.g*vec.z+transform.h;
			_vector3d.z=transform.i*vec.x+transform.j*vec.y+transform.k*vec.z+transform.l;
			_vector3d.w=0;
			return isNew ? _vector3d.clone() : _vector3d;
		}

	}
}
class SingletonEnforce{}
package cloud.core.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import cloud.core.data.CTransform3D;
	import cloud.core.data.CVector;

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
		
		private const _vector3d:CVector=new CVector();
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
				_invalidPosition=false;
				updateTransform();
			}
			return _inverseTransform3d;
		}
		private function get transform3d():CTransform3D
		{
			if(_invalidPosition)
			{
				_invalidPosition=false;
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
			var cosX:Number = Math.cos(CMathUtil.instance.toRadians(_rotationX));
			var sinX:Number = Math.sin(CMathUtil.instance.toRadians(_rotationX));
			var cosY:Number = Math.cos(CMathUtil.instance.toRadians(_rotationY));
			var sinY:Number = Math.sin(CMathUtil.instance.toRadians(_rotationY));
			var cosZ:Number = Math.cos(CMathUtil.instance.toRadians(_rotationZ));
			var sinZ:Number = Math.sin(CMathUtil.instance.toRadians(_rotationZ));
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
		 * @param rx	绕x轴方向的角度
		 * @param ry	绕y轴方向的角度
		 * @param rz	绕z轴方向的角度
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
			return isNew ? transform3d.clone() as CTransform3D : transform3d;
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
			return isNew ? inverseTransform3d.clone() as CTransform3D : inverseTransform3d;
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
		public function intersectPlaneByRay(ray:Ray3D,planePos:CVector,planeNormal:CVector,intersectPos:CVector):Boolean
		{
			var tmpVec:Vector3D;
			var rp2cp:CVector=CVector.Substract(planePos,ray.originPos);
			var normalDir:CVector=ray.direction.clone() as CVector;
			CVector.Normalize(normalDir);
			var t:Number=CVector.DotValue(planeNormal,rp2cp)/CVector.DotValue(planeNormal,normalDir);
			if(t>=0)
			{
				CVector.Scale(normalDir,t);
				CVector.SetTo(intersectPos,ray.originPos.x+normalDir.x,ray.originPos.y+normalDir.y,ray.originPos.z+normalDir.z);
			}
			rp2cp.back();
			normalDir.back();
			return t>=0;
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
		public function transformVector(vec:CVector,x:Number,y:Number,z:Number,rotation:Number,isNew:Boolean=true):CVector
		{
			posX=x;
			posY=y;
			posZ=z;
			rotationZ=rotation;
			return transformVectorByCTransform3D(vec,transform3d,isNew);
		}
		/**
		 * 通过CTransform3D对象转换3D向量对象 
		 * @param vec	3D向量对象
		 * @param transform	线性变换对象（3*4矩阵）
		 * @param isNew	是否返回一个新的3D向量对象
		 * @return *
		 * 
		 */		
		public function transformVectorByCTransform3D(vec:*,transform:CTransform3D,isNew:Boolean=true):*
		{
			var newVec:*=isNew ? vec.clone() : vec;
			var x:Number=vec.x;
			var y:Number=vec.y;
			var z:Number=vec.z;
			newVec.x=transform.a*x+transform.b*y+transform.c*z+transform.d;
			newVec.y=transform.e*x+transform.f*y+transform.g*z+transform.h;
			newVec.z=transform.i*x+transform.j*y+transform.k*z+transform.l;
			return newVec;
		}

	}
}
class SingletonEnforce{}
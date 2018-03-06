package cloud.core.datas.base
{
	import cloud.core.datas.pool.ICObjectPool;
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CPoolsManager;

	/**
	 * 自定义3D转换类(3*4矩阵)
	 * @author cloud
	 */
	public class CTransform3D implements ICPoolObject
	{
		private static var _Pool:ICObjectPool;
		
		private var _isInPool:Boolean;
		
		public var a:Number = 1;
		public var b:Number = 0;
		public var c:Number = 0;
		public var d:Number = 0;
		
		public var e:Number = 0;
		public var f:Number = 1;
		public var g:Number = 0;
		public var h:Number = 0;
		
		public var i:Number = 0;
		public var j:Number = 0;
		public var k:Number = 1;
		public var l:Number = 0;
		
		public function get isInPool():Boolean
		{
			return _isInPool;
		}
		public function CTransform3D()
		{
			initObject();
		}
		public function toString():String {
			return "[CTransform3D" +
				" a:" + a.toFixed(3) + " b:" + b.toFixed(3) + " c:" + a.toFixed(3) + " d:" + d.toFixed(3) +
				" e:" + e.toFixed(3) + " f:" + f.toFixed(3) + " g:" + a.toFixed(3) + " h:" + h.toFixed(3) +
				" i:" + i.toFixed(3) + " j:" + j.toFixed(3) + " k:" + a.toFixed(3) + " l:" + l.toFixed(3) + "]";
		}
		/**
		 * 完全复制一个向量 
		 * @return CVector
		 * 
		 */		
		public function clone():ICPoolObject
		{
			var clone:CTransform3D=CreateOneInstance();
			CTransform3D.Copy(clone,this);
			return clone;
		}
		public function back():void
		{
			_isInPool=true;
			if(_Pool!=null)
				_Pool.push(this);
		}
		public function initObject(...params):void
		{
			a=1,b=0,c=0,d=0;
			e=0,f=1,g=0,h=0;
			i=0,j=0,k=1,l=0;
			_isInPool=false;
		}
		public function dispose():void
		{
			_Pool=null;
		}
		/**
		 * 设置是否使用缓冲池 
		 * @param value
		 * 
		 */			
		public static function set IsUsePool(value:Boolean):void
		{
			if(value && _Pool==null)
			{
				CPoolsManager.Instance.registPool(CTransform3D,50);
				_Pool=CPoolsManager.Instance.getPool(CTransform3D);
			}
			else if(!value && _Pool!=null)
			{
				CPoolsManager.Instance.unRegistPool(CTransform3D);
				_Pool=null;
			}
			
		}
		/**
		 * 创建一个实例 
		 * @return CVector
		 * 
		 */		
		public static function CreateOneInstance():CTransform3D
		{
			return _Pool==null ? new CTransform3D() : _Pool.pop() as CTransform3D;
		}
		/**
		 * 单位化 
		 * @param transform
		 * 
		 */		
		public static function Identity(transform:CTransform3D):void 
		{
			transform.a = 1;
			transform.b = 0;
			transform.c = 0;
			transform.d = 0;
			transform.e = 0;
			transform.f = 1;
			transform.g = 0;
			transform.h = 0;
			transform.i = 0;
			transform.j = 0;
			transform.k = 1;
			transform.l = 0;
		}
		/**
		 * 更新transForm 
		 * @param x
		 * @param y
		 * @param z
		 * @param rotationX
		 * @param rotationY
		 * @param rotationZ
		 * @param scaleX
		 * @param scaleY
		 * @param scaleZ
		 * 
		 */		
		public static function Compose(transform:CTransform3D,rotationX:Number=0,rotationY:Number=0,rotationZ:Number=0,scaleX:Number=1,scaleY:Number=1,scaleZ:Number=1,x:Number=0,y:Number=0,z:Number=0,isDegree:Boolean=true):void {
			var rotaX:Number=isDegree?CMathUtil.Instance.toRadians(rotationX):rotationX;
			var rotaY:Number=isDegree?CMathUtil.Instance.toRadians(rotationY):rotationY;
			var rotaZ:Number=isDegree?CMathUtil.Instance.toRadians(rotationZ):rotationZ;
			var cosX:Number = Math.cos(rotaX);
			var sinX:Number = Math.sin(rotaX);
			var cosY:Number = Math.cos(rotaY);
			var sinY:Number = Math.sin(rotaY);
			var cosZ:Number = Math.cos(rotaZ);
			var sinZ:Number = Math.sin(rotaZ);
			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			var cosYscaleX:Number = cosY*scaleX;
			var sinXscaleY:Number = sinX*scaleY;
			var cosXscaleY:Number = cosX*scaleY;
			var cosXscaleZ:Number = cosX*scaleZ;
			var sinXscaleZ:Number = sinX*scaleZ;
			transform.a = cosZ*cosYscaleX;
			transform.b = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			transform.c = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			transform.d = x;
			transform.e = sinZ*cosYscaleX;
			transform.f = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			transform.g = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			transform.h = y;
			transform.i = -sinY*scaleX;
			transform.j = cosY*sinXscaleY;
			transform.k = cosY*cosXscaleZ;
			transform.l = z;
		}
		
		public static function ComposeInverse(transform:CTransform3D,rotationX:Number=0,rotationY:Number=0,rotationZ:Number=0,scaleX:Number=1,scaleY:Number=1,scaleZ:Number=1,x:Number=0,y:Number=0,z:Number=0,isDegree:Boolean=true):void {
			var rotaX:Number=isDegree?CMathUtil.Instance.toRadians(rotationX):rotationX;
			var rotaY:Number=isDegree?CMathUtil.Instance.toRadians(rotationY):rotationY;
			var rotaZ:Number=isDegree?CMathUtil.Instance.toRadians(rotationZ):rotationZ;
			var cosX:Number = Math.cos(rotaX);
			var sinX:Number = Math.sin(-rotaX);
			var cosY:Number = Math.cos(rotaY);
			var sinY:Number = Math.sin(-rotaY);
			var cosZ:Number = Math.cos(rotaZ);
			var sinZ:Number = Math.sin(-rotaZ);
			var sinXsinY:Number = sinX*sinY;
			var cosYscaleX:Number = cosY/scaleX;
			var cosXscaleY:Number = cosX/scaleY;
			var sinXscaleZ:Number = sinX/scaleZ;
			var cosXscaleZ:Number = cosX/scaleZ;
			transform.a = cosZ*cosYscaleX;
			transform.b = -sinZ*cosYscaleX;
			transform.c = sinY/scaleX;
			transform.d = -transform.a*x - transform.b*y - transform.c*z;
			transform.e = sinZ*cosXscaleY + sinXsinY*cosZ/scaleY;
			transform.f = cosZ*cosXscaleY - sinXsinY*sinZ/scaleY;
			transform.g = -sinX*cosY/scaleY;
			transform.h = -transform.e*x - transform.f*y - transform.g*z;
			transform.i = sinZ*sinXscaleZ - cosZ*sinY*cosXscaleZ;
			transform.j = cosZ*sinXscaleZ + sinY*sinZ*cosXscaleZ;
			transform.k = cosY*cosXscaleZ;
			transform.l = -transform.i*x - transform.j*y - transform.k*z;
		}
		/**
		 * 逆转transform 
		 * @param transform
		 * 
		 */		
		public static function Invert(transform:CTransform3D):void {
			var ta:Number = transform.a;
			var tb:Number = transform.b;
			var tc:Number = transform.c;
			var td:Number = transform.d;
			var te:Number = transform.e;
			var tf:Number = transform.f;
			var tg:Number = transform.g;
			var th:Number = transform.h;
			var ti:Number = transform.i;
			var tj:Number = transform.j;
			var tk:Number = transform.k;
			var tl:Number = transform.l;
			var det:Number = 1/(-tc*tf*ti + tb*tg*ti + tc*te*tj - ta*tg*tj - tb*te*tk + ta*tf*tk);
			transform.a = (-tg*tj + tf*tk)*det;
			transform.b = (tc*tj - tb*tk)*det;
			transform.c = (-tc*tf + tb*tg)*det;
			transform.d = (td*tg*tj - tc*th*tj - td*tf*tk + tb*th*tk + tc*tf*tl - tb*tg*tl)*det;
			transform.e = (tg*ti - te*tk)*det;
			transform.f = (-tc*ti + ta*tk)*det;
			transform.g = (tc*te - ta*tg)*det;
			transform.h = (tc*th*ti - td*tg*ti + td*te*tk - ta*th*tk - tc*te*tl + ta*tg*tl)*det;
			transform.i = (-tf*ti + te*tj)*det;
			transform.j = (tb*ti - ta*tj)*det;
			transform.k = (-tb*te + ta*tf)*det;
			transform.l = (td*tf*ti - tb*th*ti - td*te*tj + ta*th*tj + tb*te*tl - ta*tf*tl)*det;
		}
		
		public static function InitFromVector(transform:CTransform3D,vector:Vector.<Number>):void {
			transform.a = vector[0];
			transform.b = vector[1];
			transform.c = vector[2];
			transform.d = vector[3];
			transform.e = vector[4];
			transform.f = vector[5];
			transform.g = vector[6];
			transform.h = vector[7];
			transform.i = vector[8];
			transform.j = vector[9];
			transform.k = vector[10];
			transform.l = vector[11];
		}
		/**
		 * A转换左乘B转换,将结果更新到A转换对象上
		 * @param transformA
		 * @param transformB
		 * 
		 */		
		public static function Append(transformA:CTransform3D,transformB:CTransform3D):void {
			var ta:Number = transformA.a;
			var tb:Number = transformA.b;
			var tc:Number = transformA.c;
			var td:Number = transformA.d;
			var te:Number = transformA.e;
			var tf:Number = transformA.f;
			var tg:Number = transformA.g;
			var th:Number = transformA.h;
			var ti:Number = transformA.i;
			var tj:Number = transformA.j;
			var tk:Number = transformA.k;
			var tl:Number = transformA.l;
			transformA.a = transformB.a*ta + transformB.b*te + transformB.c*ti;
			transformA.b = transformB.a*tb + transformB.b*tf + transformB.c*tj;
			transformA.c = transformB.a*tc + transformB.b*tg + transformB.c*tk;
			transformA.d = transformB.a*td + transformB.b*th + transformB.c*tl + transformB.d;
			transformA.e = transformB.e*ta + transformB.f*te + transformB.g*ti;
			transformA.f = transformB.e*tb + transformB.f*tf + transformB.g*tj;
			transformA.g = transformB.e*tc + transformB.f*tg + transformB.g*tk;
			transformA.h = transformB.e*td + transformB.f*th + transformB.g*tl + transformB.h;
			transformA.i = transformB.i*ta + transformB.j*te + transformB.k*ti;
			transformA.j = transformB.i*tb + transformB.j*tf + transformB.k*tj;
			transformA.k = transformB.i*tc + transformB.j*tg + transformB.k*tk;
			transformA.l = transformB.i*td + transformB.j*th + transformB.k*tl + transformB.l;
		}
		/**
		 *  A转换右乘B转换，将结果更新到A转换对象上
		 * @param transformA
		 * @param transformB
		 * 
		 */		
		public static function Prepend(transformA:CTransform3D,transformB:CTransform3D):void {
			var ta:Number = transformA.a;
			var tb:Number = transformA.b;
			var tc:Number = transformA.c;
			var td:Number = transformA.d;
			var te:Number = transformA.e;
			var tf:Number = transformA.f;
			var tg:Number = transformA.g;
			var th:Number = transformA.h;
			var ti:Number = transformA.i;
			var tj:Number = transformA.j;
			var tk:Number = transformA.k;
			var tl:Number = transformA.l;
			transformA.a = ta*transformB.a + tb*transformB.e + tc*transformB.i;
			transformA.b = ta*transformB.b + tb*transformB.f + tc*transformB.j;
			transformA.c = ta*transformB.c + tb*transformB.g + tc*transformB.k;
			transformA.d = ta*transformB.d + tb*transformB.h + tc*transformB.l + td;
			transformA.e = te*transformB.a + tf*transformB.e + tg*transformB.i;
			transformA.f = te*transformB.b + tf*transformB.f + tg*transformB.j;
			transformA.g = te*transformB.c + tf*transformB.g + tg*transformB.k;
			transformA.h = te*transformB.d + tf*transformB.h + tg*transformB.l + th;
			transformA.i = ti*transformB.a + tj*transformB.e + tk*transformB.i;
			transformA.j = ti*transformB.b + tj*transformB.f + tk*transformB.j;
			transformA.k = ti*transformB.c + tj*transformB.g + tk*transformB.k;
			transformA.l = ti*transformB.d + tj*transformB.h + tk*transformB.l + tl;
			
		}
		/**
		 *  将A左乘B转换的结果，更新到tansfrom对象上
		 * @param transformA
		 * @param transformB
		 * 
		 */		
		public static function Combine(transform:CTransform3D,transformA:CTransform3D, transformB:CTransform3D):void {
			transform.a = transformA.a*transformB.a + transformA.b*transformB.e + transformA.c*transformB.i;
			transform.b = transformA.a*transformB.b + transformA.b*transformB.f + transformA.c*transformB.j;
			transform.c = transformA.a*transformB.c + transformA.b*transformB.g + transformA.c*transformB.k;
			transform.d = transformA.a*transformB.d + transformA.b*transformB.h + transformA.c*transformB.l + transformA.d;
			transform.e = transformA.e*transformB.a + transformA.f*transformB.e + transformA.g*transformB.i;
			transform.f = transformA.e*transformB.b + transformA.f*transformB.f + transformA.g*transformB.j;
			transform.g = transformA.e*transformB.c + transformA.f*transformB.g + transformA.g*transformB.k;
			transform.h = transformA.e*transformB.d + transformA.f*transformB.h + transformA.g*transformB.l + transformA.h;
			transform.i = transformA.i*transformB.a + transformA.j*transformB.e + transformA.k*transformB.i;
			transform.j = transformA.i*transformB.b + transformA.j*transformB.f + transformA.k*transformB.j;
			transform.k = transformA.i*transformB.c + transformA.j*transformB.g + transformA.k*transformB.k;
			transform.l = transformA.i*transformB.d + transformA.j*transformB.h + transformA.k*transformB.l + transformA.l;
		}
		/**
		 * 计算source转换的逆变换，将结果更新到tansform上 
		 * @param transform
		 * @param source
		 * 
		 */		
		public static function CalculateInversion(transform:CTransform3D,source:CTransform3D):void {
			var ta:Number = source.a;
			var tb:Number = source.b;
			var tc:Number = source.c;
			var td:Number = source.d;
			var te:Number = source.e;
			var tf:Number = source.f;
			var tg:Number = source.g;
			var th:Number = source.h;
			var ti:Number = source.i;
			var tj:Number = source.j;
			var tk:Number = source.k;
			var tl:Number = source.l;
			var det:Number = 1/(-tc*tf*ti + tb*tg*ti + tc*te*tj - ta*tg*tj - tb*te*tk + ta*tf*tk);
			transform.a = (-tg*tj + tf*tk)*det;
			transform.b = (tc*tj - tb*tk)*det;
			transform.c = (-tc*tf + tb*tg)*det;
			transform.d = (td*tg*tj - tc*th*tj - td*tf*tk + tb*th*tk + tc*tf*tl - tb*tg*tl)*det;
			transform.e = (tg*ti - te*tk)*det;
			transform.f = (-tc*ti + ta*tk)*det;
			transform.g = (tc*te - ta*tg)*det;
			transform.h = (tc*th*ti - td*tg*ti + td*te*tk - ta*th*tk - tc*te*tl + ta*tg*tl)*det;
			transform.i = (-tf*ti + te*tj)*det;
			transform.j = (tb*ti - ta*tj)*det;
			transform.k = (-tb*te + ta*tf)*det;
			transform.l = (td*tf*ti - tb*th*ti - td*te*tj + ta*th*tj + tb*te*tl - ta*tf*tl)*det;
		}
		/**
		 *	将source转换的值拷贝到tansfrom上 
		 * @param transform
		 * @param source
		 * 
		 */		
		public static function Copy(transform:CTransform3D,source:CTransform3D):void {
			transform.a = source.a;
			transform.b = source.b;
			transform.c = source.c;
			transform.d = source.d;
			transform.e = source.e;
			transform.f = source.f;
			transform.g = source.g;
			transform.h = source.h;
			transform.i = source.i;
			transform.j = source.j;
			transform.k = source.k;
			transform.l = source.l;
		}
	}
}
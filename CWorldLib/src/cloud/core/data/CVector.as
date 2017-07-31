package cloud.core.data
{
	import cloud.core.data.pool.ICObjectPool;
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.singleton.CPoolsManager;

	/**
	 * 自定义向量类
	 * @author cloud
	 */
	public class CVector implements ICPoolObject
	{
		private static var _Pool:ICObjectPool;
		
		public static const ZERO:CVector=new CVector();
		public static const X_AXIS:CVector=new CVector(1,0,0,0);
		public static const Y_AXIS:CVector=new CVector(0,1,0,0);
		public static const Z_AXIS:CVector=new CVector(0,0,1,0);
		public static const NEG_X_AXIS:CVector=new CVector(-1,0,0,0);
		public static const NEG_Y_AXIS:CVector=new CVector(0,-1,0,0);
		public static const NEG_Z_AXIS:CVector=new CVector(0,0,-1,0);
//		/**
//		 * 3D向量模式 
//		 */		
//		public static const MODE_VECTOR3D:uint = 0;
//		/**
//		 * 2D向量模式 
//		 */		
//		public static const MODE_VECTOR2D:uint = 1;
//		/**
//		 * 四元数模式 
//		 */		
//		public static const MODE_QUATERNION:uint = 2;
		
		private var _invalidPosition:Boolean;
		private var _isInPool:Boolean;
//		private var _mode:uint;
		
		protected var _x:Number;
		protected var _y:Number;
		protected var _z:Number;
		protected var _w:Number;
		protected var _length:Number;
		
		public function get isInPool():Boolean
		{
			return _isInPool;
		}
//		/**
//		 * 获取对象当前使用的模式 
//		 * @return uint
//		 * 
//		 */
//		public function get mode():uint
//		{
//			return _mode;
//		}
//		/**
//		 * 设置对象当前使用的模式 
//		 * @param value
//		 * 
//		 */		
//		public function set mode(value:uint):void
//		{
//			value=_mode;
//		}
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x!=value) _invalidPosition=true;
			_x=value;
		}
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y!=value) _invalidPosition=true;
			_y=value;
		}
		public function get z():Number
		{
			return _z;
		}
		public function set z(value:Number):void
		{
			if(_z!=value) _invalidPosition=true;
			_z=value;
		}
		public function get w():Number
		{
			return _w;
		}
		public function set w(value:Number):void
		{
			_w=value;
		}
		public function get length():Number
		{
			if(_invalidPosition)
			{
				_invalidPosition=false;
				_length=Math.sqrt(_x*_x+_y*_y+_z*_z);
			}
			return _length;
		}
		public function get lengthSquared():Number
		{
			return length*length;
		}
		public function CVector(x:Number=0,y:Number=0,z:Number=0,w:Number=0)
		{
			initObject(x,y,z,w);
		}
		public function toString():String
		{
			return "CVector:"+" x:"+x+" y:"+y+" z:"+z+" w:"+w+"\n";
		}
		/**
		 * 完全复制一个向量 
		 * @return CVector
		 * 
		 */		
		public function clone():ICPoolObject
		{
			var clone:CVector=CreateOneInstance();
			CVector.Copy(clone,this);
			return clone;
		}
		public function back():void
		{
			_isInPool=true;
			_x=_y=_z=_w=0;
			if(_Pool!=null)
				_Pool.push(this);
		}
		public function initObject(...params):void
		{
			if(params!=null && params.length>0)
			{
				_x=params[0];
				_y=params[1];
				_z=params[2];
				_w=params[3];
			}
			else
			{
				_x=_y=_z=_w=0;
			}
			_invalidPosition=true;
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
				CPoolsManager.Instance.registPool(CVector,50);
				_Pool=CPoolsManager.Instance.getPool(CVector);
			}
			else if(!value && _Pool!=null)
			{
				CPoolsManager.Instance.unRegistPool(CVector);
				_Pool=null;
			}
				
		}
		/**
		 * 创建一个实例  
		 * @param mode
		 * @return CVector
		 * 
		 */			
		public static function CreateOneInstance(mode:uint=0):CVector
		{
			var vec:CVector=_Pool==null ? new CVector() : _Pool.pop() as CVector;
//			vec.mode=mode;
			return vec;
		}
		/**
		 *  两个向量点之间的直线距离
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return Number
		 * 
		 */		
		public static function Distance(vecA:CVector,vecB:CVector):Number
		{
			return Math.sqrt((vecA.x-vecB.x)*(vecA.x-vecB.x)+(vecA.y-vecB.y)*(vecA.y-vecB.y)+(vecA.z-vecB.z)*(vecA.z-vecB.z));
		}
		/**
		 * 单位化向量 
		 * @param vec	向量对象
		 * @param isNew	是否返回一个新的向量
		 * @return CVector
		 * 
		 */		
		public static function Normalize(vec:CVector,isNew:Boolean=false):CVector
		{
			var length:Number=vec.length;
			var result:CVector=isNew?vec.clone() as CVector:vec;
			result.x/=length
			result.y/=length;
			result.z/=length;
			return result;
		}
		/**
		 * 将向量逆变换 
		 * @param vec
		 * @param isNew
		 * @return CVector
		 * 
		 */		
		public static function Negate(vec:CVector,isNew:Boolean=false):CVector
		{
			var result:CVector=isNew?vec.clone() as CVector:vec;
			result.x=-vec.x;
			result.y=-vec.y;
			result.z=-vec.z;
			return result;
		}
		/**
		 * 将一个向量缩放 
		 * @param vec	向量对象
		 * @param value	缩放值
		 * @param isNew	是否返回一个新的向量
		 * @return CVector
		 * 
		 */		
		public static function Scale(vec:CVector,value:Number,isNew:Boolean=false):CVector
		{
			var result:CVector=isNew?vec.clone() as CVector:vec;
			result.x*=value;
			result.y*=value;
			result.z*=value;
			return result;
		}
		/**
		 * A向量减B向量，返回一个新的向量
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return CVector
		 * 
		 */		
		public static function Substract(vecA:CVector,vecB:CVector):CVector
		{
			var tmpVec:CVector=CreateOneInstance();
			tmpVec.x=vecA.x-vecB.x;
			tmpVec.y=vecA.y-vecB.y;
			tmpVec.z=vecA.z-vecB.z;
			return tmpVec;
		}
		/**
		 * A向量减B向量，改变A的值
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * 
		 */		
		public static function Decrease(vecA:CVector,vecB:CVector):void
		{
			vecA.x-=vecB.x;
			vecA.y-=vecB.y;
			vecA.z-=vecB.z;
		}
		/**
		 * A向量加B向量，返回一个新的向量
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return CVector
		 * 
		 */		
		public static function Add(vecA:CVector,vecB:CVector):CVector
		{
			var tmpVec:CVector=CreateOneInstance();
			tmpVec.x=vecA.x+vecB.x;
			tmpVec.y=vecA.y+vecB.y;
			tmpVec.z=vecA.z+vecB.z;
			return tmpVec;
		}
		/**
		 * A向量加B向量，改变A向量的值 
		 * @param vecA
		 * @param vecB
		 * 
		 */		
		public static function Increase(vecA:CVector,vecB:CVector):void
		{
			vecA.x+=vecB.x;
			vecA.y+=vecB.y;
			vecA.z+=vecB.z;
		}
		/**
		 * A向量与B向量的叉乘，返回一个新的结果向量
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return CVector
		 * 
		 */		
		public static function CrossValue(vecA:CVector,vecB:CVector):CVector
		{
			var tmpVec:CVector=CreateOneInstance();
			tmpVec.x=vecA.y*vecB.z-vecA.z*vecB.y;
			tmpVec.y=vecA.z*vecB.x-vecA.x*vecB.z;
			tmpVec.z=vecA.x*vecB.y-vecA.y*vecB.x;
			return tmpVec;
		}
		/**
		 * A向量与B向量的点积 
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return Number
		 * 
		 */		
		public static function DotValue(vecA:CVector,vecB:CVector):Number
		{
			return vecA.x*vecB.x+vecA.y*vecB.y+vecA.z*vecB.z;
		}
		/**
		 * 为A向量填充值 
		 * @param vecA
		 * @param x
		 * @param y
		 * @param z
		 * 
		 */		
		public static function SetTo(vecA:CVector,x:Number,y:Number,z:Number):void
		{
			vecA.x=x;
			vecA.y=y;
			vecA.z=z;
		}
		/**
		 * 将B向量的值全部赋给A向量 
		 * @param vecA
		 * @param vecB
		 * 
		 */		
		public static function Copy(vecA:CVector,vecB:CVector):void
		{
			vecA.x=vecB.x;
			vecA.y=vecB.y;
			vecA.z=vecB.z;
			vecA.w=vecB.w;
		}
		/**
		 *  A向量与B向量是否相等
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return Boolean
		 * 
		 */		
		public static function Equal(vecA:CVector,vecB:CVector):Boolean
		{
			return vecA.x==vecB.x && vecA.y==vecB.y && vecA.z==vecB.z;
		}
		/**
		 * A向量与B向量是否全部相等 
		 * @param vecA	A向量
		 * @param vecB	B向量
		 * @return Boolean
		 * 
		 */		
		public static function AllEqual(vecA:CVector,vecB:CVector):Boolean
		{
			return Equal(vecA,vecB) && vecA.w==vecB.w;
		}
	}
}
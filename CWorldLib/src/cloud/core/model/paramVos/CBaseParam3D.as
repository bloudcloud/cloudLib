package cloud.core.model.paramVos
{
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.Transform3D;
	
	import cloud.core.interfaces.ICParamObject3D;
	import cloud.core.utils.MathUtil;
	import cloud.core.utils.Vector3DUtil;
	
	/**
	 * 基础参数化部件数据类
	 * @author cloud
	 */
	public class CBaseParam3D implements ICParamObject3D
	{
		protected var _length:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _direction:Vector3D;
		
		private var _invalidPosition:Boolean;
		private var _invalidTransform:Boolean;
		private var _isLife:Boolean;
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _rotation:int;
		private var _position:Vector3D;
		private var _transform:Transform3D;
		private var _inverseTransform:Transform3D;
		
		private var _topOffset:Number;
		private var _bottomOffset:Number;
		private var _leftOffset:Number;
		private var _rightOffset:Number;

		public function get isLife():Boolean
		{
			return _isLife;
		}
		public function set isLife(value:Boolean):void
		{
			_isLife=value;
		}
		public function get topOffset():Number
		{
			return _leftOffset;
		}
		
		public function set topOffset(value:Number):void
		{
			_leftOffset=value;
		}
		
		public function get bottomOffset():Number
		{
			return _bottomOffset;
		}
		
		public function set bottomOffset(value:Number):void
		{
			_bottomOffset=value;
		}
		
		public function get leftOffset():Number
		{
			return _leftOffset;
		}
		
		public function set leftOffset(value:Number):void
		{
			_leftOffset=value;
		}
		
		public function get rightOffset():Number
		{
			return _rightOffset;
		}
		
		public function set rightOffset(value:Number):void
		{
			_rightOffset=value;
		}
		
		public function get length():Number
		{
			return _length;
		}
		
		public function set length(value:Number):void
		{
			_length=value;
		}
		
		public function get width():Number
		{
			return _width; 
		}
		
		public function set width(value:Number):void
		{
			_width=value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height=value;
		}
		
		public function get direction():Vector3D
		{
			return _direction;
		}
		
		public function set direction(value:Vector3D):void
		{
			if(value!=null)
				_direction.copyFrom(value);
			else
				_direction.copyFrom(Vector3DUtil.ZERO);
		}
		
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x!=value)
			{
				_invalidPosition=true;
				_invalidTransform=true;
				_x=value;
			}
		}
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y!=value)
			{
				_invalidPosition=true;
				_invalidTransform=true;
				_y=value;
			}
		}
		public function get z():Number
		{
			return _z;
		}
		public function set z(value:Number):void
		{
			if(_z!=value)
			{
				_invalidPosition=true;
				_invalidTransform=true;
				_z=value;
			}
		}
		
		public function get rotation():int
		{
			return _rotation;
		}
		
		public function set rotation(value:int):void
		{
			if(_rotation!=value)
			{
				_invalidTransform=true;
				_rotation=value;
			}
		}
		
		public function get position():Vector3D
		{
			if(_invalidPosition)
				updatePosition();
			return _position;
		}
		
		public function get transform():Transform3D
		{
			if(_invalidTransform)
				updateTransform();
			return _transform;
		}
		
		public function get inverseTransform():Transform3D
		{
			if(_invalidTransform)
				updateTransform();
			return _inverseTransform;
		}
		
		public function get invalidPosition():Boolean
		{
			return _invalidPosition;
		}
		
		public function CBaseParam3D()
		{
			_position=new Vector3D();
			_direction=new Vector3D();
			_transform=new Transform3D();
			_inverseTransform=new Transform3D();
			_length=_width=_height=_rotation=_x=_y=_z=0;
			_topOffset=_bottomOffset=_leftOffset=_rightOffset=0;
			_isLife=true;
		}
		
		protected function updatePosition():void
		{
			_invalidPosition=false;
			_position.setTo(x,y,z);
		}
		
		protected function updateTransform():void
		{
			_invalidTransform=false;
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
			transform.a = cosZ*cosYscaleX;
			transform.b = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			transform.c = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			transform.d = _x;
			transform.e = sinZ*cosYscaleX;
			transform.f = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			transform.g = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			transform.h = _y;
			transform.i = -sinY;
			transform.j = cosY*sinXscaleY;
			transform.k = cosY*cosXscaleZ;
			transform.l = _z;
			// Inverse matrix
			var sinXsinY:Number = sinX*sinY;
			cosYscaleX = cosY;
			cosXscaleY = cosX;
			sinXscaleZ = -sinX;
			cosXscaleZ = cosX;
			inverseTransform.a = cosZ*cosYscaleX;
			inverseTransform.b = sinZ*cosYscaleX;
			inverseTransform.c = -sinY;
			inverseTransform.d = -inverseTransform.a*_x - inverseTransform.b*_y - inverseTransform.c*_z;
			inverseTransform.e = sinXsinY*cosZ - sinZ*cosXscaleY;
			inverseTransform.f = cosZ*cosXscaleY + sinXsinY*sinZ;
			inverseTransform.g = sinX*cosY;
			inverseTransform.h = -inverseTransform.e*_x - inverseTransform.f*_y - inverseTransform.g*_z;
			inverseTransform.i = cosZ*sinY*cosXscaleZ - sinZ*sinXscaleZ;
			inverseTransform.j = cosZ*sinXscaleZ + sinY*sinZ*cosXscaleZ;
			inverseTransform.k = cosY*cosXscaleZ;
			inverseTransform.l = -inverseTransform.i*_x - inverseTransform.j*_y - inverseTransform.k*_z;
		}
		
		public function clear():void
		{
			_position=null;
			_direction=null;
			_transform=null;
			_inverseTransform=null;
			_isLife=false;
		}
	}
}
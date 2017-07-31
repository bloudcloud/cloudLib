package cloud.core.model.paramVos
{
	import cloud.core.data.CTransform3D;
	import cloud.core.data.CVector;
	import cloud.core.data.container.CVector3DContainer;
	import cloud.core.dict.SerializeFormate;
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICObject3D;
	import cloud.core.interfaces.ICSerialization;
	import cloud.core.interfaces.ICSize;
	import cloud.core.utils.CDebug;
	
	import ns.cloudLib;
	
	use namespace cloudLib;
	/**
	 * 基础参数化对象数据类
	 * @author cloud
	 */
	public class CBaseObject3DVO implements ICObject3D, ICSize, ICData, ICSerialization
	{
		private static const _TRANSFORM:CTransform3D=new CTransform3D();
		
		protected var _isXYZ:Boolean;
		protected var _className:String;
		protected var _length:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _x:Number;
		protected var _y:Number;
		protected var _z:Number;
		protected var _scaleLength:Number;
		protected var _scaleWidth:Number;
		protected var _scaleHeight:Number;
		protected var _rotationLength:Number;
		protected var _rotationWidth:Number;
		protected var _rotationHeight:Number;
		protected var _offLeft:Number;
		protected var _offBack:Number;
		protected var _offGround:Number;
		protected var _isLife:Boolean;
		protected var _direction:CVector;
		protected var _roundPoints:CVector3DContainer;
		protected var _globalRotation:CVector;
		protected var _minSize:CVector;
		protected var _maxSize:CVector;
		
		private var _refCount:int;
		private var _name:String;
		private var _uniqueID:String;
		private var _type:uint;
		private var _parentID:String;
		private var _parentType:uint;
		private var _position:CVector;
		private var _transform:CTransform3D;
		private var _inverseTransform:CTransform3D;
		private var _invalidPosition:Boolean;
		private var _invalidSize:Boolean;
		private var _invalidTransform:Boolean;
		
		private var _numChildren:Number;
		private var _children:ICObject3D ;
		private var _next:ICObject3D;
		
		cloudLib var _parent:ICObject3D;
		cloudLib var _invalidParent:Boolean;
		
		public function get children():ICObject3D
		{
			return _children;
		}
		public function get className():String
		{
			return _className;
		}
		public function get numChildren():int
		{	
			return _numChildren;
		}
		public function get parent():ICObject3D
		{
			return _parent;
		}
		public function get roundPoints():CVector3DContainer
		{
			return _roundPoints;
		}
		public function set roundPoints(value:CVector3DContainer):void
		{
			if(value==null)
			{
				_roundPoints.back();
				_roundPoints=null;
			}
			else if(_roundPoints!=value)
			{
				_roundPoints.clear();
				_roundPoints.add(value);
			}
		}
		public function get length():Number
		{
			return _length;
		}
		public function set length(value:Number):void
		{
			if(_length!=value)
				_invalidSize=true;
			_length=value;
		}
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if(_width!=value)
				_invalidSize=true;
			_width=value;
		}
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if(_height!=value)
				_invalidSize=true;
			_height=value;
		}
		/**
		 * 获取世界坐标系下的旋转角度值
		 * @return CVector
		 * 
		 */		
		public function get globalRotation():CVector
		{
			if(_invalidParent)
			{
				if(parent)
				{
					_globalRotation.x+=(parent as CBaseObject3DVO).globalRotation.x;
					_globalRotation.y+=(parent as CBaseObject3DVO).globalRotation.y;
					_globalRotation.z+=(parent as CBaseObject3DVO).globalRotation.z;
				}
				else
				{
					_globalRotation.x=rotationLength;
					_globalRotation.y=rotationWidth;
					_globalRotation.z=rotationHeight;
				}
				_invalidParent=false;
			}
			return _globalRotation;
		}
		public function get direction():CVector
		{
			return _direction;
		}	
		public function get x():Number
		{
			if(_invalidPosition)
			{
				_invalidPosition=false;
				if(parent!=null)
					doUpdatePosition();
			}
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x!=value)
			{
				_invalidTransform=true;
				_x=value;
			}
		}
		public function get y():Number
		{
			if(_invalidPosition)
			{
				_invalidPosition=false;
				if(parent!=null)
					doUpdatePosition();
			}
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y!=value)
			{
				_invalidTransform=true;
				_y=value;
			}
		}
		public function get z():Number
		{
			if(_invalidPosition)
			{
				_invalidPosition=false;
				if(parent!=null)
					doUpdatePosition();
			}
			return _z;
		}
		public function set z(value:Number):void
		{
			if(_z!=value)
			{
				_invalidTransform=true;
				_z=value;
			}
		}
		public function get scaleLength():Number
		{
			return _scaleLength;
		}
		public function set scaleLength(value:Number):void
		{
			if(_scaleLength!=value)
			{
				_invalidTransform=true;
				_scaleLength=value;
			}
		}
		public function get scaleWidth():Number
		{
			return _scaleWidth;
		}
		public function set scaleWidth(value:Number):void
		{
			if(_scaleWidth!=value)
			{
				_invalidTransform=true;
				_scaleWidth=value;
			}
		}
		public function get scaleHeight():Number
		{
			return _scaleHeight;
		}
		public function set scaleHeight(value:Number):void
		{
			if(_scaleHeight!=value)
			{
				_invalidTransform=true;
				_scaleHeight=value;
			}
		}
		public function get rotationLength():Number
		{
			if(_rotationLength<-180)
				_rotationLength+=360;
			else if(_rotationLength>180)
				_rotationLength-=360;
			return _rotationLength;
		}
		public function set rotationLength(value:Number):void
		{
			if(_rotationLength!=value)
			{
				_invalidTransform=true;
				_rotationLength=value;
				_globalRotation.x=value;
			}
		}
		public function get rotationWidth():Number
		{
			if(_rotationWidth<-180)
				_rotationWidth+=360;
			else if(_rotationWidth>180)
				_rotationWidth-=360;
			return _rotationWidth;
		}
		public function set rotationWidth(value:Number):void
		{
			if(_rotationWidth!=value)
			{
				_invalidTransform=true;
				_rotationWidth=value;
				_globalRotation.y=value;
			}
		}
		public function get rotationHeight():Number
		{
			if(_rotationHeight<-180)
				_rotationHeight+=360;
			else if(_rotationHeight>180)
				_rotationHeight-=360;
			return _rotationHeight;
		}
		public function set rotationHeight(value:Number):void
		{
			if(_rotationHeight!=value)
			{
				_invalidTransform=true;
				_rotationHeight=value;
				_globalRotation.z=value;
			}
		}
		public function get isLife():Boolean
		{
			return _isLife;
		}
		public function set isLife(value:Boolean):void
		{
			_isLife=value;
		}
		public function get position():CVector
		{
			if(_invalidTransform)
			{
				_invalidTransform=false;
				doUpdateTransform();
			}
			else if(_invalidPosition)
			{
				_invalidPosition=false;
				if(parent!=null)
					doUpdatePosition();
			}
			return _position;
		}
		public function get transform():CTransform3D
		{
			if(_invalidTransform)
			{
				_invalidTransform=false;
				doUpdateTransform();
			}
			return _transform;
		}
		public function get inverseTransform():CTransform3D
		{
			if(_invalidTransform)
			{
				_invalidTransform=false;
				doUpdateTransform();
			}
			return _inverseTransform;
		}
		public function get invalidPosition():Boolean
		{
			return _invalidPosition;
		}
		public function set invalidPosition(value:Boolean):void
		{
			_invalidPosition=value;
		}
		public function get invalidSize():Boolean
		{
			return _invalidSize;
		}
		public function get invalidParent():Boolean
		{
			return _invalidParent;
		}
		public function get offLeft():Number
		{
			return _offLeft;
		}
		public function set offLeft(value:Number):void
		{
			if(_offLeft!=value)
				_offLeft=value;
		}
		public function get offBack():Number
		{
			return _offBack;
		}
		public function set offBack(value:Number):void
		{
			if(_offLeft!=value)
				_offBack=value;
		}
		public function get offGround():Number
		{
			return _offGround;
		}
		public function set offGround(value:Number):void
		{
			if(_offLeft!=value)
				_offGround=value;
		}
		public function get uniqueID():String
		{
			return _uniqueID;
		}
		public function set uniqueID(value:String):void
		{
			_uniqueID=value;
		}
		public function get parentID():String
		{
			return parent!=null && parent is ICData?(parent as ICData).uniqueID:_parentID;
		}
		public function set parentID(value:String):void
		{
			if(parent==null)
				_parentID=value;
		}
		public function get parentType():uint
		{
			return parent!=null && parent is ICData?(parent as ICData).type:_parentType;
		}
		public function set parentType(value:uint):void
		{
			if(parent==null)
				_parentType=value;
		}
		public function get type():uint
		{
			return _type;
		}
		public function set type(value:uint):void
		{
			_type=value;
		}
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name=value;
		}
		public function get refCount():uint
		{
			return _refCount;
		}
		public function set refCount(value:uint):void
		{
			_refCount=value;
		}	
		public function get next():ICObject3D
		{
			return _next;
		}
		public function set next(value:ICObject3D):void
		{
			_next=value;
		}
	
		public function CBaseObject3DVO(clsName:String="CBaseObject3DVO")
		{
			_className=clsName;
			_position=CVector.CreateOneInstance();
			_direction=CVector.X_AXIS.clone() as CVector;
			_globalRotation=CVector.CreateOneInstance();
			_minSize=CVector.CreateOneInstance();
			_maxSize=CVector.CreateOneInstance();
			_transform=CTransform3D.CreateOneInstance();
			_inverseTransform=CTransform3D.CreateOneInstance();
			_roundPoints=CVector3DContainer.CreateOneInstance();
			
			_length=_width=_height=_rotationLength=_rotationWidth=_rotationHeight=0;
			_x=_y=_z=0;
			_offLeft=_offBack=_offGround=0;
			_scaleLength=_scaleWidth=_scaleHeight=1;
			_isLife=true;
			_invalidTransform=true;
			_invalidPosition=true;
		}
		private function doUpdateSize():void
		{
			
		}

		private function doUpdateTransform():void
		{
			CTransform3D.Compose(_transform,x,y,z,rotationLength,rotationWidth,rotationHeight,scaleLength,scaleWidth,scaleHeight);
			CTransform3D.ComposeInverse(_inverseTransform,x,y,z,rotationLength,rotationWidth,rotationHeight,scaleLength,scaleWidth,scaleHeight);
			_position.x=x;
			_position.y=y;
			_position.z=z;
		}
		private function doUpdatePosition():void
		{
			if(_isXYZ)
			{
				doUpdatePositionByXYZ();
			}
			else
			{
				doUpdatePositionByOffset();
			}
			_position.x=x;
			_position.y=y;
			_position.z=z;
		}
		protected function doUpdatePositionByXYZ():void
		{
			x+=parent.x;
			y+=parent.y;
			z+=parent.z;
		}
		protected function doUpdatePositionByOffset():void
		{
			var dir:CVector=direction.clone() as CVector;
			var toward:CVector=CVector.CrossValue(direction,CVector.Z_AXIS);
			var zAxis:CVector=CVector.Z_AXIS.clone() as CVector;
			CVector.Scale(dir,-parent.length*.5+this.length*.5+offLeft);
			CVector.Scale(toward,parent.width+2+offBack);
			CVector.Scale(zAxis,-parent.height*.5+this.height*.5+offGround);
			x=dir.x+toward.x+zAxis.x;
			y=dir.y+toward.y+zAxis.y;
			z=dir.z+toward.z+zAxis.z;
			dir.back();
			toward.back();
			zAxis.back();
		}
		protected function doDeserializeXML(xml:XML):void
		{
		}
		protected function doSerializeXML():XML
		{
			return null;
		}
		protected function removeFromList(child:ICObject3D):ICObject3D
		{
			var prev:ICObject3D;
			(child as CBaseObject3DVO)._invalidParent=true;
			for (var current:ICObject3D = _children; current != null; current = current.next) 
			{
				if (current == child) 
				{
					if (prev != null) 
					{
						prev.next = current.next;
					} else 
					{
						_children = current.next as CBaseObject3DVO;
					}
					current.next = null;
					return child;
				}
				prev = current;
			}
			return child;
		}
		protected function addToList(child:ICObject3D):void
		{
			(child as CBaseObject3DVO)._invalidParent=true;
			child.next = null;
			if (null == _children) 
			{
				_children = child as CBaseObject3DVO;
			} else 
			{
				for (var current:ICObject3D = _children; current != null; current = current.next) 
				{
					if (current.next == null) 
					{
						current.next = child;
						break;
					}
				}
			}
		}
		/**
		 * 更新参数化物体数据对象 
		 * @param source 参数化物体源数据对象
		 * 
		 */		
		public function updateVO(source:CBaseObject3DVO):void
		{
			this.length=source.length;
			this.width=source.width;
			this.height=source.height;
			this.x=source.x;
			this.y=source.y;
			this.z=source.z;
			this.offLeft=source.offLeft;
			this.offBack=source.offBack;
			this.offGround=source.offGround;
			this.rotationLength=source.rotationLength;
			this.rotationWidth=source.rotationWidth;
			this.rotationHeight=source.rotationHeight;
			this.scaleLength=source.scaleLength;
			this.scaleWidth=source.scaleWidth;
			this.scaleHeight=source.scaleHeight;
		}
		public function updateProperties():void
		{
			if(_invalidSize)
			{
				_invalidSize=false;
				doUpdateSize();
			}
		}
		public function compare(source:ICData):Number
		{
			var distance:Number;
			var vo:ICObject3D=source as ICObject3D;
			if(vo)
			{
				var vec:CVector=CVector.Substract(this.position,vo.position);
				distance=CVector.DotValue(vec,vo.direction)>0 ? vec.length : vec.length*-1;
			}
			else
				CDebug.instance.throwError(_className,"compare"," vo"," 参数不是家具数据类型！");
			return distance;
		}
		public function toString():String
		{
			return _className+" :"+"uniqueID:"+_uniqueID+" "+"type:"+_type+" "+"parentID:"+_parentID+" "+"direction:"+_direction+" "
				+"length:"+_length+" "+"width:"+_width+" "+"height:"+_height+" "+"position:"+_position+" "
				+"transform:"+transform+" "+"inverseTransform:"+inverseTransform+"\n";
		}	
		public function deserialize(source:*):void
		{
			if(source is XML)
			{
				doDeserializeXML(source as XML);
			}
		}
		public function serialize(formate:String):*
		{
			var xml:XML;
			if(formate==SerializeFormate.SERIALIZATION_FORMATE_XML)
			{
				xml=doSerializeXML();
			}
			return xml;
		}
		public function getChildAt(index:int):ICObject3D
		{
			var idx:int;
			for(var child:ICObject3D=_children; child!=null; child=child.next)
			{
				if(idx==index)
					return child;
				idx++;
			}
			return null;
		}
		public function addChild(child:ICObject3D):void
		{
			if(child==null || child==this) return;
			for (var container:ICObject3D = parent; container != null; container = container.parent) 
			{
				if (container == child) return;
			}
			// 加入当前对象
			if (child.parent != this) 
			{
				//从旧的父对象移除
				if (child.parent != null) child.parent.removeChild(child);
				addToList(child);
				_numChildren++;
				(child as CBaseObject3DVO)._parent = this;
			} 
			else 
			{
				child = removeFromList(child);
				if (child == null) throw new ArgumentError("Cannot add child.");
				addToList(child);
			}
		}
		public function removeChild(child:ICObject3D):void
		{
			if (child==null || child.parent!=this) return;
			child = removeFromList(child);
			if (child == null) throw new ArgumentError("Cannot remove child.");
			_numChildren--;
			(child as CBaseObject3DVO)._parent = null;
		}
		public function localToGlobal(vec:CVector,outPut:CVector):void
		{
			CTransform3D.Copy(_TRANSFORM,transform);
			var root:ICObject3D = this;
			while (root.parent != null) {
				root = root.parent;
				CTransform3D.Append(_TRANSFORM,root.transform);
			}
			outPut.x = _TRANSFORM.a*vec.x + _TRANSFORM.b*vec.y + _TRANSFORM.c*vec.z + _TRANSFORM.d;
			outPut.y = _TRANSFORM.e*vec.x + _TRANSFORM.f*vec.y + _TRANSFORM.g*vec.z + _TRANSFORM.h;
			outPut.z = _TRANSFORM.i*vec.x + _TRANSFORM.j*vec.y + _TRANSFORM.k*vec.z + _TRANSFORM.l;
		}
		public function globalToLocal(vec:CVector,outPut:CVector):void {
			CTransform3D.Copy(_TRANSFORM,inverseTransform);
			var root:ICObject3D = this;
			while (root.parent != null) {
				root = root.parent;
				CTransform3D.Prepend(_TRANSFORM,root.inverseTransform);
			}
			outPut.x = _TRANSFORM.a*vec.x + _TRANSFORM.b*vec.y + _TRANSFORM.c*vec.z + _TRANSFORM.d;
			outPut.y = _TRANSFORM.e*vec.x + _TRANSFORM.f*vec.y + _TRANSFORM.g*vec.z + _TRANSFORM.h;
			outPut.z = _TRANSFORM.i*vec.x + _TRANSFORM.j*vec.y + _TRANSFORM.k*vec.z + _TRANSFORM.l;
		}
		public function clear():void
		{
			_position.back();
			_direction.back();
			_transform.back();
			_inverseTransform.back();
			_roundPoints.back();
			_globalRotation.back();
			_minSize.back();
			_maxSize.back();
			_position=null;
			_direction=null;
			_transform=null;
			_inverseTransform=null;
			_roundPoints=null;
			_isLife=false;
			if(parent)
				parent.removeChild(this);
			for(var child:ICObject3D=_children; child!=null; child=child.next)
			{
				if((child as CBaseObject3DVO).isLife)
					child.clear();
				_children = child.next as CBaseObject3DVO;
				child.next = null;
			}
			_children=null;
		}
	}
}
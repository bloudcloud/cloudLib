package cloud.core.mvcs.model.paramVos
{
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.datas.base.CVector;
	import cloud.core.datas.containers.CVectorContainer;
	import cloud.core.dict.CConst;
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.interfaces.ICObject3D;
	import cloud.core.interfaces.ICResource;
	import cloud.core.interfaces.ICSerialization;
	import cloud.core.interfaces.ICSize;
	import cloud.core.utils.CDebugUtil;
	import cloud.core.utils.CVectorUtil;
	
	import ns.cloudLib;
	
	use namespace cloudLib;
	/**
	 * 基础参数化对象数据类
	 * @author cloud
	 */
	public class CBaseObject3DVO implements ICObject3D, ICSize, ICNodeData, ICSerialization,ICResource
	{
		protected var _isXYZ:Boolean;
		protected var _className:String;
		protected var _length:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _x:Number;
		protected var _y:Number;
		protected var _z:Number;
		protected var _centerX:Number;
		protected var _centerY:Number;
		protected var _centerZ:Number;
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
		
		protected var _originX:Number;
		protected var _originY:Number;
		protected var _originZ:Number;

		private var _refCount:int;
		private var _name:String;
		private var _uniqueID:String;
		private var _type:uint;
		private var _parentID:String;
		private var _parentType:uint;
		private var _direction:CVector;
		private var _roundPoints:CVectorContainer;
		private var _globalRotation:CVector;
		private var _minSize:CVector;
		private var _maxSize:CVector;
		private var _position:CVector;
		private var _transform:CTransform3D;
		private var _inverseTransform:CTransform3D;
		private var _invalidPosition:Boolean;
		private var _invalidSize:Boolean;
		private var _invalidTransform:Boolean;
		
		private var _numChildren:Number;
		private var _children:ICObject3D ;
		private var _next:ICObject3D;
		
		
		public var moduleType:uint;
		
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
		public function get roundPoints():CVectorContainer
		{
			return _roundPoints;
		}
		public function set roundPoints(value:CVectorContainer):void
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
			if(rotationHeight)
			{
				CVectorUtil.Instance.calculateDirectionByRotation(rotationHeight,_direction);
			}
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
		public function get maxSize():CVector
		{
			return _maxSize||=CVector.CreateOneInstance();
		}
		public function get minSize():CVector
		{
			return _minSize||=CVector.CreateOneInstance();
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
				{
					doUpdatePosition();
				}
			}
			return _position||=CVector.CreateOneInstance();
		}
		public function get transform():CTransform3D
		{
			_transform||=CTransform3D.CreateOneInstance();
			if(_invalidTransform)
			{
				_invalidTransform=false;
				doUpdateTransform();
			}
			return _transform;
		}
		public function get inverseTransform():CTransform3D
		{
			_inverseTransform||=CTransform3D.CreateOneInstance();
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
			_name=clsName;
			_position=CVector.CreateOneInstance();
			_direction=CVector.X_AXIS.clone() as CVector;
			_globalRotation=CVector.CreateOneInstance();
			_minSize=CVector.CreateOneInstance();
			_maxSize=CVector.CreateOneInstance();
			_transform=CTransform3D.CreateOneInstance();
			_inverseTransform=CTransform3D.CreateOneInstance();
			_roundPoints=CVectorContainer.CreateOneInstance();
			
			_length=_width=_height=_rotationLength=_rotationWidth=_rotationHeight=0;
			_x=_y=_z=_centerX=_centerY=_centerZ=0;
			_offLeft=_offBack=_offGround=0;
			_scaleLength=_scaleWidth=_scaleHeight=1;
			_isLife=true;
			_invalidTransform=true;
//			_invalidPosition=true;
		}
		private function doUpdateSize():void
		{
			
		}

		private function doUpdateTransform():void
		{
			CTransform3D.Compose(transform,rotationLength,rotationWidth,rotationHeight,scaleLength,scaleWidth,scaleHeight,x,y,z);
			CTransform3D.ComposeInverse(inverseTransform,rotationLength,rotationWidth,rotationHeight,scaleLength,scaleWidth,scaleHeight,x,y,z);
			CVector.SetTo(position,x,y,z);
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
			CVector.SetTo(position,_x,_y,_z);
		}
		protected function doUpdatePositionByXYZ():void
		{
			var dir:CVector=CVector.CreateOneInstance();
			CVectorUtil.Instance.calculateDirectionByRotation(globalRotation.z,dir);
			var toward:CVector=CVector.CrossValue(dir,CVector.Z_AXIS);
			CVector.Scale(toward,parent.width+2+offBack);
			x=_originX+toward.x;
			y=_originY+toward.y;
			z=_originZ+toward.z;
			toward.back();
		}
		protected function doUpdatePositionByOffset():void
		{
			var dir:CVector=direction.clone() as CVector;
			var toward:CVector=CVector.CrossValue(direction,CVector.Z_AXIS);
			var zAxis:CVector=CVector.Z_AXIS.clone() as CVector;
			CVector.Scale(dir,-parent.length*.5+this.length*.5+offLeft);
			CVector.Scale(toward,parent.width+2+offBack);
			CVector.Scale(zAxis,-parent.height*.5+this.height*.5+offGround);
			_originX=dir.x+toward.x+zAxis.x;
			_originY=dir.y+toward.y+zAxis.y;
			_originZ=dir.z+toward.z+zAxis.z;
			x=_originX;
			y=_originY;
			z=_originZ;
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
				CDebugUtil.Instance.throwError(_className,"compare"," vo"," 参数不是家具数据类型！");
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
			if(formate==CConst.SERIALIZATION_FORMATE_XML)
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
			var tmpTransform:CTransform3D=transform.clone() as CTransform3D;
			var root:ICObject3D = this;
			while (root.parent != null) {
				root = root.parent;
				CTransform3D.Append(tmpTransform,root.transform);
			}
			outPut.x = tmpTransform.a*vec.x + tmpTransform.b*vec.y + tmpTransform.c*vec.z + tmpTransform.d;
			outPut.y = tmpTransform.e*vec.x + tmpTransform.f*vec.y + tmpTransform.g*vec.z + tmpTransform.h;
			outPut.z = tmpTransform.i*vec.x + tmpTransform.j*vec.y + tmpTransform.k*vec.z + tmpTransform.l;
		}
		public function globalToLocal(vec:CVector,outPut:CVector):void {
			var tmpTransform:CTransform3D=transform.clone() as CTransform3D;
			CTransform3D.Copy(tmpTransform,inverseTransform);
			var root:ICObject3D = this;
			while (root.parent != null) {
				root = root.parent;
				CTransform3D.Prepend(tmpTransform,root.inverseTransform);
			}
			outPut.x = tmpTransform.a*vec.x + tmpTransform.b*vec.y + tmpTransform.c*vec.z + tmpTransform.d;
			outPut.y = tmpTransform.e*vec.x + tmpTransform.f*vec.y + tmpTransform.g*vec.z + tmpTransform.h;
			outPut.z = tmpTransform.i*vec.x + tmpTransform.j*vec.y + tmpTransform.k*vec.z + tmpTransform.l;
		}
		public function clear():void
		{
			if(_position)
			{
				_position.back();
				_position=null;
			}
			if(_direction)
			{
				_direction.back();
				_direction=null;
			}
			if(_transform)
			{
				_transform.back();
				_transform=null;
			}
			if(_inverseTransform)
			{
				_inverseTransform.back();
				_inverseTransform=null;
			}
			if(_roundPoints)
			{
				_roundPoints.back();
				_roundPoints=null;
			}
			if(_globalRotation)
			{
				_globalRotation.back();
				_globalRotation=null;
			}
			if(_minSize)
			{
				_minSize.back();
				_minSize=null;
			}
			if(_maxSize)
			{
				_maxSize.back();
				_maxSize=null;
			}
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
			
			_invalidTransform=_invalidPosition=_invalidParent=_invalidSize=false;
			_numChildren=0;
			_length=_width=_height=_rotationLength=_rotationWidth=_rotationHeight=0;
			_x=_y=_z=_centerX=_centerY=_centerZ=0;
			_offLeft=_offBack=_offGround=0;
			_scaleLength=_scaleWidth=_scaleHeight=1;
		}
		public function clone():ICData
		{
			return null;
		}
	}
}
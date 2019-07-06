package extension.cloud.mvcs.base.model
{
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CBoundBox;
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CMathUtilForAS;
	
	import extension.cloud.interfaces.ICEntity3DData;
	import extension.cloud.singles.CL3DGlobalCacheUtil;

	/**
	 * 基础实体数据
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CBaseEntity3DData extends CBaseL3DData implements ICEntity3DData
	{
		private var _invalidTransform:Boolean;
		private var _invalidSize:Boolean;
		private var _direction:Vector3D;
		private var _normal:Vector3D;
		private var _vertical:Vector3D;
		private var _length:Number;
		private var _width:Number;
		private var _height:Number;
		
		protected var _roundPoint3DValues:Vector.<Number>;
		protected var _outline3DBox:CBoundBox;
		protected var _transform:CTransform3D;
		protected var _originPosition:Vector3D;
		protected var _position:Vector3D

		public function get roundPoint3DValues():Vector.<Number>
		{
			return _roundPoint3DValues;
		}
		public function set roundPoint3DValues(value:Vector.<Number>):void
		{
			_roundPoint3DValues=value;
		}

		public function set outline3DBox(value:CBoundBox):void
		{
			if(!value)
			{
				return;
			}
			_outline3DBox=value;
			_invalidSize=true;
		}
		public function set transform(value:CTransform3D):void
		{
			if(!value)
			{
				return;
			}
			CTransform3D.Copy(_transform,value);
			CMathUtil.Instance.decomposeTransform3D(_transform,_direction,_normal,_vertical,_originPosition);
			_position.setTo(_originPosition.x/CL3DGlobalCacheUtil.Instance.sceneScaleRatio,_originPosition.y/CL3DGlobalCacheUtil.Instance.sceneScaleRatio,_originPosition.z/CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
		}
		public function get position():Vector3D
		{
			return _position;
		}
		public function set position(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_position,value))
			{
				_invalidTransform=true;
				_position.copyFrom(value);
			}
		}
		public function get x():Number
		{
			return _position.x;
		}
		public function set x(value:Number):void
		{
			if(_position.x!=value)
			{
				_invalidTransform=true;
				_position.x=value;
			}
		}
		public function get y():Number
		{
			return _position.y;
		}
		public function set y(value:Number):void
		{
			if(_position.y!=value)
			{
				_invalidTransform=true;
				_position.y=value;
			}
		}
		public function get z():Number
		{
			return _position.z;
		}
		public function set z(value:Number):void
		{
			if(_position.z!=value)
			{
				_invalidTransform=true;
				_position.z=value;
			}
		}
		public function get direction():Vector3D
		{
			return _direction;
		}
		public function set direction(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_direction,value))
			{
				_invalidTransform=true;
				_direction.copyFrom(value);
			}
		}
		public function get normal():Vector3D
		{
			return _normal;
		}
		public function set normal(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_normal,value))
			{
				_invalidTransform=true;
				_normal.copyFrom(value);
			}
		}
		public function get vertical():Vector3D
		{
			return _vertical;
		}
		public function set vertical(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_vertical,value))
			{
				_invalidTransform=true;
				_vertical.copyFrom(value);
			}
		}
		public function get length():Number
		{
			if(_invalidSize)
			{
				doCalculateSize();
			}
			return _length;
		}
		public function get width():Number
		{
			if(_invalidSize)
			{
				doCalculateSize();
			}
			return _width;
		}
		public function get height():Number
		{
			if(_invalidSize)
			{
				doCalculateSize();
			}
			return _height;
		}
		
		public function get transform():CTransform3D
		{
			if(_invalidTransform)
			{
				doCalculateTransform();
			}
			return _transform;
		}

		public function CBaseEntity3DData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID);
			_position=new Vector3D();
			_originPosition=new Vector3D();
			_direction=Vector3D.X_AXIS.clone();
			_normal=Vector3D.Y_AXIS.clone();
			_vertical=Vector3D.Z_AXIS.clone();
			_transform=CTransform3D.CreateOneInstance();
		}
		
		private function doCalculateTransform():void
		{
			_invalidTransform=false;
			_originPosition.setTo(_position.x*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,_position.y*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,_position.z*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
			CMathUtil.Instance.calculateTransform3D(_transform,_direction,_normal,_vertical,_originPosition);
		}
		private function doCalculateSize():void
		{
			_invalidSize=false;
			_length=(_outline3DBox.maxX-_outline3DBox.minX)/CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
			_width=(_outline3DBox.maxY-_outline3DBox.minY)/CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
			_height=(_outline3DBox.maxZ-_outline3DBox.minZ)/CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
		}
		
	}
}
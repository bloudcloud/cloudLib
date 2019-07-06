package extension.cloud.datas
{
	import flash.geom.Vector3D;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICLine;
	import cloud.core.utils.CMathUtilForAS;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.singles.CL3DModuleUtil;
	
	/**
	 * 线条3D数据类
	 * @author	cloud
	 * @date	2018-7-17
	 */
	public class CWallLineData extends CBaseL3DData implements ICLine
	{
		private var _invalid:Boolean;
		private var _length:Number;
		private var _start:Vector3D;
		private var _end:Vector3D;
		private var _direction:Vector3D;
		private var _center:Vector3D;
		private var _isUsed:Boolean;
		/**
		 * 内墙厚 
		 */		
		public var innerThickness:Number;
		/**
		 * 外墙厚 
		 */		
		public var outterThickness:Number;
		
		public function get length():Number
		{
			return _length;
		}
		public function set start(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_start,value))
			{
				_start.copyFrom(value);
				_invalid=true;
			}
		}
		public function get start():Vector3D
		{
			return _start;
		}
		public function set end(value:Vector3D):void
		{
			if(!value)
			{
				return;
			}
			if(!CMathUtilForAS.Instance.isEqualVector3D(_end,value))
			{
				_end.copyFrom(value);
				_invalid=true;
			}
		}
		public function get end():Vector3D
		{
			return _end;
		}
		public function get direction():Vector3D
		{
			if(_invalid)
			{
				_invalid=false;
				_direction.setTo(_end.x-_start.x,_end.y-_start.y,_end.z-_start.z);
				_length=_direction.normalize();
			}
			return _direction;
		}
		public function get center():Vector3D
		{
			_center.setTo(_start.x+direction.x*_length*.5,_start.y+direction.y*_length*.5,_start.z+direction.z*_length*.5);
			return _center;
		}
		public function get isUsed():Boolean
		{
			return _isUsed;
		}
		public function set isUsed(value:Boolean):void
		{
			_isUsed=value;
		}
		
		public function CWallLineData(clsName:String=CMVCSClassDic.CLASSNAME_WALLLINE_DATA)
		{
			super(clsName,CL3DModuleUtil.Instance.createEntityUID(CL3DConstDict.WALL_SYMBOL,CUtil.Instance.createUID()));
			_start=new Vector3D();
			_end=new Vector3D();
			_direction=new Vector3D();
			_center=new Vector3D();
		}
		override public function compare(source:ICData):Number
		{
			if(source is CWallLineData && CMathUtilForAS.Instance.isEqualVector3D(this.start,(source as CWallLineData).start) && CMathUtilForAS.Instance.isEqualVector3D(this.end,(source as CWallLineData).end))
			{
				return 0;
			}
			return 1;
		}
	}
}
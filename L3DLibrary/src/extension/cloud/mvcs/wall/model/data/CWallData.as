package extension.cloud.mvcs.wall.model.data
{
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CBoundBox;
	import cloud.core.interfaces.ICLine;
	import cloud.core.utils.CMathUtilForAS;
	
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseEntity3DData;
	import extension.cloud.singles.CL3DGlobalCacheUtil;
	
	/**
	 * 业务墙面数据类
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CWallData extends CBaseEntity3DData implements ICLine
	{
		private var _invalid:Boolean;
		private var _start:Vector3D;
		private var _end:Vector3D;
		private var _thickness:Number;
		private var _length:Number;
		private var _direction:Vector3D;
		private var _center:Vector3D;
		
		public function get start():Vector3D
		{
			return _start;
		}
		public function set start(value:Vector3D):void
		{
			if(value)
			{
				_start.copyFrom(value);
				_invalid=true;
			}
			else
			{
				_start.setTo(0,0,0);
			}
		}
		public function get end():Vector3D
		{
			return _end;
		}
		public function set end(value:Vector3D):void
		{
			if(value)
			{
				_end.copyFrom(value);
				_invalid=true;
			}
			else
			{
				_end.setTo(0,0,0);
			}
		}
		override public function get length():Number
		{
			return super.length;
		}
		override public function get direction():Vector3D
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
		public function get thickness():Number
		{
			return _thickness;
		}
		public function set thickness(value:Number):void
		{
			_thickness=value;
		}
		
		override public function set outline3DBox(value:CBoundBox):void
		{
			super.outline3DBox=value;
			_outline3DBox.minY=-_thickness*.5*CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
			_outline3DBox.maxY=_thickness*.5*CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
		}
		public function CWallData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID);
			_start=new Vector3D();
			_end=new Vector3D();
			_direction=new Vector3D();
			_thickness=CL3DConstDict.DEFAULT_WALL_WIDTH;
		}
	}
}
package cloud.core.datas.base
{
	import flash.geom.Vector3D;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICLine;
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.utils.CMathUtilForAS;
	
	/**
	 * 线条类
	 * @author	cloud
	 * @date	2018-11-28
	 */
	public class CLine implements ICLine,ICNodeData
	{
		private var _start:Vector3D;
		private var _end:Vector3D;
		private var _center:Vector3D;
		private var _direction:Vector3D;
		private var _length:Number;
		private var _invalid:Boolean;
		private var _uniqueID:String;
		private var _type:uint;
		
		public function CLine()
		{
			_start=new Vector3D();
			_end=new Vector3D();
			_center=new Vector3D();
			_direction=new Vector3D();
			_length=0;
		}
		
		public function get length():Number
		{
			return _length;
		}
		
		public function get start():Vector3D
		{
			return _start;
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
		/**
		 * 获取唯一ID 
		 * @return String
		 * 
		 */		
		public function get uniqueID():String
		{
			return _uniqueID;
		}
		/**
		 * 获取对象数据类型属性 
		 * @return uint
		 * 
		 */		
		public function get type():uint
		{
			return _type;
		}
		/**
		 * 设置对象数据类型属性 
		 * @param value
		 * 
		 */		
		public function set type(value:uint):void
		{
			_type=value;
		}
		/**
		 * 输出字符串格式 
		 * @return String
		 * 
		 */		
		public function toString():String
		{
			return null;
		}
		/**
		 * 克隆 
		 * @return ICData
		 * 
		 */	
		public function clone():ICData
		{
			var clone:CLine=new CLine();
			clone.start=this.start;
			clone.end=this.end;
			clone.type=this.type;
			return clone;
		}
		public function compare(source:ICData):Number
		{
			return 0;
		}
	}
}
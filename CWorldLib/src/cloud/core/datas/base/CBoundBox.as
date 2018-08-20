package cloud.core.datas.base
{
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author	cloud
	 * @date	2018-7-21
	 */
	public class CBoundBox
	{
		private var _invalidBox:Boolean;
		private var _minX:Number;
		private var _maxX:Number;
		private var _minY:Number;
		private var _maxY:Number;
		private var _minZ:Number;
		private var _maxZ:Number;
		private var _center:Vector3D;
		
		public function get minX():Number
		{
			return _minX;
		}
		public function set minX(value:Number):void
		{
			if(_minX!=value)
			{
				_invalidBox=true;
				_minX=value;
			}
		}
		public function get minY():Number
		{
			return _minY;
		}
		public function set minY(value:Number):void
		{
			if(_minY!=value)
			{
				_invalidBox=true;
				_minY=value;
			}
		}
		public function get minZ():Number
		{
			return _minZ;
		}
		public function set minZ(value:Number):void
		{
			if(_minZ!=value)
			{
				_invalidBox=true;
				_minZ=value;
			}
		}
		public function get maxX():Number
		{
			return _maxX;
		}
		public function set maxX(value:Number):void
		{
			if(_maxX!=value)
			{
				_invalidBox=true;
				_maxX=value;
			}
		}
		public function get maxY():Number
		{
			return _maxY;
		}
		public function set maxY(value:Number):void
		{
			if(_maxY!=value)
			{
				_invalidBox=true;
				_maxY=value;
			}
		}
		public function get maxZ():Number
		{
			return _maxZ;
		}
		public function set maxZ(value:Number):void
		{
			if(_maxZ!=value)
			{
				_invalidBox=true;
				_maxZ=value;
			}
		}
		/**
		 * 获取中心点坐标 
		 * @return Vector3D
		 * 
		 */		
		public function get center():Vector3D
		{
			if(_invalidBox)
			{
				_invalidBox=false;
				_center.setTo((_minX+_maxX)*.5,(_minY+_maxY)*.5,(_minZ+_maxZ)*.5);
			}
			return _center;
		}
		
		public function CBoundBox()
		{
			minX=minY=minZ=int.MIN_VALUE;
			maxX=maxY=maxZ=int.MAX_VALUE;
			_center=new Vector3D();
		}
		
		
	}
}
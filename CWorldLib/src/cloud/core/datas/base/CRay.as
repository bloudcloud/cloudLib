package cloud.core.datas.base
{

	/**
	 *  3D射线
	 * @author cloud
	 */
	public class CRay
	{
		private var _originPos:CVector;

		public function get originPos():CVector
		{
			return _originPos;
		}
		public function set originPos(value:CVector):void
		{
			if(value!=null)
				CVector.SetTo(_originPos,value.x,value.y,value.z);
		}

		private var _direction:CVector;

		public function get direction():CVector
		{
			return _direction;
		}
		public function set direction(value:CVector):void
		{
			if(value!=null)
				CVector.SetTo(_direction,value.x,value.y,value.z);
		}

		public function CRay(originPos:CVector = null,direction:CVector = null)
		{
			_originPos = originPos;
			_originPos ||= new CVector();
			_direction = direction;
			_direction ||= new CVector();
		}
		
		public function isEqualByCVector(pos:CVector,dir:CVector):Boolean
		{
			return CVector.Equal(pos,_originPos) && CVector.Equal(dir,_direction);
		}
	}
}
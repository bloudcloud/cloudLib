package cloud.core.utils
{
	import cloud.core.data.CVector;

	/**
	 *  3D射线
	 * @author cloud
	 */
	public class Ray3D
	{
		private var _originPos:CVector;

		public function get originPos():CVector
		{
			return _originPos;
		}

		private var _direction:CVector;

		public function get direction():CVector
		{
			return _direction;
		}

		public function Ray3D(originPos:CVector = null,direction:CVector = null)
		{
			_originPos = originPos;
			_originPos ||= new CVector();
			_direction = direction;
			_direction ||= new CVector();
		}
		
	}
}
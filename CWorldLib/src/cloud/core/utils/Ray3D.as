package cloud.core.utils
{
	import flash.geom.Vector3D;

	/**
	 *  3D射线
	 * @author cloud
	 */
	public class Ray3D
	{
		private var _originPos:Vector3D;

		public function get originPos():Vector3D
		{
			return _originPos;
		}

		private var _direction:Vector3D;

		public function get direction():Vector3D
		{
			return _direction;
		}

		public function Ray3D(originPos:Vector3D = null,direction:Vector3D = null)
		{
			_originPos = originPos;
			_originPos ||= new Vector3D();
			_direction = direction;
			_direction ||= new Vector3D();
		}
		
	}
}
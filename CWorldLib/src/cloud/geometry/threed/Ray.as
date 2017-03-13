package cloud.geometry.threed
{
	import flash.geom.Vector3D;

	/**
	 *  3D射线
	 * @author cloud
	 */
	public class Ray
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

		public function Ray(position:Vector3D = null,direction:Vector3D = null)
		{
			_originPos = position;
			_originPos ||= new Vector3D();
			_direction = direction;
			_direction ||= new Vector3D();
		}
		
	}
}
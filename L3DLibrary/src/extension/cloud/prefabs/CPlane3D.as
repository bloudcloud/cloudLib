package extension.cloud.prefabs
{
	import extension.cloud.dict.CL3DConstDict;

	/**
	 *	平面模型
	 * @author	cloud
	 * @date	2018-6-20
	 */
	public class CPlane3D extends L3DMesh
	{
		private var _roundPoints:Vector.<Number>;

		public function get roundPoints():Vector.<Number>
		{
			return _roundPoints;
		}

		public function set roundPoints(value:Vector.<Number>):void
		{
			_roundPoints = value;
		}
		
		public function CPlane3D()
		{
			super(CL3DConstDict.CLASSNAME_CPLANE3D);
		}

	}
}
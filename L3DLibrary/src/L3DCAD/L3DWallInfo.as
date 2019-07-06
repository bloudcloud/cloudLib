package L3DCAD
{
	import flash.geom.Vector3D;

	public class L3DWallInfo
	{
		public var startPoint:Vector3D = new Vector3D();
		public var endPoint:Vector3D = new Vector3D();
		public var thickness:Number = 240;
		
		public function L3DWallInfo(startPoint:Vector3D, endPoint:Vector3D, thickness:Number)
		{
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			this.thickness = thickness;
		}		
	}
}
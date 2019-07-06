package L3DCAD
{
	import flash.geom.Vector3D;

	public class L3DFurnitureInfo
	{
		public var position:Vector3D = new Vector3D();
		public var size:Vector3D = new Vector3D();
		public var offGround:Number = 0;
		public var rotation:Number = 0;
		public var catalog:int = 0;
		public var type:int = 0;
		public var linkedWall:* = null;
		
		public function L3DFurnitureInfo()
		{
			
		}
	}
}
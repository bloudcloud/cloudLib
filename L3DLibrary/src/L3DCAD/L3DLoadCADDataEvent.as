package L3DCAD
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class L3DLoadCADDataEvent extends Event
	{
		public static const LOADCAD:String="LoadCADData";		
		private var bitmap:BitmapData = null;
		private var points:Vector.<Vector3D> = null;
		private var wallLines:Vector.<L3DWallInfo> = null;
		private var furnitures:Vector.<L3DFurnitureInfo> = null;
		private var ratio:Number = 1.0;
		private var edgeSpace:Number = 0;
		
		public function L3DLoadCADDataEvent(bitmap:BitmapData, points:Vector.<Vector3D>, wallLines:Vector.<L3DWallInfo>, furnitures:Vector.<L3DFurnitureInfo>, ratio:Number, edgeSpace:Number)
		{
			super(LOADCAD);
			this.bitmap = bitmap;			
			this.points = points;
			this.wallLines = wallLines;
			this.furnitures = furnitures;
			this.ratio = ratio;
			this.edgeSpace = edgeSpace;
		}
		
		public function get Bitmap():BitmapData
		{
			return bitmap;
		}
		
		public function get Points():Vector.<Vector3D>
		{
			return points;
		}
		
		public function get WallLines():Vector.<L3DWallInfo>
		{
			return wallLines;
		}
		
		public function get Furnitures():Vector.<L3DFurnitureInfo>
		{
			return furnitures;
		}
		
		public function get Ratio():Number
		{
			return ratio;
		}
		
		public function get EdgeSpace():Number
		{
			return edgeSpace;
		}
		
		public function get Edge():Number
		{
			return edgeSpace * ratio;
		}
	}
}
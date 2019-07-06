package L3DClipRegion
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class L3DClipRegion extends EventDispatcher
	{
		private var points:Vector.<Point> = new Vector.<Point>();
		private var cutLines:Vector.<L3DClipLine> = new Vector.<L3DClipLine>();
		private var area:Number = 0;
		
		public function L3DClipRegion()
		{
			
		}
		
		public function get Exist():Boolean
		{
			return points.length == 3 || points.length == 4;
		}
		
		public function Clear():void
		{
			if(points.length > 0)
			{
				points.length = 0;
			}
			if(cutLines.length > 0)
			{
				cutLines.length = 0;
			}
		}
		
		public function get Points():Vector.<Point>
		{
			return points;
		}
		
		public function set Points(v:Vector.<Point>):void
		{
			points = v;
		}
		
		public function get RectCuts():Vector.<L3DClipLine>
		{
			return cutLines;
		}
		
		public function get RectArea():Number
		{
			if(points.length < 3)
			{
				return 0;
			}
			if(area > 0)
			{
				return area;
			}
			area = 0;
			for(var i:int=0;i<points.length - 2; i++)
			{
				var v0:Vector3D = new Vector3D(points[0].x, points[0].y, 0);
				var v1:Vector3D = new Vector3D(points[i + 1].x, points[i + 1].y, 0);
				var v2:Vector3D = new Vector3D(points[i + 2].x, points[i + 2].y, 0);
				area += L3DUtils.CompuFaceArea(v0, v1, v2);
			}
			return area;
		}
		
		public function set RectArea(v:Number):void
		{
			area = v;
		}
	}
}
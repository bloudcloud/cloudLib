package L3DClipRegion
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class L3DClipLine extends EventDispatcher
	{
		private var start:Point = new Point();
		private var end:Point = new Point();
		
		public function L3DClipLine(start:Point = null, end:Point = null)
		{
			if(start != null)
			{
			    this.start = start.clone();
			}
			if(end != null)
			{
			    this.end = end.clone();
			}
		}
		
		public function Clear():void
		{
			start = new Point();
			end = new Point();
		}
		
		public function get Start():Point
		{
			return start;
		}
		
		public function set Start(v:Point):void
		{
			start=v;
		}
		
		public function get End():Point
		{
			return end;
		}
		
		public function set End(v:Point):void
		{
			end=v;
		}
	}
}
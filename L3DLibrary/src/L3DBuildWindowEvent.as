package 
{
	import flash.events.Event;
	
	public class L3DBuildWindowEvent extends Event
	{
		public static  const BUILDWINDOW:String="BuildWindows";
		public var info:String;
		public var model:L3DMesh;
		public var windowLength:int;
		public var windowHeight:int;
		public var offGroundHeight:int;
		public var floatDistance:int;
		public var leftWindowLength:int;
		public var rightWindowLength:int;
		
		public function L3DBuildWindowEvent(type:String, info:String, model:L3DMesh, windowLength:int, windowHeight:int, offGroundHeight:int, floatDistance:int, leftWindowLength:int = 0, rightWindowLength:int = 0) 
		{		
			super(type);
			this.info = info;
			this.model = model;
			this.windowLength = windowLength;
			this.windowHeight = windowHeight;
			this.offGroundHeight = offGroundHeight;
			this.floatDistance = floatDistance;
			this.leftWindowLength = leftWindowLength;
			this.rightWindowLength = rightWindowLength;
		}		
	}
}
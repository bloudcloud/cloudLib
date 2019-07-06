package utils.lx.views
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class DebugSpriteManager
	{
		private static var displays:Array = [];
		
		public function DebugSpriteManager()
		{
		}
		
		public static function startEnterFrame(main:DisplayObject):void
		{
			main.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private static function enterFrameHandler(e:Event):void
		{
		}
		
		public static function add(display:DebugSprite):void
		{
			if(!display)
				return;
			var index:int = getIndex(display.name);
			if(index<0)
			{
				displays.push(display);
			}
		}
		
		public static function remove(display:DebugSprite):void
		{
			if(!display)
				return;
			var index:int = getIndex(display.name);
			if(index>-1)
			{
				displays.splice(index,1);
			}
		}
		
		private static function getIndex(name:String):int
		{
			for (var i:int = 0; i < displays.length; i++) 
			{
				if(displays[i].name==name)
				{
					return i;
				}
			}
			return -1;
		}
	}
}
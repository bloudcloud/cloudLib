package utils.lx.views
{
	import flash.display.Sprite;
	
	public class DebugSprite extends Sprite
	{
		public var color:uint = 0xff0000;
		
		public function DebugSprite()
		{
			super();
			DebugSpriteManager.add(this);
		}
		
		public function showcColor():void
		{
			graphics.beginFill(color);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		public function hideColor():void
		{
			graphics.clear();
		}
	}
}
package extension.wl.utils
{
	import flash.events.MouseEvent;

	public class MouseUtils
	{
		public function MouseUtils()
		{
			
		}
		
		/**
		 * 阻止鼠标击穿方法 
		 * @param event
		 * 
		 */		
		public static function stopMouseEvent(event:MouseEvent):void 
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
	}
}
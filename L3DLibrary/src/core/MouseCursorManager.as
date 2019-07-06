package core 
{
	import mx.managers.CursorManager;

	/**
	 * acydan
	 * L3DTilingSystem
	 * Created 2017-3-15 	 
	 * 
	 */
	public class MouseCursorManager
	{
		private static var _instance:MouseCursorManager;
		
		public static function get instance():MouseCursorManager{
			if(!_instance){
				_instance = new MouseCursorManager;
			}
			return _instance;
		}
		
		[Embed(source="assets/mouse/1.png")]
		private var DrawWallIcon1:Class;
		[Embed(source="assets/mouse/2.png")]
		private var DrawWallIcon2:Class;
		[Embed(source="assets/mouse/3.png")]
		private var DrawWallIcon3:Class;
		[Embed(source="assets/mouse/4.png")]
		private var DrawWallIcon4:Class;
		[Embed(source="assets/mouse/5.png")]
		private var DrawWallIcon5:Class;
		[Embed(source="assets/mouse/6.png")]
		private var DrawWallIcon6:Class;
		[Embed(source="assets/mouse/7.png")]
		private var DrawWallIcon7:Class;
		[Embed(source="assets/mouse/8.png")]
		private var DrawWallIcon8:Class;
		[Embed(source="assets/mouse/9.png")]
		private var DrawWallIcon9:Class;
		[Embed(source="assets/mouse/10.png")]
		private var DrawWallIcon10:Class;
		[Embed(source="assets/mouse/11.png")]
		private var DrawWallIcon11:Class;
		[Embed(source="assets/mouse/12.png")]
		private var DrawWallIcon12:Class;
		[Embed(source="assets/mouse/13.png")]
		private var DrawWallIcon13:Class;
		[Embed(source="assets/mouse/14.png")]
		private var DrawWallIcon14:Class;
		[Embed(source="assets/mouse/15.png")]
		private var DrawWallIcon15:Class;
		
		public function MouseCursorManager()
		{
		}
		
		public function setMouseType(index:int=0):void
		{
			switch(index)
			{
				case 0:
					CursorManager.removeAllCursors();
					break;
				case 1:
					CursorManager.setCursor(DrawWallIcon1,2,-int(new DrawWallIcon1().width/2),-int(new DrawWallIcon1().height/2));
					break;
				case 2:
					CursorManager.setCursor(DrawWallIcon2,2,-int(new DrawWallIcon2().width/2),-int(new DrawWallIcon2().height/2));
					break;
				case 3:
					CursorManager.setCursor(DrawWallIcon3,2,-int(new DrawWallIcon3().width/2),-int(new DrawWallIcon3().height/2));
					break;
				case 4:
					CursorManager.setCursor(DrawWallIcon4);
					break;
				case 5:
					CursorManager.setCursor(DrawWallIcon5);
					break;
				case 6:
					CursorManager.setCursor(DrawWallIcon6,2,-int(new DrawWallIcon6().width/2),-int(new DrawWallIcon6().height/2));
					break;
				case 7:
					CursorManager.setCursor(DrawWallIcon7,2,-int(new DrawWallIcon7().width/2),-int(new DrawWallIcon7().height/2));
					break;
				case 8:
					CursorManager.setCursor(DrawWallIcon8,2,-int(new DrawWallIcon8().width/2),-int(new DrawWallIcon8().height/2));
					break;
				case 9:
					CursorManager.setCursor(DrawWallIcon9);
					break;
				case 10:
					CursorManager.setCursor(DrawWallIcon10);
					break;
				case 11:
					CursorManager.setCursor(DrawWallIcon11);
					break;
				case 12:
					CursorManager.setCursor(DrawWallIcon12);
					break;
				case 13:
					CursorManager.setCursor(DrawWallIcon13);
					break;
				case 14:
					CursorManager.setCursor(DrawWallIcon14);
					break;
				case 15:
					CursorManager.setCursor(DrawWallIcon15);
					break;
				case 16:
					CursorManager.removeAllCursors();
					CursorManager.setBusyCursor();
					break;
				default:
					CursorManager.removeAllCursors();
					break;
			}
		}
	}
}
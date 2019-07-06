package utils
{
	public class ViewStyle
	{
		/**样式1*/
		public static const Style1:int = 1;
		/**样式2*/
		public static const Style2:int = 2;
		
		private static var _currentStyle:int = 1;
		
		public function ViewStyle()
		{
		}
		
		public function changeStyle(value:int):void
		{
			switch(value)
			{
				case 1:
				case 2:
					_currentStyle = value;
					break;
				default:
					_currentStyle = 1;
					break;
			}
		}
	}
}
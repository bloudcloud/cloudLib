package extension.wl.utils
{
	import flash.geom.Point;

	public class PixelUtils
	{
		public static const RESOLUTION_72:int = 72;//分辨率
		public static const RESOLUTION_96:int = 96;
		public static const RESOLUTION_300:int = 300;
		
		public static const INCH_TO_MM:Number = 25.4;//英寸转毫米
		public static const SQRT2:Number = 1.414;//根号2的值
		public static var PADDING:int = 10;//边距
		
		public function PixelUtils()
		{
			
		}
		/**
		 * 获取像素值的尺寸
		 * @param v point.x宽度；point.y高度；单位毫米
		 * @param resolution 分辨率
		 * @return point.x为像素宽度，point.y为像素高度
		 * 
		 */		
		public static function getPixelSide(v:Point, padding:int, resolution:int = RESOLUTION_300):Point
		{
			var px:int = getPixel(v.x - padding * 2);
			var py:int = getPixel(v.y - padding * 2);
			return new Point(px,py);
		}
		
		public static function getPixel(v:int, resolution:int = RESOLUTION_300):int
		{
			return int(v * resolution / INCH_TO_MM);
		}
		/**
		 * 获取A组纸张的宽高，单位为毫米
		 * @param v int
		 * @return point.x为宽度，point.y为高度
		 * 
		 */		
		public static function getAside(v:int = 4):Point
		{
			var aWidth:int = 841;
			var aHeight:int = Math.floor(aWidth * SQRT2);
			while(v)
			{
				var tempH:int = aWidth;
				aWidth = Math.floor(aHeight >> 1);
				aHeight = tempH;
				v--;
			}
			
			return new Point(aWidth,aHeight);
		}
		/**
		 * 获取B组纸张的宽高，单位为毫米
		 * @param v int
		 * @return point.x为宽度，point.y为高度
		 * 
		 */	
		public static function getBside(v:int = 4):Point
		{
			var aWidth:int = 1000;
			var aHeight:int = Math.floor(aWidth * SQRT2);
			while(v)
			{
				var tempH:int = aWidth;
				aWidth = Math.floor(aHeight >> 1);
				aHeight = tempH;
				v--;
			}
			
			return new Point(aWidth,aHeight);
		}
		/**
		 * 获取C组纸张的宽高，单位为毫米
		 * @param v int
		 * @return point.x为宽度，point.y为高度
		 * 
		 */		
		public static function getCside(v:int = 4):Point
		{
			var aWidth:int = Math.round(Math.sqrt(getAside(0).x * getBside(0).x));
			var aHeight:int = Math.round(Math.sqrt(getAside(0).y * getBside(0).y));
			while(v)
			{
				var tempH:int = aWidth;
				aWidth = Math.floor(aHeight >> 1);
				aHeight = tempH;
				v--;
			}
			return new Point(aWidth,aHeight);
		}
		
	}
}
package extension.wl.utils
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	public class BitmapDataUtils
	{
		/**
		 * 平移一个位图
		 * @param bmpData 位图
		 * @param tx 水平位移
		 * @param ty 垂直位移
		 * @param transparent 
		 * @param fillColor
		 * @return BitmapData 新位图
		 * 
		 */		
		public static function moveBitmapData(bmpData:BitmapData, tx:Number,ty:Number, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.tx = tx;
			matrix.ty = ty;
			var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		
		/**
		 * 水平翻转一个位图
		 * @param bmpData 位图
		 * @param transparent
		 * @param fillColor
		 * @return 
		 * 
		 */		
		public static function flipHorizontal(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.a = -1;
			matrix.tx = bmpData.width;
			var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		/**
		 * 垂直翻转一个位图
		 * @param bmpData
		 * @param transparent
		 * @param fillColor
		 * @return 
		 * 
		 */		
		public static function flipVertical(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.d = -1;
			matrix.ty = bmpData.height;
			var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		/**
		 * 缩放位图
		 * @param bmpData
		 * @param scaleX 水平缩放比例
		 * @param scaleY 垂直缩放比例
		 * @param transparent
		 * @param fillColor
		 * @return 
		 * 
		 */		
		public static function scaleBitmapData(bmpData:BitmapData, scaleX:Number, scaleY:Number, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			var bmpData_:BitmapData = new BitmapData(scaleX * bmpData.width, scaleY * bmpData.height, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		/**
		 * 旋转位图 向右90度
		 * @param bmpData
		 * @param transparent
		 * @param fillColor
		 * @return 
		 * 
		 */		
		public static function rotateRight90BitmapData(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math.PI/2);
			matrix.translate(bmpData.height,0);
			var bmpData_:BitmapData = new BitmapData(bmpData.height, bmpData.width, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		/**
		 * 旋转位图 向左90度
		 * @param bmpData
		 * @param transparent
		 * @param fillColor
		 * @return 
		 * 
		 */		
		public static function rotateLeft90BitmapData(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate(-Math.PI/2);
			matrix.translate(0,bmpData.width);
			var bmpData_:BitmapData = new BitmapData(bmpData.height, bmpData.width, transparent, fillColor);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		/**
		 * BitmapData位图转为JPEG图片 
		 * @param bitmapData
		 * @param quanlity
		 * @return 
		 * 
		 */		
		public static function BitmapDataToJPEGBuffer(bitmapData:BitmapData, quanlity:int = 100):ByteArray
		{
			if(bitmapData == null)
			{
				return null;
			}	
			
			var jpegEncoderOptions:JPEGEncoderOptions = new JPEGEncoderOptions(quanlity);
			return bitmapData.encode(bitmapData.rect,jpegEncoderOptions);
		}
		
		/**
		 * BitmapData位图转为PNG图片 
		 * @param bitmapData
		 * @param quanlity
		 * @return 
		 * 
		 */		
		public static function BitmapDataToPNGBuffer(bitmapData:BitmapData, quanlity:int = 100):ByteArray
		{
			if(bitmapData == null)
			{
				return null;
			}	
			
			var pngEncoderOptions:PNGEncoderOptions = new PNGEncoderOptions();
			return bitmapData.encode(bitmapData.rect,pngEncoderOptions);
		}
		
	}
}
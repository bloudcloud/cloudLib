package extension.cloud.a3d.resources
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import alternativa.engine3d.alternativa3d;
	
	import extension.cloud.interfaces.ICNameResource;
	
	use namespace alternativa3d;
	/**
	 * 基础位图纹理资源类
	 * @author cloud
	 */
	public class CBitmapTextureResource extends CTextureResource implements ICNameResource
	{
		static private const rect:Rectangle = new Rectangle();
		static private const filter:ConvolutionFilter = new ConvolutionFilter(2, 2, [1, 1, 1, 1], 4, 0, false, true);
		static private const matrix:Matrix = new Matrix(0.5, 0, 0, 0.5);
		static private const resizeMatrix:Matrix = new Matrix(1, 0, 0, 1);
		static private const point:Point = new Point();
		/**
		 * BitmapData
		 */
		private var _data:BitmapData;
		
		public function get data():BitmapData
		{
			return _data;
		}
		public function set data(value:BitmapData):void
		{
			_data=value;
		}
		/**
		 * 是否是空的位图纹理对象 
		 * @return Boolean
		 * 
		 */		
		public function get isEmpty():Boolean
		{
			return _data==null;
		}
		
		public var isSystemMode:Boolean;
		public var resizeForGPU:Boolean = false;
		
		/**
		 * Uploads textures from <code>BitmapData</code> to GPU.
		 */
		public function CBitmapTextureResource(data:BitmapData, resizeForGPU:Boolean = false) {
			this.data = data;
			this.resizeForGPU = resizeForGPU;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function upload(context3D:Context3D):void {
			if (_texture != null) _texture.dispose();
			if (data != null) {
				var source:BitmapData = data;
				if (resizeForGPU) {
					var wLog2Num:Number = Math.log(data.width)/Math.LN2;
					var hLog2Num:Number = Math.log(data.height)/Math.LN2;
					var wLog2:int = Math.ceil(wLog2Num);
					var hLog2:int = Math.ceil(hLog2Num);
					if (wLog2 != wLog2Num || hLog2 != hLog2Num || wLog2 > 11 || hLog2 > 11) {
						// Resize bitmap
						wLog2 = (wLog2 > 11) ? 11 : wLog2;
						hLog2 = (hLog2 > 11) ? 11 : hLog2;
						source = new BitmapData(1 << wLog2, 1 << hLog2, data.transparent, 0x0);
						resizeMatrix.a = (1 << wLog2)/data.width;
						resizeMatrix.d = (1 << hLog2)/data.height;
						source.draw(data, resizeMatrix, null, null, null, true);
					}
				}
				try{ 
					_texture = context3D.createTexture(source.width, source.height, Context3DTextureFormat.BGRA, false);
					//_texture会变成空
					Texture(_texture).uploadFromBitmapData(source, 0);
					filter.preserveAlpha = !source.transparent;
					var level:int = 1;
					var bmp:BitmapData = new BitmapData(source.width, source.height, source.transparent);
					var current:BitmapData = source;
					rect.width = source.width;
					rect.height = source.height;
					while (rect.width%2 == 0 || rect.height%2 == 0) {
						bmp.applyFilter(current, rect, point, filter);
						rect.width >>= 1;
						rect.height >>= 1;
						if (rect.width == 0) rect.width = 1;
						if (rect.height == 0) rect.height = 1;
						if (current != source) current.dispose();
						current = new BitmapData(rect.width, rect.height, source.transparent, 0);
						current.draw(bmp, matrix, null, null, null, false);
						Texture(_texture).uploadFromBitmapData(current, level++);
					}
					if (current != source) current.dispose();
					bmp.dispose();
				}catch(e:Error)
				{
					//偶尔会报错   ArgumentError: Error #3759: 选定的纹理格式在此配置文件中无效。
				}
			} else {
				_texture = null;
				throw new Error("Cannot upload without data");
			}
		}
		
		/**
		 * @private
		 * TODO: remove repeated method.
		 */
		alternativa3d function createMips(texture:Texture, bitmapData:BitmapData):void {
			rect.width = bitmapData.width;
			rect.height = bitmapData.height;
			var level:int = 1;
			var bmp:BitmapData = new BitmapData(rect.width, rect.height, bitmapData.transparent);
			var current:BitmapData = bitmapData;
			while (rect.width%2 == 0 || rect.height%2 == 0) {
				bmp.applyFilter(current, rect, point, filter);
				rect.width >>= 1;
				rect.height >>= 1;
				if (rect.width == 0) rect.width = 1;
				if (rect.height == 0) rect.height = 1;
				if (current != bitmapData) current.dispose();
				current = new BitmapData(rect.width, rect.height, bitmapData.transparent, 0);
				current.draw(bmp, matrix, null, null, null, false);
				texture.uploadFromBitmapData(current, level++);
			}
			if (current != bitmapData) current.dispose();
			bmp.dispose();
		}
		
		/**
		 * @private 
		 */
		static alternativa3d function createMips(texture:Texture, bitmapData:BitmapData):void {
			rect.width = bitmapData.width;
			rect.height = bitmapData.height;
			var level:int = 1;
			var bmp:BitmapData = new BitmapData(rect.width, rect.height, bitmapData.transparent);
			var current:BitmapData = bitmapData;
			while (rect.width%2 == 0 || rect.height%2 == 0) {
				bmp.applyFilter(current, rect, point, filter);
				rect.width >>= 1;
				rect.height >>= 1;
				if (rect.width == 0) rect.width = 1;
				if (rect.height == 0) rect.height = 1;
				if (current != bitmapData) current.dispose();
				current = new BitmapData(rect.width, rect.height, bitmapData.transparent, 0);
				current.draw(bmp, matrix, null, null, null, false);
				texture.uploadFromBitmapData(current, level++);
			}
			if (current != bitmapData) current.dispose();
			bmp.dispose();
		}
		
		override protected function doDisposeAll():void
		{
			super.doDisposeAll();
			data=null;
		}
		override public function clear():void
		{
			dispose();
			super.clear();
		}

	}
}



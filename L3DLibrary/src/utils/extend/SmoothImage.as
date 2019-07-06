package utils.extend
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.controls.Image;
	
	// 该扩展的Image空间可以对图片进行抗锯齿处理
	public class SmoothImage extends Image
	{
		
		private var pictLdr:Loader;
		
		public function SmoothImage()
		{
			super();
			pictLdr = new Loader();
			pictLdr.contentLoaderInfo.addEventListener(Event.INIT, loaderInit);
		}
		
		private function startLoadImg(value:Object):void{
			pictLdr.load(new URLRequest(value.toString()));
		}
		
		private function loaderInit(event:Event):void{
			
			var myDataBitmap:BitmapData = new BitmapData(pictLdr.width,pictLdr.height,true, 0x00ffffff);
			myDataBitmap.draw(pictLdr);
			var myBitmap:Bitmap = new Bitmap(myDataBitmap,"auto",true);
			super.source = myBitmap;
		}
		
		public override function set source(value:Object):void {
			if(value) {
				startLoadImg(value);
			}
		}
		
	}
}
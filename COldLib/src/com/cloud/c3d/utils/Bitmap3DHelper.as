package com.cloud.c3d.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//云小菜
	public class Bitmap3DHelper
	{
		public function Bitmap3DHelper()
		{
		}
		
		public static function transitionBillBoard(sourceBD:BitmapData):BitmapData
		{
			var max:int = sourceBD.width < sourceBD.height ? sourceBD.height : sourceBD.width;
			var powNum:int;
			var newBD:BitmapData;
			var rect:Rectangle;
			var point:Point;
			for(var i:int = 0; i < 11; i++)
			{
				powNum = Math.pow(2,i);
				if(max <= powNum)
				{
					rect = new Rectangle(0,0,sourceBD.width,sourceBD.height);
					point = new Point(powNum - max >> 1,0);
					newBD = new BitmapData(powNum,powNum,true,0);
					newBD.copyPixels(sourceBD,rect,point);
					break;
				}
					
			}
			return newBD;
		}
	}
}
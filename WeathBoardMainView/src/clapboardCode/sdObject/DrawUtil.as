package clapboardCode.sdObject
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.graphics.BitmapFill;
	import mx.graphics.BitmapFillMode;
	
	import spark.components.Group;
	import spark.primitives.Graphic;
	import spark.primitives.Path;
	
	import alternativa.engine3d.core.DrawUnit;
	
	import clapboardCode.components.WallBoardRectangle;
	

	public class DrawUtil
	{
		private static var _Instance:DrawUtil;
		
		public static function get Instance():DrawUtil
		{
			return _Instance||=new DrawUtil();
		}
		
		public function DrawUtil()
		{
		}
		
		public function drawSVGCornerUnit(parentView:UIComponent,svgBitmap:BitmapData,svgPath:String,unitLength:Number,unitHeight:Number,cornerLength:Number,cornerHeight:Number,scale:Number,point:Point):void
		{
			var svgCorner:WallBoardRectangle;
			var svgGroup:Graphic;
			var svgRotation:Number = 0;
			for(var i = 0; i < 4; i++)
			{
				svgGroup = new Graphic(); 
				var path4:Path = new Path();
				path4.data = svgPath;
				path4.width = cornerLength;
				path4.height = cornerHeight;
				var bitmapFill4:BitmapFill = new BitmapFill();
				bitmapFill4.source = svgBitmap;
				bitmapFill4.fillMode = BitmapFillMode.REPEAT;
				path4.fill=bitmapFill4;
				path4.winding = GraphicsPathWinding.EVEN_ODD;
				svgGroup.addElement(path4);
				svgGroup.width = cornerLength/scale;
				svgGroup.height = cornerHeight/scale;
				svgGroup.validateNow();
				switch(i)
				{
					case 0:
						svgRotation =0;
						svgGroup.x = 0;
						svgGroup.y = 0;
						break;
					case 1:
						svgRotation =90;
						svgGroup.x = unitLength/scale -cornerLength/scale;
						svgGroup.y = 0;
						break;
					case 2:
						svgRotation =180;

						svgGroup.x = unitLength/scale -cornerLength/scale;
						svgGroup.y = unitHeight/scale-cornerHeight/scale;
						break;
					case 3:
						svgRotation =270;
						svgGroup.x = 0;
						svgGroup.y = unitHeight/scale-cornerHeight/scale;
						break;
				}
				svgGroup.x +=point.x/scale;
				svgGroup.y += point.y/scale;
				svgGroup.scaleX = svgGroup.scaleY = 1;
				svgGroup.rotation = svgRotation;
				parentView.addChild(svgGroup);
			}
//			svgCorner=new WallBoardRectangle();
//			svgGroup = svgCorner.(source,path,0);
//			unit.addElement(svgGroup);
//			
//			svgCorner=new WallBoardRectangle();
//			svgGroup = svgCorner.(source,path,1);
//			unit.addElement(svgGroup);
//			
//			svgCorner=new WallBoardRectangle();
//			svgGroup = svgCorner.(source,path,2);
//			unit.addElement(svgGroup);
//			
//			svgCorner=new WallBoardRectangle();
//			svgGroup = svgCorner.(source,path,3);
//			unit.addElement(svgGroup);
//			var bitmapData:BitmapData=new BitmapData(unitLength,unitHeight);
//			bitmapData.draw(unit);
//			var bitmap:Bitmap=new Bitmap(bitmapData);
		}
	}
}
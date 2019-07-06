package
{
	import flash.geom.Point;
	
	import pl.bmnet.gpcas.geometry.Poly;
	import pl.bmnet.gpcas.geometry.PolyDefault;
	import pl.bmnet.gpcas.geometry.PolySimple;
	
	public class PolyParser
	{
		private const linePattern:RegExp = /\s{0,}([0-9]*\.?[0-9]+)\s{1,}([0-9]*\.?[0-9]+)\s{0,}/i;
		
		private var lines : Array;
		private var index : int = -1;
		
		public function PolyParser()
		{
		}
		
		public function readNextLine():String{
			index++;
			if (index<lines.length){
				return lines[index];
			}
			return null;
		}
		
		public var offsetX : Number = 0;
		public var offsetY : Number = 0;
		public var mirrorOffsetX : Number = -1;
		public var mirrorOffsetY : Number = -1;
		public var scale : Number = 1;
		
		
		private function readPoly():Poly{
			var pointsCount : int = parseInt(readNextLine());
			var res : PolySimple = new PolySimple();
			for (var i : int = 0; i<pointsCount; i++){
				var line:String = readNextLine();
				if (line!=null){
					var pointsArr : Array = linePattern.exec(line);
					if ((pointsArr!=null)&&(pointsArr.length==3)){
						var x : int = parseFloat(pointsArr[1])+offsetX;
						var y : int = parseFloat(pointsArr[2])+offsetY;
						if (mirrorOffsetX>=0) x=mirrorOffsetX-x;
						if (mirrorOffsetY>=0) y=mirrorOffsetY-y;
						if (scale!=1){
							x=x*scale;
							y=y*scale;
						}
						res.addPoint(new Point(x,y));
					}
				}
			}
			return res;
		}
		
		public function readGPFString(str:String):Poly{
			var res :PolyDefault = new PolyDefault();
			lines = str.split("\n");
			index=-1;	
			var polyCount : int = parseInt(readNextLine());
			for (var i : int = 0; i<polyCount; i++){
				var poly : Poly = readPoly();
				res.addPoly(poly);
			}
			return res;
		}
	}
}
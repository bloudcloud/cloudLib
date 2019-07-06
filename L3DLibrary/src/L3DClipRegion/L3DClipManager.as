package L3DClipRegion
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import L3DLibrary.L3DLibraryEvent;
	
	import model.geom.GeomUtil;
	
	import utils.lx.managers.GlobalManager;
	
	public class L3DClipManager extends EventDispatcher
	{
		private var refPoint:Point=new Point;
		private var userData:* = null;
		public static const CutRectRegionComplete:String = "CutRectRegionComplete";
		
		public function L3DClipManager()
		{
			
		}
		
		public static function IsRectangle(points:Array):Boolean
		{
			if(points == null || points.length != 4)
			{
				return false;
			}
			
			for(var i:int=0;i<points.length;i++)
			{
				var s:Point = points[i];
				var e:Point = i == points.length - 1 ? points[0] : points[i+1];
				var l:Point = i == 0 ? points[points.length - 1] : points[i-1];
				var td:Vector3D = new Vector3D(e.x-s.x,e.y-s.y,0);
				td.normalize();
				var ld:Vector3D = new Vector3D(l.x-s.x,l.y-s.y,0);
				ld.normalize();
				if(td.dotProduct(ld) > 0.01)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function RectangleCutting(points:Array, userData:* = null):void
		{
			if(points == null || points.length < 4)
			{
				var evt:L3DLibraryEvent = new L3DLibraryEvent(CutRectRegionComplete);
				evt.data = null;
				this.dispatchEvent(evt);
			}
			
			this.userData = userData;
			
		/*	for(var i:int = 0; i<points.length; i++)
			{
				points[i].x = Number(int(points[i].x + 0.5));
				points[i].y = Number(int(points[i].y + 0.5));
			} */
			
			if(!GeomUtil.isAntiClockWise(points))
			{
				points.reverse();
			}
			var xMin:Number = 0;
			var yMin:Number = 0;
			for (var i:int = 0; i < points.length; i++) 
			{
				if(i == 0)
				{
					xMin = points[i].x;
					yMin = points[i].y;
//					refPoint = points[0].clone();
				}
				else
				{
					xMin = Math.min(xMin,points[i].x);
					yMin = Math.min(yMin,points[i].y);
//					if(points[i].x < refPoint.x)
//					{
//						refPoint.x = points[i].x;
//					}
//					if(points[i].y < refPoint.y)
//					{
//						refPoint.y = points[i].y;
//					}
				}
			}
			refPoint.x = xMin<0?Math.abs(xMin-10):10;
			refPoint.y = yMin<0?Math.abs(yMin-10):10;
			var xml:XML=<Lejia Type="RoomEdge"></Lejia>;
			for (var j:int = 0; j < points.length; j++) 
			{
				var endPoint:Point = j==points.length - 1 ? points[0] : points[j+1];
				var type:String="Line";
				var pointXml:XML = <Elem id={j} type={type}></Elem>;
				var valueXml:XML = <value stPointX={points[j].x + refPoint.x} stPointY={points[j].y + refPoint.y} edPointX={endPoint.x + refPoint.x} edPointY={endPoint.y + refPoint.y}/>;
				pointXml=pointXml.appendChild(valueXml);
				xml.appendChild(pointXml);
			}
			
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.ExInRec(xml.toString());
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(ExInRecResult, ExInRecFault);
//			atObj.addResponder(rpObj);

//			 lrj 2017/12/7 
			GlobalManager.Instance.serviceMGR.exInRec(ExInRecResult,ExInRecFault, xml.toString());
		}
		
		private function ExInRecResult(reObj:ResultEvent):void
		{
			var outXml:XML = XML(reObj.result);
			if(outXml == null)
			{
				var evt1:L3DLibraryEvent = new L3DLibraryEvent(CutRectRegionComplete);
				evt1.data = null;
				this.dispatchEvent(evt1);
				return;
			}
			
			var clipRegions:Vector.<L3DClipRegion> = new Vector.<L3DClipRegion>();

			for (var i:int = 0; i < outXml.Elem.length(); i++) 
			{
				var rectXml:XML=outXml.Elem[i];
				var rect:L3DClipRegion=new L3DClipRegion();
				var slope:Number;			
				
				var cpoints:Vector.<Point> = new Vector.<Point>();
				var minPoint:Point = new Point();
				var maxPoint:Point = new Point();
				for (var j:int = 0; j < rectXml.MainCoordinate.length(); j++) 
				{
					var cpoint:Point = new Point(Number(rectXml.MainCoordinate[j].@X)-refPoint.x,Number(rectXml.MainCoordinate[j].@Y)-refPoint.y);
					cpoints.push(cpoint);
					if(j == 0)
					{
						minPoint = cpoint.clone();
						maxPoint = cpoint.clone();
					}
					else
					{
						minPoint.x = cpoint.x < minPoint.x ? cpoint.x : minPoint.x;
						minPoint.y = cpoint.y < minPoint.y ? cpoint.y : minPoint.y;
						maxPoint.x = cpoint.x > maxPoint.x ? cpoint.x : maxPoint.x;
						maxPoint.y = cpoint.y > maxPoint.y ? cpoint.y : maxPoint.y;
					}
				}
				
				if(cpoints.length < 4)
				{
					continue;
				}
				
				var points:Vector.<Point>=new Vector.<Point>();
				points.push(new Point(minPoint.x, minPoint.y));
				points.push(new Point(minPoint.x, maxPoint.y));
				points.push(new Point(maxPoint.x, maxPoint.y));
				points.push(new Point(maxPoint.x, minPoint.y));
				
				rect.Points=points;
				
				for (var k:int = 0; k < rectXml.comEdge.length(); k++) 
				{
					var start:Point=new Point(Number(rectXml.comEdge[k].@stX)-refPoint.x,Number(rectXml.comEdge[k].@stY)-refPoint.y);
					var end:Point=new Point(Number(rectXml.comEdge[k].@edX)-refPoint.x,Number(rectXml.comEdge[k].@edY)-refPoint.y);
					rect.RectCuts.push(new L3DClipLine(start,end));
				}
				clipRegions.push(rect);
			}
			
			if(clipRegions.length == 0)
			{
				var evt2:L3DLibraryEvent = new L3DLibraryEvent(CutRectRegionComplete);
				evt2.data = null;
				this.dispatchEvent(evt2);
				return;
			}
			
			var evt:L3DLibraryEvent = new L3DLibraryEvent(CutRectRegionComplete);
			evt.data = clipRegions;
			evt.data2 = userData;
			this.dispatchEvent(evt);
		}
		
		private function ExInRecFault(feObj:FaultEvent):void
		{
			var evt:L3DLibraryEvent = new L3DLibraryEvent(CutRectRegionComplete);
			evt.data = null;
			this.dispatchEvent(evt);
		}
	}
}
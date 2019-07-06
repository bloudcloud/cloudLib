package utils.poly2tri {
	import flash.utils.Dictionary;
	public class Edge {
		public var p:PPoint;
		public var q:PPoint;

		/// Constructor
		public function Edge(p1:PPoint, p2:PPoint) {
			if (p1 === null) throw(new Error("p1 is null"));
			if (p2 === null) throw(new Error("p2 is null"));
			
			var swap:Boolean = false;
			
			if (p1.y > p2.y) {
				swap = true;
			} else if (p1.y == p2.y)
			{
				if (p1.x == p2.x)
				{
					//throw(new Error("Repeat points"));
				}

				swap = (p1.x > p2.x);
			} else {
				swap = false;
			}
			
			if (swap) {
				this.q = p1;
				this.p = p2;
			} else {
				this.p = p1;
				this.q = p2;
			}

			this.q.edge_list.push(this);
		}
		
		public function hasPoint(point:PPoint):Boolean {
			return p.equals(point) || q.equals(point);
		}
		
		static public function getUniquePointsFromEdges(edges:Vector.<Edge>):Vector.<PPoint> {
			var edge:Edge;
			var point:PPoint;
			var points:Vector.<PPoint> = new Vector.<PPoint>();
			for each (edge in edges) { points.push(edge.p); points.push(edge.q); }
			return PPoint.getUniqueList(points);
		}
		
		static public function traceList(edges:Vector.<Edge>):void {
			var point:PPoint;
			var edge:Edge;
			var pointsList:Vector.<PPoint> = Edge.getUniquePointsFromEdges(edges);
			var pointsMap:Dictionary = new Dictionary();
			
			var points_length:uint = 0;
			for each (point in pointsList) pointsMap[String(point)] = ++points_length;
			
			function getPointName(point:PPoint):String {
				return "p" + pointsMap[String(point)];
			}
			
		//	print("Points:");
			for each (point in pointsList) {
			//	print("  " + getPointName(point) + " = " + point);
			}
		//	print("Edges:");
			for each (edge in edges) {
		//		print("  Edge(" + getPointName(edge.p) + ", " + getPointName(edge.q) + ")");
			}
		}
		
		public function toString():String {
			return "Edge(" + this.p + ", " + this.q + ")";
		}
	}

}
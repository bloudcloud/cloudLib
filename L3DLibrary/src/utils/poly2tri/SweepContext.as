package utils.poly2tri {
	import flash.utils.Dictionary;

	public class SweepContext {
		public var triangles:Vector.<Triangle>;
		public var points:Vector.<PPoint>;
		public var edge_list:Vector.<Edge>;
		
		public var map:Dictionary;
		
		public var front:AdvancingFront;
		public var head:PPoint;
		public var tail:PPoint;
		
		public var af_head:Node;
		public var af_middle:Node;
		public var af_tail:Node;
		
		public var basin:Basin = new Basin();
		public var edge_event:EdgeEvent = new EdgeEvent();
		
		public function SweepContext(polyline:Vector.<PPoint> = null) {
			this.triangles = new Vector.<Triangle>();
			this.points = new Vector.<PPoint>();
			this.edge_list = new Vector.<Edge>();
			this.map = new Dictionary();
			
			this.addPolyline(polyline);
		}
		
		protected function addPoints(points:Vector.<PPoint>):void {
			for each (var point:PPoint in points) this.points.push(point);
		}
		
		public function addPolyline(polyline:Vector.<PPoint>):void {
			if (polyline == null) return;
			this.initEdges(polyline);
			this.addPoints(polyline);
		}

		/**
		 * An alias of addPolyline.
		 *
		 * @param	polyline
		 */
		public function addHole(polyline:Vector.<PPoint>):void {
			addPolyline(polyline);
		}

		protected function initEdges(polyline:Vector.<PPoint>):void {
			for (var n:uint = 0; n < polyline.length; n++) {
				this.edge_list.push(new Edge(polyline[n], polyline[(n + 1) % polyline.length]));
			}
		}

		public function addToMap(triangle:Triangle):void {
			this.map[String(triangle)] = triangle;
		}

		public function initTriangulation():void {
			var xmin:Number = this.points[0].x, xmax:Number = this.points[0].x;
			var ymin:Number = this.points[0].y, ymax:Number = this.points[0].y;
			
			// Calculate bounds
			for each (var p:PPoint in this.points) {
				if (p.x > xmax) xmax = p.x;
				if (p.x < xmin) xmin = p.x;
				if (p.y > ymax) ymax = p.y;
				if (p.y < ymin) ymin = p.y;
			}

			var dx:Number = Constants.kAlpha * (xmax - xmin);
			var dy:Number = Constants.kAlpha * (ymax - ymin);
			this.head = new PPoint(xmax + dx, ymin - dy);
			this.tail = new PPoint(xmin - dy, ymin - dy);

			// Sort points along y-axis
			PPoint.sortPoints(this.points);
			//throw(new Error("@TODO Implement 'Sort points along y-axis' @see class SweepContext"));
		}
		
		public function locateNode(point:PPoint):Node {
			return this.front.locateNode(point.x);
		}

		public function createAdvancingFront():void {
			if(new Triangle().EqualPoints(this.points[0], this.tail, 0.1) || new Triangle().EqualPoints(this.points[0], this.head, 0.1) || new Triangle().EqualPoints(this.tail, this.head, 0.1))
			{
				return;
			}
			// Initial triangle
			var triangle:Triangle = new Triangle(this.points[0], this.tail, this.head);

			addToMap(triangle);

			var head:Node    = new Node(triangle.points[1], triangle);
			var middle:Node  = new Node(triangle.points[0], triangle);
			var tail:Node    = new Node(triangle.points[2]);

			this.front  = new AdvancingFront(head, tail);

			head.next   = middle;
			middle.next = tail;
			middle.prev = head;
			tail.prev   = middle;
		}

		public function removeNode(node:Node):void {
			// do nothing
		}

		public function mapTriangleToNodes(triangle:Triangle):void {
			for (var n:uint = 0; n < 3; n++) {
				if (triangle.neighbors[n] == null) {
					var neighbor:Node = this.front.locatePoint(triangle.pointCW(triangle.points[n]));
					if (neighbor != null) neighbor.triangle = triangle;
				}
			}
		}
		
		public function removeFromMap(triangle:Triangle):void {
			delete this.map[String(triangle)];
		}

		public function meshClean(triangle:Triangle, level:int = 0):void {
			if (level == 0) {
				//for each (var mappedTriangle:Triangle in this.map) trace(mappedTriangle);
			}
			if (triangle == null || triangle.interior) return;
			triangle.interior = true;
			this.triangles.push(triangle);
			for (var n:uint = 0; n < 3; n++) {
				if (!triangle.constrained_edge[n]) {
					this.meshClean(triangle.neighbors[n], level + 1);
				}
			}
		}
	}
}
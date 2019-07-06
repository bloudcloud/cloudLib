package
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;	
	
	public class L3DShape
	{
		private var points : Vector.<Vector3D> = new Vector.<Vector3D>();
		
		public function L3DShape(points:Vector.<Vector3D> = null)
		{
			this.points = points == null || points.length == 0 ?null:points;
		}
		
		public function Save():ByteArray
		{
			if(!Exist)
			{
				return null;
			}
			
			var byteArray:ByteArray = new ByteArray();
			
			byteArray.writeInt(0);
            byteArray.writeInt(points.length);
			
			for each(var point:Vector3D in points)
			{
				byteArray.writeFloat(point.x);
				byteArray.writeFloat(point.y);
				byteArray.writeFloat(point.z);
			}
			
			return byteArray;
		}
		
		public function Load(byteArray:ByteArray):Boolean
		{
			if(byteArray == null || byteArray.length == 0)
			{
				return false;
			}
			
			var version:int = byteArray.readInt();
			var count:int = byteArray.readInt();
			
			points = new Vector.<Vector3D>();
			
			for(var i:int = 0; i< count; i++)
			{
				var point:Vector3D = new Vector3D();
				point.x = byteArray.readFloat();
				point.y = byteArray.readFloat();
				point.z = byteArray.readFloat();
				points.push(point);
			}
			
			return points.length > 0;
		}
		
		public function get Exist():Boolean
		{
			if(points == null || points.length < 2)
			{
				return false;
			}
			
			var size:Vector3D = Size;
			if(size.x == 0 && size.y == 0)
			{
				return false;
			}
			
			return true;
		}
		
		public function Preview():BitmapData
		{
			var bmp:BitmapData = new BitmapData(200,200,false,0x3366FF);
			
			if(points == null || points.length < 2)
			{
				return bmp;
			}
			
			var size:Vector3D = Size;
			if(size.x == 0 && size.y == 0)
			{
				return bmp;
			}
			
			var length:Number = Math.max(size.x,size.y);
			if(length <= 0)
			{
				return bmp;
			}

			var scale:Number = 180 / length;
			
			var compuPoints:Vector.<Vector3D> = Points;
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1,0xFFFFFF);
			for(var i:int = 0;i< compuPoints.length;i++)
			{
				var point1:Vector3D = compuPoints[i];
				var point2:Vector3D = i == compuPoints.length - 1 ? compuPoints[0] : compuPoints[i+1];				
				shape.graphics.moveTo(point1.x * scale + 100, 100 - point1.y * scale);
				shape.graphics.lineTo(point2.x * scale + 100, 100 - point2.y * scale);
			}
			
			bmp.draw(shape);
			
			return bmp;
		}
		
		private function get Center():Vector3D
		{
			if(points == null || points.length == 0)
			{
				return new Vector3D();
			}
			
			var maxPoint:Vector3D = points[0].clone();
			var minPoint:Vector3D = points[0].clone();
			for(var i:int = 1; i < points.length; i++)
			{
				if(points[i].x > maxPoint.x)
				{
					maxPoint.x = points[i].x;	
				}
				if(points[i].y > maxPoint.y)
				{
					maxPoint.y = points[i].y;	
				}
				if(points[i].z > maxPoint.z)
				{
					maxPoint.z = points[i].z;	
				}
				if(points[i].x < minPoint.x)
				{
					minPoint.x = points[i].x;	
				}
				if(points[i].y < minPoint.y)
				{
					minPoint.y = points[i].y;	
				}
				if(points[i].z < minPoint.z)
				{
					minPoint.z = points[i].z;	
				}
			}
			
			return new Vector3D((maxPoint.x + minPoint.x)/2, (maxPoint.y + minPoint.y)/2, (maxPoint.z + minPoint.z)/2);
		}
		
		public function get Size():Vector3D
		{
			if(points == null || points.length < 2)
			{
				return new Vector3D();
			}
			
			var maxPoint:Vector3D = points[0].clone();
			var minPoint:Vector3D = points[0].clone();
			for(var i:int = 1; i < points.length; i++)
			{
                if(points[i].x > maxPoint.x)
                {
					maxPoint.x = points[i].x;	
                }
				if(points[i].y > maxPoint.y)
				{
					maxPoint.y = points[i].y;	
				}
				if(points[i].z > maxPoint.z)
				{
					maxPoint.z = points[i].z;	
				}
				if(points[i].x < minPoint.x)
				{
					minPoint.x = points[i].x;	
				}
				if(points[i].y < minPoint.y)
				{
					minPoint.y = points[i].y;	
				}
				if(points[i].z < minPoint.z)
				{
					minPoint.z = points[i].z;	
				}
			}
			
			return new Vector3D(maxPoint.x - minPoint.x, maxPoint.y - minPoint.y, maxPoint.z - minPoint.z);
		}
		
		public function get BasePoints():Vector.<Vector3D>
		{
			if(points == null || points.length == 0)
			{
				return null;
			}
			
			if(points.length == 1)
			{
				return new Vector.<Vector3D>([ points[0].clone() ]);
			}
			
			var compuPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			for each(var point:Vector3D in points)
			{
				var compuPoint:Vector3D = point.clone();
				compuPoints.push(compuPoint);
			}
			
			return compuPoints;
		}
		
		public function get Points():Vector.<Vector3D>
		{
			if(points == null || points.length == 0)
			{
				return null;
			}
			
			if(points.length == 1)
			{
				return new Vector.<Vector3D>([ new Vector3D() ]);
			}
			
			var center:Vector3D = Center;
			var compuPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			for each(var point:Vector3D in points)
			{
				var compuPoint:Vector3D = new Vector3D(point.x - center.x, point.y - center.y, 0);
				compuPoints.push(compuPoint);
			}
			
			return compuPoints;
		}
	}
}
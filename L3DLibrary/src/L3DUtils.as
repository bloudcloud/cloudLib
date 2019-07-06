package
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import mx.core.FlexSprite;
	
	import L2D.cc_gpcclipper.cc_gpcclipper;
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.utils.Object3DUtils;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.singles.CL3DModuleUtil;
	
	import model.geom.GeomUtil;
	
	import utils.geom.Clipper;
	
	public class L3DUtils
	{
		/// <summary>
		/// 360度
		/// </summary>
		public static const CircleAngle:Number =  Math.PI * 2.0;
		/// <summary>
		/// 90度
		/// </summary>
		public static const RightAngle:Number = Math.PI * 0.5;
		/// <summary>
		/// 30度
		/// </summary>
		public static const TriangleAngle:Number = Math.PI / 6.0;
		/// <summary>
		/// 45度
		/// </summary>
		public static const QuarterAngle:Number = Math.PI * 0.25;
		/// <summary>
		/// 1度
		/// </summary>
		public static const EachAngle:Number = Math.PI / 180.0;
		
		private static const TRIANGULATEEPSILON:Number=0.0000000001;
		private static var conn1 :LocalConnection;
		private static var conn2 :LocalConnection;
		
		public function L3DUtils()
		{
			
		}
		
		public static function PointToVector3D(point:Point):Vector3D
		{
			if(point == null)
			{
				return new Vector3D();
			}
			
			return new Vector3D(point.x, point.y, 0);
		}
		
		public static function Vector3DToPoint(point:Vector3D):Point
		{
			if(point == null)
			{
				return new Point();
			}
			
			return new Point(point.x, point.y);
		}
		
		private static function GetVerticalRotationAngle(normal:Vector3D):Vector3D
		{
			var direction:Vector3D = new Vector3D(normal.x, normal.z, normal.y);
			direction.normalize();
			var angle:Vector3D = new Vector3D();
            angle.x = RightAngle - Math.asin(direction.y > 1 ? 1:(direction.y < -1?-1:direction.y));
			angle.y = Math.atan2(direction.x, direction.z);
			angle.z = 0.0;
			return new Vector3D(angle.y, angle.x, angle.z);
		}
		
		private static function GetVerticalRotationMatrix(normal:Vector3D):Matrix3D
		{
			var angle:Vector3D = GetVerticalRotationAngle(normal);
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendRotation(angle.x * 180 / Math.PI, new Vector3D(1,0,0));
			matrix.appendRotation(angle.y * 180 / Math.PI, new Vector3D(0,1,0));
			matrix.appendRotation(angle.z * 180 / Math.PI, new Vector3D(0,0,1));
			return matrix;
		}
		
		public static function CompuNormalFromThreePoints(point1:Vector3D, point2:Vector3D, point3:Vector3D, isCounterClockwise:Boolean):Vector3D
		{
			var compuPoint1:Vector3D = isCounterClockwise ? new Vector3D(point2.x - point1.x, point2.y - point1.y, point2.z - point1.z):new Vector3D(point1.x - point2.x, point1.y - point2.y, point1.z - point2.z);
			var compuPoint2:Vector3D = isCounterClockwise ? new Vector3D(point3.x - point1.x, point3.y - point1.y, point3.z - point1.z):new Vector3D(point3.x - point2.x, point3.y - point2.y, point3.z - point2.z);
			var normal:Vector3D = compuPoint1.crossProduct(compuPoint2);
			normal.normalize();
			return normal;
		}
		
		public static function LoftShape(shape:L3DShape, path:Vector.<Vector3D>, centerAlign:Boolean = true, stage3D:Stage3D = null):Mesh
		{
			if(shape == null || !shape.Exist || path == null || path.length < 2)
			{
				return null;
			}
			
			return Loft(shape.BasePoints, path, centerAlign, stage3D);
		}
		
		public static function Loft(shape:Vector.<Vector3D>, path:Vector.<Vector3D>, centerAlign:Boolean = true, stage3D:Stage3D = null):Mesh
		{
			if(shape == null || shape.length < 3 || path == null || path.length < 2)
			{
				return null;
			}
			
            var normal:Vector3D = new Vector3D();
			if(path.length == 2)
			{
				var checkNormal:Vector3D = new Vector3D(path[1].x - path[0].x, path[1].y - path[0].y, path[1].z - path[0].z);
				checkNormal.normalize();
				if(checkNormal.x != 0 || checkNormal.y != 0)
				{
				    normal = new Vector3D(0,0,1);
				}
				else if(checkNormal.z != 0)
				{
					normal = new Vector3D(1,0,0);
				}
				else
				{
					normal = new Vector3D(0,0,1);
				}
			}
			else
			{
			    for(var i:int = 0;i< path.length - 2;i++)
			    {
				    var point1:Vector3D = path[i];
					var point2:Vector3D = path[i+1];
					var point3:Vector3D = path[i+2];
					normal = CompuNormalFromThreePoints(point1, point2, point3, false);
					if(normal.x != 0 || normal.y != 0 || normal.z != 0)
					{
						break;
					}
			    }
				if(normal.x == 0 && normal.y == 0 && normal.z == 0)
				{
					var checkNormal:Vector3D = new Vector3D(path[1].x - path[0].x, path[1].y - path[0].y, path[1].z - path[0].z);
					checkNormal.normalize();
					if(checkNormal.x != 0 || checkNormal.y != 0)
					{
						normal = new Vector3D(0,0,1);
					}
					else if(checkNormal.z != 0)
					{
						normal = new Vector3D(1,0,0);
					}
					else
					{
						normal = new Vector3D(0,0,1);
					}
				}
				else if(normal.x == 0 && normal.y == 0)
				{
					normal.z = Math.abs(normal.z);
				}
			}
			
			var matrix:Matrix3D = GetVerticalRotationMatrix(normal);
			var invertMatrix:Matrix3D = matrix.clone();
			invertMatrix.invert();
			
			var compuPath:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var i:int = 0; i< path.length;i++)
			{
				var point:Vector3D = invertMatrix.transformVector(CopyVector3D(path[i]));	
				if(normal.x == 1 && normal.y == 0 && normal.z == 0)
				{
				    var t:Number = point.y;
				    point.y = point.z;
				    point.z = t;
				}
				else if(normal.x == 0 && normal.y == 1 && normal.z == 0)
				{
					var t:Number = point.y;
					point.y = point.z;
					point.z = t;
				}
				compuPath.push(point);
				var a:Number = point.x;
				var b:Number = point.y;
				var c:Number = point.z;
			}
			var compuZ:Number = compuPath[0].z;
			for(var i:int = 0; i< path.length;i++)
			{
                compuPath[i].z = 0;
			}
			
			var shapeCenter:Vector3D = new Vector3D();
			var maxPoint:Vector3D = shape[0];
			var minPoint:Vector3D = shape[0];
			for(var i:int = 1; i< shape.length;i++)
			{
				if(shape[i].x > maxPoint.x)
				{
					maxPoint.x = shape[i].x;
				}
				if(shape[i].y > maxPoint.y)
				{
					maxPoint.y = shape[i].y;
				}
				if(shape[i].z > maxPoint.z)
				{
					maxPoint.z = shape[i].z;
				}
				if(shape[i].x < minPoint.x)
				{
					minPoint.x = shape[i].x;
				}
				if(shape[i].y < minPoint.y)
				{
					minPoint.y = shape[i].y;
				}
				if(shape[i].z < minPoint.z)
				{
					minPoint.z = shape[i].z;
				}
			}
			shapeCenter.x = (maxPoint.x + minPoint.x) * 0.5;
			shapeCenter.y = (maxPoint.y + minPoint.y) * 0.5;
			shapeCenter.z = (maxPoint.z + minPoint.z) * 0.5;
			
			var compuShape:Vector.<Vector3D> = new Vector.<Vector3D>();
			var shapeMatrix:Matrix3D = new Matrix3D();
			shapeMatrix.identity();
			if(normal.x == 1 && normal.y == 0 && normal.z == 0)
			{
                shapeMatrix.appendRotation(90, new Vector3D(0,0,1));
			}
			else if(normal.x == 0 && normal.y == 1 && normal.z == 0)
			{
				shapeMatrix.appendRotation(-90, new Vector3D(0,0,1));
			}
			for(var i:int = 0; i< shape.length;i++)
			{
				var point:Vector3D = new Vector3D();
				if(centerAlign)
				{
				    point.x = shape[i].x - shapeCenter.x;
				    point.y = shape[i].y - shapeCenter.y;
				    point.z = shape[i].z - shapeCenter.z;
				}
				else
				{
					point = CopyVector3D(shape[i]);
				}
				if(normal.x == 0 && normal.y == 0 && normal.z == 1)
				{
					point.x *= -1;
					compuShape.push(point);
				}
				else					
				{	
				    compuShape.push(shapeMatrix.transformVector(point));
				}
			}
			
			var compuLines:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>();
			for(var i:int = 0; i< shape.length;i++)
			{
				var compuLine:Vector.<Vector3D> = new Vector.<Vector3D>();
				var offsetPath:Array = new Array();
				for(var j:int = 0; j< path.length;j++)
				{
					offsetPath.push(CopyVector3D(compuPath[j]));
				}
				if(compuShape[i].x == 0)
				{
					for(var j:int = 0; j< path.length;j++)
					{
						var point:Vector3D = CopyVector3D(offsetPath[j] as Vector3D);
						point.z = compuShape[i].y + compuZ;
						if(normal.x == 1 && normal.y == 0 && normal.z == 0)
						{
							var t:Number = point.y;
							point.y = point.z;
							point.z = t;
						}
						else if(normal.x == 0 && normal.y == 1 && normal.z == 0)
						{
							var t:Number = point.y;
							point.y = point.z;
							point.z = t;
						}
						point = matrix.transformVector(point);
						compuLine.push(point);
					}
				}
				else
				{
				    var offsetLine:Array = GetOffsetPoints(offsetPath, compuShape[i].x);
					for(var j:int = 0; j< path.length;j++)
					{	
						var point:Vector3D = CopyVector3D(offsetLine[j] as Vector3D);
						point.z = compuShape[i].y + compuZ;
						if(normal.x == 1 && normal.y == 0 && normal.z == 0)
						{
							var t:Number = point.y;
							point.y = point.z;
							point.z = t;
						}
						else if(normal.x == 0 && normal.y == 1 && normal.z == 0)
						{
							var t:Number = point.y;
							point.y = point.z;
							point.z = t;
						}
						point = matrix.transformVector(point);
						compuLine.push(point);
					}
				}
				compuLines.push(compuLine);
			}			
	
			var vertices:Vector.<Number> = new Vector.<Number>();
			var texture0:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			var numberVertices:int = 0;
			for(var i:int = 0; i< path.length - 1;i++)
			{
				for(var j:int = 0; j < shape.length;j++)
				{
					var point1:Vector3D = compuLines[j][i];
					var point2:Vector3D = j == shape.length - 1 ? compuLines[0][i] : compuLines[j + 1][i];
					var point3:Vector3D = compuLines[j][i + 1];
					var point4:Vector3D = j == shape.length - 1 ? compuLines[0][i + 1] : compuLines[j + 1][i + 1];
					vertices.push(point1.x);
					vertices.push(point1.y);
					vertices.push(point1.z);
					vertices.push(point2.x);
					vertices.push(point2.y);
					vertices.push(point2.z);
					vertices.push(point3.x);
					vertices.push(point3.y);
					vertices.push(point3.z);
					vertices.push(point4.x);
					vertices.push(point4.y);
					vertices.push(point4.z);
					texture0.push(0);
					texture0.push(1);
					texture0.push(0);
					texture0.push(1);
					texture0.push(0);
					texture0.push(1);
					texture0.push(0);
					texture0.push(1);
					indices.push(numberVertices);
					indices.push(numberVertices + 1);
					indices.push(numberVertices + 2);
					indices.push(numberVertices + 1);
					indices.push(numberVertices + 3);
					indices.push(numberVertices + 2);
					indices.push(numberVertices);
					indices.push(numberVertices + 2);
					indices.push(numberVertices + 1);
					indices.push(numberVertices + 1);
					indices.push(numberVertices + 2);
					indices.push(numberVertices + 3);
					numberVertices += 4;
				}
			}
			
			var mesh:Mesh = new Mesh();
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);

			mesh.geometry.numVertices = vertices.length / 3;			
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
			mesh.geometry.indices = indices;			
			
			var material:Material = new FillMaterial(0xFFFFFF);
			
			mesh.addSurface(material, 0, indices.length / 3);
			mesh.name = "LOFTMESH";
			
			if(mesh != null && stage3D != null)
			{
				UploadResources(mesh, stage3D.context3D);
			}
			
			return mesh;
		}	
		
		public static function CheckInvalidCharInWord(value:String):Boolean
		{
			var regExp:RegExp = /^[u4E00-u9FA5]*$/;
			if(!regExp.test(value))
			{
				return true;
			}
			
			if(value.indexOf("-") >= 0 || value.indexOf("_") >= 0 || value.indexOf(",") >= 0 || value.indexOf(".") >= 0 || value.indexOf(";") >= 0 || value.indexOf("`") >= 0 || value.indexOf("!") >= 0 || value.indexOf("@") >= 0)
			{
				return true;
			}
			
			if(value.indexOf("(") >= 0 || value.indexOf(")") >= 0 || value.indexOf("[") >= 0 || value.indexOf("]") >= 0 || value.indexOf("{") >= 0 || value.indexOf("}") >= 0 || value.indexOf("\"") >= 0 || value.indexOf("\\") >= 0)
			{
				return true;
			}
			
			if(value.indexOf("~") >= 0 || value.indexOf("'") >= 0 || value.indexOf("?") >= 0 || value.indexOf("<") >= 0 || value.indexOf(">") >= 0 || value.indexOf("+") >= 0 || value.indexOf("#") >= 0 || value.indexOf("$") >= 0)
			{
				return true;
			}
			
			if(value.indexOf("%") >= 0 || value.indexOf("^") >= 0 || value.indexOf("&") >= 0 || value.indexOf("*") >= 0 || value.indexOf("=") >= 0 || value.indexOf("|") >= 0 || value.indexOf("/") >= 0 || value.indexOf(":") >= 0)
			{
				return true;
			}
			
			return false;
		}
		
		public static function GetOffsetPoint2Ds(points:Array, distance:Number, enclose:Boolean = true):Array
		{
			if(points == null || points.length == 0)
			{
				return null;
			}
			
			if(points.length == 1 || (distance < 0.01 && distance > -0.01))
			{
				return points;
			}
			
			var compuPoints:Array = new Array();
			for(var i:int = 0; i<points.length; i++)
			{
				compuPoints.push(new Vector3D((points[i] as Point).x, (points[i] as Point).y, 0));
			}
			
			var compuedPoints:Array = GetOffsetPoints(compuPoints, distance, enclose);
			if(compuedPoints == null || compuedPoints.length == 0)
			{
				return null;
			}
			
			var exportPoints:Array = new Array();
			for(var i:int = 0; i< compuedPoints.length; i++)
			{
				if(i >= points.length)
				{
					continue;
				}
				exportPoints.push(new Point((compuedPoints[i] as Vector3D).x, (compuedPoints[i] as Vector3D).y));
			}
			
			return exportPoints;
		}
		
		public static function GetOffsetPoints(points:Array, distance:Number, enclose:Boolean = false):Array
		{
            if(points == null || points.length == 0)
			{
				return null;
			}
			
			if(points.length == 1 || (distance < 0.01 && distance > -0.01))
			{
			    return points;
			}
			
			if(points.length == 2)
			{
				var pstart:Vector3D = new Vector3D(points[0].x, points[0].y, 0);
				var pend:Vector3D = new Vector3D(points[1].x, points[1].y, 0);
				var plength:Number = new Vector3D(pend.x - pstart.x, pend.y - pstart.y, 0).length;
				var pmatrix:Matrix3D = CompuLineMaterix(pstart, pend);
			//	var invpmatrix:Matrix3D = pmatrix.clone();
			//	invpmatrix.invert();
				var estart:Vector3D = pmatrix.transformVector(new Vector3D(0,distance,0));
				var eend:Vector3D = pmatrix.transformVector(new Vector3D(plength,distance,0));
				estart.z = pstart.z;
				eend.z = pend.z;
				return [estart, eend];
			}
			
			var compuPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var i:int = 0;i< points.length;i++)
			{
				compuPoints.push(CopyVector3D(points[i] as Vector3D));
			}
			if(enclose && !Equal(points[0] as Vector3D, points[points.length - 1] as Vector3D, 2))
			{
				compuPoints.push(CopyVector3D(points[0] as Vector3D));
			}

			if(!enclose)
			{
				var point:Vector3D = new Vector3D(compuPoints[0].x - compuPoints[1].x,compuPoints[0].y - compuPoints[1].y,0);
				point.normalize();
				compuPoints.unshift(new Vector3D(point.x + compuPoints[0].x, point.y + compuPoints[0].y, point.z + compuPoints[0].z));
				var matrix:Matrix3D = new Matrix3D();
				matrix.identity();	
				matrix.appendRotation(90, new Vector3D(0,0,1));
				point = matrix.transformVector(point);
				point.normalize();
				compuPoints.unshift(new Vector3D(point.x + compuPoints[0].x, point.y + compuPoints[0].y, point.z + compuPoints[0].z));
				
				point = new Vector3D(compuPoints[compuPoints.length - 1].x - compuPoints[compuPoints.length - 2].x, compuPoints[compuPoints.length - 1].y - compuPoints[compuPoints.length - 2].y, 0);
				point.normalize();
				compuPoints.push(new Vector3D(point.x + compuPoints[compuPoints.length - 1].x, point.y + compuPoints[compuPoints.length - 1].y, point.z + compuPoints[compuPoints.length - 1].z));
				matrix = new Matrix3D();
				matrix.identity();
				matrix.appendRotation(-90, new Vector3D(0,0,1));
				point = matrix.transformVector(point);
				point.normalize();
				compuPoints.push(new Vector3D(point.x + compuPoints[compuPoints.length - 1].x, point.y + compuPoints[compuPoints.length - 1].y, point.z + compuPoints[compuPoints.length - 1].z));
			}

			var N:int = compuPoints.length - 1;
			var d:Number = distance;
			var P:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var j:int = 0; j<N; j++)
			{
				P.push(CopyVector3D(compuPoints[j]));
			}            
			var U:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var k:int = 0; k<N; k++)
			{
				var pP:Vector3D = k == N-1 ? P[0] : P[k + 1];
				var C:Number = pP.x - P[k].x;
				var S:Number = pP.y - P[k].y;
				var L:Number = new Vector3D(C,S,0).length;
				var tU:Vector3D = new Vector3D();
				tU.x = C / L;
				tU.y = S / L;
				U.push(tU);
			}
			var H:Vector.<Vector3D> = new Vector.<Vector3D>();
			var pDX:Number = 0;
			var pDY:Number = 0;
			var pDir:Number = 1;
			for(var k:int = 0;k<N;k++)
			{
				var pU:Vector3D = k == 0 ? U[N - 1] : U[k - 1];
				var L:Number = d / (1 + U[k].x * pU.x + U[k].y * pU.y);
				var tH:Vector3D = new Vector3D();
				if(IsNumberLegal(L))
				{
					pDX = L * (U[k].y + pU.y);
					pDY = L * (U[k].x + pU.x);
					tH.x = P[k].x - pDir * pDX;
					tH.y = P[k].y + pDir * pDY;
					tH.z = P[k].z;
				}
				else
				{
					tH.x = P[k].x - pDir * pDX;
					tH.y = P[k].y + pDir * pDY;
					tH.z = P[k].z;
					pDir *= -1;
				}
				H.push(tH);
			}
			
			var compuedPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			for(var i:int = 0;i<N;i++)
			{
				compuedPoints.push(CopyVector3D(H[i]));
			}
			compuedPoints.push(CopyVector3D(H[0]));
			
			var offsetPoints:Array = new Array();
			var offsetIndex:int = enclose ? 0 : 2;
			for(var i:int = 0;i<points.length;i++)
			{
			//	offsetPoints.push(CopyVector3D(compuedPoints[i+2]));
				offsetPoints.push(compuedPoints[i+offsetIndex].clone());
			}
			
			return offsetPoints.length > 0?offsetPoints:null;
		}
		
		private static function UploadResources(object:Object3D, context:Context3D):void
		{
			for each (var res:Resource in object.getResources(true))
			{
				res.upload(context);
			}
		}
		
		public static function CompuDegree(dir1:Vector3D, dir2:Vector3D):Number
		{
			var d1:Vector3D = dir1.clone();
			var d2:Vector3D = dir2.clone();
			d1.normalize();
			d2.normalize();
			var r1:Number = d1.length;
			var r2:Number = d2.length;
			var d:Number = d1.dotProduct(d2);
			var v:Number = d / (r1 * r2);
			v = v > 1 ? 1 : (v < -1 ? -1: v);
			var a:Number = Math.acos(v);
			return a * 180 / Math.PI;
		}
		
		public static function CompuSide(dir1:Vector3D, dir2:Vector3D):int
		{
			var d1:Vector3D = dir1.clone();
			var d2:Vector3D = dir2.clone();
			d1.normalize();
			d2.normalize();
			var r1:Number = d1.length;
			var r2:Number = d2.length;
			if(d1.y >= 0 && d2.y >= 0)
			{
				if(d2.x >= d1.x)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			else if(d1.y <= 0 && d2.y <= 0)
			{
				if(d2.x <= d1.x)
				{
					return 1;
				}
				else 
				{
					return 0;
				}
			}
			else if(d1.x >= 0 && d2.x >= 0)
			{
				if(d2.y <= d1.y)
				{
					return 1;
				}
				else
				{
					return 0;
				}	
			}
			else if(d1.x <= 0 && d2.x <= 0)
			{
				if(d2.y >= d1.y)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			else if(d1.x >= 0 && d1.y >= 0 && d2.x <= 0 && d2.y <= 0)
			{
				if(Math.abs(d2.x) <= Math.abs(d1.x))
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			else if(d1.x <= 0 && d1.y >= 0 && d2.x >= 0 && d2.y <= 0)
			{
				if(Math.abs(d2.x) >= Math.abs(d1.x))
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			else if(d1.x <= 0 && d1.y <= 0 && d2.x >= 0 && d2.y >= 0)
			{
				if(Math.abs(d2.x) <= Math.abs(d1.x))
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			else if(d1.x >= 0 && d1.y <= 0 && d2.x <= 0 && d2.y >= 0)
			{
				if(Math.abs(d2.x) >= Math.abs(d1.x))
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
			
			return 0;
		}
		
		public static function CompuArea(mesh:Mesh):Number
		{
			if(mesh == null)
			{
				return 0;
			}
			
			var area:Number = 0;
			if(mesh.geometry != null)
			{
				var vertices:Vector.<Number> = mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
				var indices:Vector.<uint> = mesh.geometry.indices;
				var count:uint = indices.length;
				for(var j:uint = 0; j < count; j+= 3)
				{
					var i0:uint = indices[j];
					var i1:uint = indices[j + 1];
					var i2:uint = indices[j + 2];
					var v0:Vector3D = new Vector3D(vertices[i0 * 3], vertices[i0 * 3 + 1], vertices[i0 * 3 + 2]);
					var v1:Vector3D = new Vector3D(vertices[i1 * 3], vertices[i1 * 3 + 1], vertices[i1 * 3 + 2]);
					var v2:Vector3D = new Vector3D(vertices[i2 * 3], vertices[i2 * 3 + 1], vertices[i2 * 3 + 2]);
					area += CompuFaceArea(v0,v1,v2);
				}
			}
			
			for (var i:int = 0; i < mesh.numChildren; i++)
			{
				var subset:Object3D = mesh.getChildAt(i);
				if(subset is Mesh)
				{
					var subMesh:Mesh = Mesh(subset);
					if(subMesh.geometry == null)
					{
						continue;
					}
					var vertices:Vector.<Number> = subMesh.geometry.getAttributeValues(VertexAttributes.POSITION);
					var indices:Vector.<uint> = subMesh.geometry.indices;
					var count:uint = indices.length;
					for(var j:uint = 0; j < count; j+= 3)
					{
						var i0:uint = indices[j];
						var i1:uint = indices[j + 1];
						var i2:uint = indices[j + 2];
						var v0:Vector3D = new Vector3D(vertices[i0 * 3], vertices[i0 * 3 + 1], vertices[i0 * 3 + 2]);
						var v1:Vector3D = new Vector3D(vertices[i1 * 3], vertices[i1 * 3 + 1], vertices[i1 * 3 + 2]);
						var v2:Vector3D = new Vector3D(vertices[i2 * 3], vertices[i2 * 3 + 1], vertices[i2 * 3 + 2]);
						area += CompuFaceArea(v0,v1,v2);
					}
				}
			}	
			return area;
		}
		
		public static function CompuFaceArea(v1:Vector3D, v2:Vector3D, v3:Vector3D):Number
		{
			var d1:Vector3D = new Vector3D(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
			var d2:Vector3D = new Vector3D(v2.x - v3.x, v2.y - v3.y, v2.z - v3.z);
			var d3:Vector3D = new Vector3D(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
			var l1:Number = d1.length;
			var l2:Number = d2.length;
			var l3:Number = d3.length;
			var s:Number = (l1 + l2 + l3) / 2;
			return Math.sqrt(s * (s - l1) * (s - l2) * (s - l3));
		}
		
		public static function CopyVector3D(v:Vector3D):Vector3D
		{
			return new Vector3D(v.x, v.y, v.z, v.w);
		}
		
		public static function CompuVerticalRotationMatrix(normal:Vector3D):Matrix3D
		{
			var direction:Vector3D = new Vector3D(normal.x, normal.z, normal.y);
			var angle:Vector3D = new Vector3D();
			direction.normalize();
			angle.x = Math.PI / 2 - Math.asin(direction.y > 1 ? 1 : (direction.y < -1 ? -1 : direction.y));
			angle.y = Math.atan2(direction.x, direction.z);
			angle.z = 0;
			var amendAngle:Vector3D = new Vector3D(angle.y, angle.x, angle.z);
			var rotationMatrix:Matrix3D = new Matrix3D();
			rotationMatrix.identity();
			rotationMatrix.appendRotation(amendAngle.x, Vector3D.Y_AXIS);
			rotationMatrix.appendRotation(amendAngle.y, Vector3D.X_AXIS);
			rotationMatrix.appendRotation(amendAngle.z, Vector3D.Z_AXIS);
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			rotationMatrix.append(matrix);
			return rotationMatrix;
		}
		
		public static function BooleanMeshFromUpper(mainMesh:Mesh, cutMesh:L3DMesh, stage:Stage, stage3D:Stage3D, control:FlexSprite):Boolean
		{
			if(mainMesh == null || cutMesh == null || stage == null || stage3D == null || control == null)
			{
				return false;
			}
			
			if(mainMesh.geometry == null || cutMesh.numChildren == 0)
			{
				return false;
			}
			
			var vscene:Object3D = new Object3D();
			var camera:Camera3D = new Camera3D(0.1, 10000);
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF, 0, 1);
			control.addChild(camera.view);
			control.addChild(camera.diagram);				
			camera.diagram.visible = false;
			camera.x = 0;
			camera.y = 0;
			camera.z = 0;	
			camera.fov = 1.5707963;
			camera.view.hideLogo();
			camera.lookAt(0,1000,0);
			vscene.addChild(camera);
			
			vscene.addChild(mainMesh);
			vscene.addChild(cutMesh);
			
			mainMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mainMesh);
			cutMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mainMesh);
			
			var xLength:Number = mainMesh.boundBox.maxX - mainMesh.boundBox.minX;
			var yLength:Number = mainMesh.boundBox.maxY - mainMesh.boundBox.minY;
			
			var maskBox:Box = new Box(xLength + yLength, xLength + yLength, 1,2,2,2,false, new FillMaterial(0xFFFFFF));
			maskBox.x = mainMesh.x;
			maskBox.y = mainMesh.y;
			maskBox.z = 10;
			vscene.addChild(maskBox);
			
			if(xLength == 0 || yLength == 0)
			{
				return false;
			}
			
			var vertices:Vector.<Number> = mainMesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var texture0:Vector.<Number> = mainMesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			var count:uint = vertices.length / 3;
			for (var i:uint = 0; i < count; i++)
			{
				var x:Number = vertices[i * 3];
				var y:Number = vertices[i * 3 + 1];
				var z:Number = vertices[i * 3 + 2];
				var u:Number = texture0[i * 2];
				var v:Number = texture0[i * 2 + 1];
				u = (x - mainMesh.boundBox.minX) / xLength;
				v = (mainMesh.boundBox.maxY - y) / yLength;
				texture0[i * 2] = u;
				texture0[i * 2 + 1] = v;
			}
			mainMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
			
			UploadResources(vscene, stage3D.context3D);
			
			var viewTexture:CBitmapTextureResource = null;			
			var originalMaterials:Vector.<Material> = new Vector.<Material>();
			originalMaterials.push(mainMesh.getSurface(0).material);
			mainMesh.getSurface(0).material = new FillMaterial(0xFFFFFF, 1.0);			
			for(var j:int = 0;j< cutMesh.numChildren;j++)
			{
				var subset:Object3D = cutMesh.getChildAt(j);
				if(subset is Mesh && (subset as Mesh).numSurfaces > 0)
				{
					var mesh:Mesh = Mesh(subset);
					originalMaterials.push(mesh.getSurface(0).material);
					mesh.getSurface(0).material = new FillMaterial(0x000000, 1.0);
				}
			}

			camera.view.renderToBitmap = true;			
			camera.view.backgroundColor = 0xFFFFFF;	
			camera.orthographic = true;
			
			var currentModelScale:Vector3D = new Vector3D(mainMesh.scaleX, mainMesh.scaleY, mainMesh.scaleZ);
			var currentModelRotation:Vector3D = new Vector3D(mainMesh.rotationX, mainMesh.rotationY, mainMesh.rotationY);
			mainMesh.scaleX = 1;
			mainMesh.scaleY = 1;
			mainMesh.scaleZ = 1;
			mainMesh.rotationX = 0;
			mainMesh.rotationY = 0;
			mainMesh.rotationZ = 0;
			
			camera.view.width = mainMesh.boundBox.maxX - mainMesh.boundBox.minX;
			camera.view.height = mainMesh.boundBox.maxY - mainMesh.boundBox.minY;
			camera.x = (mainMesh.boundBox.maxX + mainMesh.boundBox.minX)/2 + mainMesh.x;
			camera.y = (mainMesh.boundBox.maxY + mainMesh.boundBox.minY)/2 + mainMesh.y;
			camera.z = mainMesh.boundBox.maxZ * 2 + mainMesh.z;
			camera.lookAt((mainMesh.boundBox.maxX + mainMesh.boundBox.minX)/2 + mainMesh.x,(mainMesh.boundBox.maxY + mainMesh.boundBox.minY)/2 + mainMesh.y,mainMesh.boundBox.minZ + mainMesh.z);
			
			mainMesh.visible = false;
			camera.render(stage3D);	
			mainMesh.visible = true;
			
			if(camera.view.canvas != null)
			{
				var sizeX:Number = 256;
				var sizeY:Number = 256;
				var topviewBitmapData:BitmapData = L3DMaterial.BitmapSizeScale(camera.view.canvas, sizeX, sizeY);
				if(topviewBitmapData != null)
				{
			/*		var bitmap:spark.components.Image = new spark.components.Image();
					bitmap.x = 100;
					bitmap.y = 100;
					bitmap.width = topviewBitmapData.width;
					bitmap.height = topviewBitmapData.height;
					bitmap.source = topviewBitmapData.clone();
					bitmap.visible = true;
					control.addChild(bitmap);*/
					viewTexture = new CBitmapTextureResource(topviewBitmapData);
					viewTexture.upload(stage3D.context3D);
				}
			}
			
			mainMesh.rotationX = currentModelRotation.x;
			mainMesh.rotationY = currentModelRotation.y;
			mainMesh.rotationZ = currentModelRotation.z;
			mainMesh.scaleX = currentModelScale.x;
			mainMesh.scaleY = currentModelScale.y;
			mainMesh.scaleZ = currentModelScale.z;
			
			camera.view.renderToBitmap = false;	
			camera.orthographic = false;
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
			
			mainMesh.getSurface(0).material = originalMaterials.shift();
			
			for(var k:int = 0;k< cutMesh.numChildren;k++)
			{
				var subset:Object3D = cutMesh.getChildAt(k);
				if(subset is Mesh && (subset as Mesh).numSurfaces > 0)
				{
					var mesh:Mesh = Mesh(subset);
					originalMaterials.push(mesh.getSurface(0).material);
					mesh.getSurface(0).material = originalMaterials.shift();
				}
			}
			
			var material:Material = mainMesh.getSurface(0).material;
			if( material is LightMapMaterial )
			{
				(material as LightMapMaterial).opacityMap = viewTexture;
				(material as LightMapMaterial).opaquePass = true;
				(material as LightMapMaterial).alpha = 1.0;
				(material as LightMapMaterial).alphaThreshold = 1.0;
				(material as LightMapMaterial).transparentPass = true;
			}			
			else if( material is StandardMaterial )
			{
				(material as StandardMaterial).opacityMap = viewTexture;
				(material as StandardMaterial).opaquePass = true;
				(material as StandardMaterial).alpha = 1.0;
				(material as StandardMaterial).alphaThreshold = 1.0;	
				(material as StandardMaterial).transparentPass = true;
			}
			else if( material is TextureMaterial )
			{
				(material as TextureMaterial).opacityMap = viewTexture;
				(material as TextureMaterial).opaquePass = true;
				(material as TextureMaterial).alpha = 1.0;
				(material as TextureMaterial).alphaThreshold = 1.0;		
				(material as TextureMaterial).transparentPass = true;
			}
			else if( material is FillMaterial )
			{
				var tex:CBitmapTextureResource = CL3DModuleUtil.Instance.getBitmapTextureResourceInstance((material as FillMaterial).color,CL3DConstDict.SUFFIX_DIFFUSE,CL3DConstDict.PREFIX_FILL);
				tex.upload(stage.stage3Ds[0].context3D);
				material = new TextureMaterial(tex,viewTexture);
				(material as TextureMaterial).opaquePass = true;
				(material as TextureMaterial).alpha = 1.0;
				(material as TextureMaterial).alphaThreshold = 1.0;	
				mainMesh.getSurface(0).material = material;
				(material as TextureMaterial).transparentPass = true;
			}
			else
			{
				var tex:CBitmapTextureResource = CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0xFFFFFF,CL3DConstDict.SUFFIX_DIFFUSE,CL3DConstDict.PREFIX_FILL);
				tex.upload(stage.stage3Ds[0].context3D);
				material = new TextureMaterial(tex,viewTexture);
				(material as TextureMaterial).opaquePass = true;	
				(material as TextureMaterial).alpha = 1.0;
				(material as TextureMaterial).alphaThreshold = 1.0;	
				mainMesh.getSurface(0).material = material;
				(material as TextureMaterial).transparentPass = true;
			}
			
			vscene.removeChild(mainMesh);
			vscene.removeChild(cutMesh);				
		
			return true;
		}
		
		public static function IsNumberLegal(n:Number):Boolean
		{
			if(isNaN(n))
			{
				return false;
			}			
			
			if(n == Number.POSITIVE_INFINITY || n == Number.NEGATIVE_INFINITY)
			{
				return false;
			}
			
			return true;
		}
		
		public static function BitmapMirror(bmpData:BitmapData, mirrorX:Boolean = false, mirrorY:Boolean = false):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0);
			bmpData_.lock();
			for(var x:int=0;x<bmpData.width;x++)
			{
				for(var y:int=0;y<bmpData.height;y++)
				{
					var color:uint = bmpData.getPixel32(x,y);
					var nx:int = mirrorX ? bmpData.width - 1 - x : x;
					var ny:int = mirrorY ? bmpData.height - 1 - y : y;
					bmpData_.setPixel32(nx,ny,color);
				}
			}
			bmpData_.unlock();
			return bmpData_;
		}
		
		public static function CompuTrianglePoints(source:Vector.<Vector3D>):Vector.<Vector3D>
		{
			if(source == null || source.length == 0)
			{
				return null;
			}
			
			var contour:Array = new Array();
			for(var i:int=0;i<source.length;i++)
			{
				var v:Point = new Point();
				v.x = source[i].x;
				v.y = source[i].y;
				contour.push(v);
			}
			
			var result:Array;
			if(!CompuTriangleArraies(contour, result))
			{
				return null;
			}
			
			if(result == null || result.length == 0)
			{
				return null;
			}
			
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var i:int = 0; i<result.length; i++)
			{
				var arr:Array = result[i] as Array;
				var v0:Vector3D = new Vector3D((arr[0] as Point).x, (arr[0] as Point).y, 0);
				var v1:Vector3D = new Vector3D((arr[1] as Point).x, (arr[1] as Point).y, 0);
				var v2:Vector3D = new Vector3D((arr[2] as Point).x, (arr[2] as Point).y, 0);
				points.push(v0);
				points.push(v1);
				points.push(v2);
			}
			
			return points;
		}
		
		/**
		 *多边形三角化 
		 * @param contour 多边形的点序列
		 * @param result  返回所有的三角形，result需要调用者自己new出来，不能传null,
		 * 				  result的元素为Array存储三角形的逆时针三点
		 * @return 三角化是否成功
		 * 
		 */		
		private static function CompuTriangleArraies(contour:Array, result:Array):Boolean
		{
			var n:int = contour.length;
			if(n<3)return false;
			
			var V:Array = new Array(n);
			var v:int = 0;
			
			if(0.0 < area(contour) )
				for(v=0; v<n; ++v)V[v]=v;
			else
				for(v=0; v<n; ++v)V[v]=n-1-v;
			
			var nv:int = n;
			var clone:int = 0;
			v=nv-1;
			var count:int = 2*nv;
			for(; nv>2;)
			{
				if(0 >= (count--))
				{
					return (clone>=1);
				}
				
				var u:int = v; if(nv<=u)u=0;
				v=u+1; if(nv<=v)v=0;
				var w:int=v+1;if(nv<=w)w=0;
				
				if(snip(contour, u,v,w,nv,V))
				{
					var a:int=V[u];
					var b:int=V[v];
					var c:int=V[w];
					
					var triangle:Array=new Array();
					if(isAntiClockwise(contour[a].x, contour[a].y,
						contour[b].x, contour[b].y,
						contour[c].x, contour[c].y))
					{
						triangle.push(new Point(contour[a].x, contour[a].y));
						triangle.push(new Point(contour[b].x, contour[b].y));
						triangle.push(new Point(contour[c].x, contour[c].y));
					}
					else
					{
						triangle.push(new Point(contour[a].x, contour[a].y));
						triangle.push(new Point(contour[c].x, contour[c].y));
						triangle.push(new Point(contour[b].x, contour[b].y));
					}
					result.push(triangle);
					
					clone++;
					var s:int=v;
					var t:int=v+1;
					for(; t<nv;t++,s++){V[s]=V[t];}
					nv--;
					
					count = 2*nv;
				}
			}
			
			return true;
		}
		
		private static function area(contour:Array):Number
		{
			var n:int = contour.length;
			var A:Number = 0.0;
			var p:int=n-1;
			var q:int = 0;
			for(;q<n; p=q++)
			{
				A+= contour[p].x*contour[q].y-contour[q].x*contour[p].y;
			}
			return A*0.5;
		}
		
		private static function insideTriangle(ax:Number, ay:Number, bx:Number, by:Number,  cx:Number, cy:Number, px:Number, py:Number):Boolean
		{
			var dx:Number=cx-bx;//ax
			var dy:Number=cy-by;//ay
			var ex:Number=ax-cx;//bx
			var ey:Number=ay-cy;//by
			var fx:Number=bx-ax;//cx
			var fy:Number=by-ay;//cy
			
			var apx:Number=px-ax;
			var apy:Number=py-ay;
			var bpx:Number=px-bx;
			var bpy:Number=py-by;
			var cpx:Number=px-cy;
			var cpy:Number=py-cy;
			
			var aCrossbp:Number=dx*bpy-dy*bpx;//ax
			var cCrossap:Number=fx*apy-fy*apx;//cx
			var bCrosscp:Number=ex*cpy-ey*cpx;//bx
			
			return ((aCrossbp >= 0.0) && (bCrosscp >= 0.0) && (cCrossap >= 0.0));
		}
		
		private static function snip(contour:Array, u:int, v:int, w:int, n:int, V:Array):Boolean
		{
			var p:int = 0;
			var Ax:Number = contour[V[u]].x;
			var Ay:Number = contour[V[u]].y;
			var Bx:Number = contour[V[v]].x;
			var By:Number = contour[V[v]].y;
			var Cx:Number = contour[V[w]].x;
			var Cy:Number = contour[V[w]].y;
			var Px:Number;
			var Py:Number;
			
			if(TRIANGULATEEPSILON >(((Bx-Ax)*(Cy-Ay)) - ((By-Ay)*(Cx-Ax))) ) return false;
			
			for(p=0; p<n; ++p)
			{
				if(p==u || p==v || p == w)continue;
				Px=contour[V[p]].x;
				Py=contour[V[p]].y;
				if(insideTriangle(Ax,Ay,Bx,By,Cx,Cy,Px,Py))
					return false;
			}
			
			return true;
		}
		
		private static function isAntiClockwise(Ax:Number, Ay:Number, Bx:Number, By:Number,	Cx:Number, Cy:Number):Boolean
		{
			var abx:Number = Bx-Ax;
			var aby:Number = By-Ay;
			var acx:Number = Cx-Ax;
			var acy:Number = Cy-Ay;
			
			var crossP:Number = abx*acy-aby*acx;
			
			return (crossP>0 || Math.abs(crossP)<1e-6);
		}
		
		public static function CompuRadian(v1:Vector3D, v2:Vector3D):Number
		{
			if(v1 == null || v2 == null)
			{
				return 0;
			}
			
			v1.normalize();
			v2.normalize();
			var r1:Number = v1.length;
			var r2:Number = v2.length;
			var d:Number = v1.dotProduct(v2);
			var n:Number = r1 * r2;
			if(n == 0)
			{
				return 0;
			}
			
			var v:Number = d / n;
			v = v > 1.0 ? 1.0 : (v < -1.0 ? -1.0 : v);
			var a:Number = Math.acos(v);
			
			var p:Number = Math.abs(a);
			p = p > Math.PI * 2 ? p - Math.PI * 2 * Number(int(p / Math.PI)):p;
			var t:Number = a > 0 ? 1: -1;
			return p > Math.PI ? (p - Math.PI * 2) * t : p * t;
		}
		
		public static function CompuAbsDegree2D(v1:Vector3D, v2:Vector3D):Number
		{
			var r:Number = Vector3D.angleBetween(v1, v2);
			var a:Number = r * 180 / Math.PI;
			if(a < 1)
			{
				return 0;
			}
			else if(a > 179)
			{
				return 180;
			}
			
			return a;
		}
		
		public static function CompuDegree2D(v1:Vector3D, v2:Vector3D):Number
		{
			if(v1 == null || v2 == null)
			{
				return 0;
			}
			
			v1.normalize();
			v2.normalize();
			
			v1.z = 0;
			v2.z = 0;
			
			var r:Number = Vector3D.angleBetween(v1, v2);
			var a:Number = r * 180 / Math.PI;
			if(a < 1)
			{
				return 0;
			}
			else if(a > 179)
			{
				return 180;
			}
			
			if(!IscClockWise(0, 0, v1.x, v1.y, v2.x, v2.y))
			{
				a *= -1;
			}
			
			return a;
		}
		
		public static function AmendSingleMM(v:Number):Number
		{
			var cv:Number = v * 1000;
			var c:int = int(cv > 0 ? cv + 0.5 : (cv < 0 ? cv - 0.5 : cv));
			return Number(c) * 0.001;
		}
		
		public static function AmendSingleCM(v:Number):Number
		{
			var cv:Number = v * 100;
			var c:int = int(cv > 0 ? cv + 0.5 : (cv < 0 ? cv - 0.5 : cv));
			return Number(c) * 0.01;
		}
		
		public static function AmendSingleDM(v:Number):Number
		{
			var cv:Number = v * 10;
			var c:int = int(cv > 0 ? cv + 0.5 : (cv < 0 ? cv - 0.5 : cv));
			return Number(c) * 0.1;
		}
		
		public static function AmendInt(v:Number):Number
		{
			var cv:Number = v;
			var c:int = int(cv > 0 ? cv + 0.5 : (cv < 0 ? cv - 0.5 : cv));
			return Number(c);
		}
		
		public static function Equal(v1:Vector3D, v2:Vector3D, tolerance:Number):Boolean
		{
			if(Math.abs(v1.x - v2.x) < tolerance)
			{
				if(Math.abs(v1.y - v2.y) < tolerance)
				{
					if(Math.abs(v1.z - v2.z) < tolerance)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function EqualPoints(v1:Point, v2:Point, tolerance:Number):Boolean
		{
			if(Math.abs(v1.x - v2.x) < tolerance)
			{
				if(Math.abs(v1.y - v2.y) < tolerance)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function EqualNormalMM(v1:Vector3D, v2:Vector3D):Boolean
		{
			var cv1:Vector3D = v1.clone();
			var cv2:Vector3D = v2.clone();
			cv1.normalize();
			cv2.normalize();
			if(Math.abs(cv1.x - cv2.x) < 0.001)
			{
				if(Math.abs(cv1.y - cv2.y) < 0.001)
				{
					if(Math.abs(cv1.z - cv2.z) < 0.001)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function EqualNormalCM(v1:Vector3D, v2:Vector3D):Boolean
		{
			var cv1:Vector3D = v1.clone();
			var cv2:Vector3D = v2.clone();
			cv1.normalize();
			cv2.normalize();
			if(Math.abs(cv1.x - cv2.x) < 0.01)
			{
				if(Math.abs(cv1.y - cv2.y) < 0.01)
				{
					if(Math.abs(cv1.z - cv2.z) < 0.01)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function EqualNormalDM(v1:Vector3D, v2:Vector3D):Boolean
		{
			var cv1:Vector3D = v1.clone();
			var cv2:Vector3D = v2.clone();
			cv1.normalize();
			cv2.normalize();
			if(Math.abs(cv1.x - cv2.x) < 0.1)
			{
				if(Math.abs(cv1.y - cv2.y) < 0.1)
				{
					if(Math.abs(cv1.z - cv2.z) < 0.1)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function CompuLineMaterix(start:Vector3D, end:Vector3D):Matrix3D
		{
			var direction:Vector3D = new Vector3D(end.x - start.x, end.y - start.y, 0);
			direction.normalize();
			var angle:Number = Math.atan2(direction.y, direction.x) * 180 / Math.PI;
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendRotation(angle, Vector3D.Z_AXIS);
			matrix.appendTranslation(start.x, start.y, 0);
			return matrix;
		}
		
		public static function CompuLineRotationMaterix(start:Vector3D, end:Vector3D):Matrix3D
		{
			var direction:Vector3D = new Vector3D(end.x - start.x, end.y - start.y, 0);
			direction.normalize();
			var angle:Number = Math.atan2(direction.y, direction.x) * 180 / Math.PI;
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();
			matrix.appendRotation(angle, Vector3D.Z_AXIS);
			return matrix;
		}
		
		public static function CompuLineRadian(start:Vector3D, end:Vector3D):Number
		{
			var direction:Vector3D = new Vector3D(end.x - start.x, end.y - start.y, 0);
			direction.normalize();
			return Math.atan2(direction.y, direction.x);
		}
		
		/**
		 * 判断两线段相交，并包含
		 */
		public static function IsSameLineAndContains(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number):Boolean
		{
			
			//return true;
			var b:Boolean=false;
			var miny1:Number=Math.min(y1, y2);
			var maxy1:Number=Math.max(y1, y2);
			var miny3:Number=Math.min(y3, y4);
			var maxy3:Number=Math.max(y3, y4);
			
			var minx1:Number=Math.min(x1, x2);
			var maxx1:Number=Math.max(x1, x2);
			var minx3:Number=Math.min(x3, x4);
			var maxx3:Number=Math.max(x3, x4);
			
			//相等则直接返回
			if (Math.abs(minx1 - minx3) < 0.1 && Math.abs(miny1 - miny3) < 0.1 && Math.abs(maxx1 - maxx3) < 0.1 && Math.abs(maxy1 - maxy3) < 0.1)
			{
				return true;
			}
			// 如有一点相同，则返回
			if (Math.abs(x1 - x3) < 0.1 && Math.abs(y1 - y3) < 0.1)
			{
				return true;
			}
			if (Math.abs(x1 - x4) < 0.1 && Math.abs(y1 - y4) < 0.1)
			{
				return true;
			}
			if (Math.abs(x2 - x3) < 0.1 && Math.abs(y2 - y3) < 0.1)
			{
				return true;
			}
			if (Math.abs(x2 - x4) < 0.1 && Math.abs(y2 - y4) < 0.1)
			{
				return true;
			}
			
			//如最小值大于另外一个的最大值时，不可能相交
			if (Great(minx1, maxx3) || Less(maxx1, minx3))
			{
				return false;
			}
			if (Great(miny1, maxy3) || Less(maxy1, miny3))
			{
				return false;
			}
			
			var vx1:Number=x1 - x2; // vx1=B;
			if (Math.abs(vx1) < 0.1)
			{
				vx1=0;
			}
			
			var vy1:Number=y1 - y2; //  vy=-A   
			if (Math.abs(vy1) < 0.1)
			{
				vy1=0;
			}
			//A=Y2-Y1
			// B=X1-X2 
			// C=X2Y1-X1Y2
			var vx2:Number=x3 - x4;
			if (Math.abs(vx2) < 0.1)
			{
				vx2=0;
			}
			var vy2:Number=y3 - y4;
			if (Math.abs(vy2) < 0.1)
			{
				vy2=0;
			}
			
			if (vx1 != 0 && vx2 != 0) //线段不和x轴垂直
			{
				
				var k1:Number=Number(vy1 / vx1);
				var k2:Number=Number(vy2 / vx2);
				var tempC1:Number=y1 * x2 - y2 * x1;
				var tempC2:Number=y3 * x4 - y4 * x3;
				
				if ((Math.abs(k1 - k2) < 0.1) || (Math.abs(k1 + k2) < 0.1)) //两个线段的斜率相同，根据点到直线的距离判断
				{
					var dis:Number=poToLinDist(vx1, -vy1, tempC1, x3, y3);
					if (dis > 0.1)
					{
						
						return false;
					}
						
					else
					{
						
						return true;
						
					}
				}
					
				else
				{
					
					var solutionX:Number=computeRoot(-vy1, vx1, tempC1,	-vy2, vx2, tempC2);
					
					//  solutionY=Number(vy1*solutionX-tempC1)/(  vx1);
					
					//					var  max:Number= Math.max( aLine.arrayX[0] ,aLine.arrayX[1]);
					//					var  min:Number=Math.min( aLine.arrayX[0] ,aLine.arrayX[1]);
					//					var  max1:Number= Math.max( aLine.arrayX[2] ,aLine.arrayX[3]);
					//					var  min1:Number=Math.min( aLine.arrayX[2] ,aLine.arrayX[3]);
					//					if (solutionX < maxx1 && solutionX > minx1 && (Math.abs(solutionX - x3) < 0.1 || Math.abs(solutionX - x4) < 0.1))
					//					{
					//						return true;
					//					}
					//					if (solutionX < maxx3 && solutionX > minx3 && (Math.abs(solutionX - x1) < 0.1 || Math.abs(solutionX - x2) < 0.1))
					//					{
					//						return true;
					//					}
					if (LessOrEqual(solutionX, maxx1) && GreatOrEqual(solutionX, minx1) && LessOrEqual(solutionX, maxx3) && GreatOrEqual(solutionX, minx3))
					{
						return true;
					}
						
					else
					{
						return false;
					}
					
				}
				
			}
			else
			{
				if (Math.abs(x1 - x3) < 0.1)
				{
					return true;
				}
			}
			
			return b;
		}
		
		private static function LessOrEqual(X:Number, Y:Number):Boolean
		{
			return (X < Y || Math.abs(X - Y) < 0.1);
		}
		
		
		
		private static function GreatOrEqual(X:Number, Y:Number):Boolean
		{
			return (X > Y || Math.abs(X - Y) < 0.1);
		}
		
		private static function Less(X:Number, Y:Number):Boolean
		{
			return (X + 0.1 < Y);
		}
		
		private static function Great(X:Number, Y:Number):Boolean
		{
			return (X - 0.1 > Y);
		}
		
		private static function poToLinDist(A:Number, B:Number, C:Number, x0:int, y0:int):Number //点到直线的距离公式
		{
			
			var absTemp:Number=Math.abs(A * x0 + B * y0 + C);
			var sqrtTemp:Number=Math.sqrt(A * A + B * B);
			return Number(absTemp / sqrtTemp);
		}
		
		
		private static function computeRoot(A1:Number, B1:Number, C1:Number, //根据方程一般形式中的A,B,C系数求方程组的根									
									 A2:Number, B2:Number, C2:Number):Number
		{
			return Number(C2 * B1 - C1 * B2) / Number(A1 * B2 - A2 * B1)
			
		}		
		
		/**
		 *
		 * 定义：平面上的三点P1(x1,y1),P2(x2,y2),P3(x3,y3)的面积量：
		 *                   |x1     x2     x3|
		 * S(P1,P2,P3)   =   |y1     y2     y3|   =   (x1-x3)*(y2-y3)   -   (y1-y3)(x2-x3)
		 *                   | 1      1      1|
		 * 当P1P2P3逆时针时S为正的，当P1P2P3顺时针时S为负的。
		 */
		public static function IscClockWise(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Boolean
		{
			if (((x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3)) > 0)
				return false;
			
			return true;
		}
		
		public static function GetIntersectionFor2Segment(a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D):Array
		{
			
			var vLine11:Vector3D = new Vector3D(a.x,a.y,a.z);
			var vLine12:Vector3D = new Vector3D(b.x,b.y,c.z);
			var vLine21:Vector3D = new Vector3D(c.x,c.y,c.z);				
			var vLine22:Vector3D = new Vector3D(d.x,d.y,d.z);
			
			var vOutPos:Vector3D = new Vector3D;
			
			var bRet:Boolean = false;
			var array:Array = new Array;
			array.push(bRet);
			
			//  平面图 z = 0
			var A1:Number  =   vLine12.y - vLine11.y;  		
			var B1:Number  =   vLine11.x - vLine12.x;
			var C1:Number  =   vLine12.x * vLine11.y   -   vLine11.x * vLine12.y;   
			
			var A2:Number  =   vLine22.y - vLine21.y;     
			var B2:Number  =   vLine21.x - vLine22.x;   
			var C2:Number  =   vLine22.x * vLine21.y   -   vLine21.x * vLine22.y;   
			
			if( Math.abs(A1*B2 - B1*A2) < 0.001)         
			{   
				/*			if( Math.abs( (A1+B1)*C2 - (A2+B2)*C1 ) )   
				return false;	// 共线   
				else
				return false;  */
				return array;
			}   
			else
			{   
				vOutPos.x = ( B2*C1 - B1*C2 ) / ( A2*B1 - A1*B2 );   
				vOutPos.y = ( A1*C2 - A2*C1 ) / ( A2*B1 - A1*B2 );   
				vOutPos.z = 0;   
			} 
			
			var temp:Number;
			if( vLine12.x < vLine11.x ) 
			{
				temp 	  = vLine12.x;
				vLine12.x = vLine11.x;
				vLine11.x = temp;
			}
			
			if( vLine12.y < vLine11.y ) 
			{
				temp 	  = vLine12.y;
				vLine12.y = vLine11.y;
				vLine11.y = temp;
			}
			
			if( vLine22.x < vLine21.x ) 
			{
				temp 	  = vLine22.x;
				vLine22.x = vLine21.x;
				vLine21.x = temp;
			}			
			
			if( vLine22.y < vLine21.y ) 
			{
				temp 	  = vLine22.y;
				vLine22.y = vLine21.y;
				vLine21.y = temp;
			}			
			
			// 判定交点是否在线段内(含端点相交)
			if( CheckEqualAndBig( vOutPos.x, vLine11.x) && CheckEqualAndSmall( vOutPos.x, vLine12.x ) && 
				CheckEqualAndBig( vOutPos.y, vLine11.y) && CheckEqualAndSmall( vOutPos.y, vLine12.y ) &&
				CheckEqualAndBig( vOutPos.x, vLine21.x) && CheckEqualAndSmall( vOutPos.x, vLine22.x ) &&
				CheckEqualAndBig( vOutPos.y, vLine21.y) && CheckEqualAndSmall( vOutPos.y, vLine22.y ))
			{
				array[0] = true;
				array[1] = vOutPos.x;
				array[2] = vOutPos.y;
				array[3] = vOutPos.z;
				return array;
			}
			
			return array;			
		}
		
		private static function CheckEqualAndBig( fA:Number, fB:Number)
		{
			if( Math.abs( fA - fB ) < 0.001)
				return true;
			else 
			{
				if( fA - fB > 0 )
					return true;
			}
			return false;
		}
		
		// 浮点数<=
		private static function CheckEqualAndSmall( fA:Number, fB:Number )
		{
			if( Math.abs( fA - fB ) < 0.001 )
				return true;
			else 
			{
				if( fA - fB < 0 )
					return true;
			}
			
			return false;
		}
		
		public static function CheckMeshHaveNormals(mesh:Mesh):Boolean
		{
			if(mesh == null || mesh.geometry == null)
			{
				return false;
			}
			
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			if(attributes == null || attributes.length == 0)
			{
				return false;
			}
			
			var haveNormals:Boolean = false;
			if(attributes.indexOf(VertexAttributes.NORMAL)>=0)
			{
				haveNormals = true;	
			}
//			for each(var attribute:uint in attributes)
//			{
//				if(attribute==VertexAttributes.NORMAL)
//				{
//					haveNormals = true;	
//					break;
//				}
//			}
			return haveNormals;
		}
		
		public static function CheckMeshHaveTextures0(mesh:Mesh):Boolean
		{
			if(mesh == null || mesh.geometry == null)
			{
				return false;
			}
			
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			if(attributes == null || attributes.length == 0)
			{
				return false;
			}
			
			var haveTextures:Boolean = false;
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.TEXCOORDS[0]:
					{
						haveTextures = true;													
					}
						break;
				}
			}
			
			return haveTextures;
		}
		
		public static function CheckMeshHaveTextures1(mesh:Mesh):Boolean
		{
			if(mesh == null || mesh.geometry == null)
			{
				return false;
			}
			
			var attributes:Array = mesh.geometry.getVertexStreamAttributes(0);
			if(attributes == null || attributes.length == 0)
			{
				return false;
			}
			
			var haveTextures:Boolean = false;
			for each(var attribute:uint in attributes)
			{
				switch(attribute)
				{
					case VertexAttributes.TEXCOORDS[1]:
					{
						haveTextures = true;													
					}
						break;
				}
			}
			
			return haveTextures;
		}
		
		public static function GetRoundPoints(vertices:Vector.<Number>, makeInt:Boolean = false):Array
		{
			if(vertices == null || vertices.length == 0)
			{
				return null;
			}
			
			var points:Vector.<Point> = new Vector.<Point>();
			for(var i:int = 0; i<vertices.length; i+=3 )
			{
				var point:Point = new Point(vertices[i], vertices[i+1]);
				points.push(point);
			}
			
			var basepoly:Array = new Array();
			basepoly.push(points[0], points[1], points[2]);
			var needReBuildPoly:Array = new Array();
			var compuCount:int = 0;
			var compuStartIndex:int = 3;
			var firstCompu:Boolean = true;
			var lastNeedReBuildPolyCount:int = 0;
			do
			{
				lastNeedReBuildPolyCount = needReBuildPoly.length;
				needReBuildPoly.length = 0;
				
				for(var i:int = compuStartIndex; i<points.length; i+=3)
				{
					var sub:Array= new Array();
					sub.push(points[i], points[i+1], points[i+2]);
					var clip:Array = null;
					try
					{
					//	clip=GPCPolygonClip.gpc_polygon_clip(basepoly, sub, GPCPolygonClip.GPC_UNION);
						clip = cc_gpcclipper(3, basepoly, sub);
					}
					catch(error:Error)
					{
						clip=Clipper.clipPolygon(basepoly, sub, 1);
					}
				//	var clip:Array=GPCPolygonClip.gpc_polygon_clip(basepoly, sub, GPCPolygonClip.GPC_UNION);
				//	var clip:Array=Clipper.clipPolygon(basepoly, sub, 1);
					if(clip.length == 0 || (clip[0].length <= basepoly.length && compuCount != 5))
					{
						needReBuildPoly.push(points[i].clone());
						needReBuildPoly.push(points[i+1].clone());
						needReBuildPoly.push(points[i+2].clone());
						continue;
					}
					basepoly.length = 0;
					for( var j:int = 0; j<clip[0].length; j++ )  
					{
						basepoly.push(new Point(clip[0][j].x,clip[0][j].y));
					}
				}
				
				if(needReBuildPoly.length > 0)
				{
					points.length = 0;
					for( var j:int = 0; j<needReBuildPoly.length; j++ )  
					{
						points.push(needReBuildPoly[j]);
					}
				}
				
				compuStartIndex = 0;
				firstCompu = false;
				
				compuCount++;
			}while(needReBuildPoly.length > 0 && compuCount < 200);
			
			GeomUtil.removeColinearPoint(basepoly, 0.1);
			
			if(makeInt)
			{
				for(var i:int = 0; i<basepoly.length; i++)
				{
					var point:Point = basepoly[i] as Point;
					point.x = AmendInt(point.x);
					point.y = AmendInt(point.y);
				}
			}

			return basepoly; 
		}
		
		public static function AmendLineMeshUV(mesh:Mesh, stage3D:Stage3D):Boolean
		{
			if(mesh == null || stage3D == null)
			{
				return false;
			}
			
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			var vecMax:Vector3D  = new Vector3D(mesh.boundBox.maxX,mesh.boundBox.maxY,mesh.boundBox.maxZ);
			var vecMin:Vector3D  = new Vector3D(mesh.boundBox.minX,mesh.boundBox.minY,mesh.boundBox.minZ);					
			vecMax = mesh.matrix.transformVector(vecMax);
			vecMin = mesh.matrix.transformVector(vecMin);
			
			var length:Number = Math.abs(vecMax.x - vecMin.x);
			var width:Number = Math.abs(vecMax.y - vecMin.y);
			var height:Number = Math.abs(vecMax.z - vecMin.z);
			
			var mat1:TextureMaterial=mesh.getSurface(0).material as TextureMaterial;
			var positions:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=null;
			try
			{
				normals=mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			catch(error:Error)
			{
				return false;
			}
			var uvs:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			var fl:Number=new Vector3D(Math.abs(mesh.boundBox.maxX - mesh.boundBox.minX), Math.abs(mesh.boundBox.maxY - mesh.boundBox.minY), 0).length;
			if(fl <= 0)
			{
				fl = 100;
			}
			var fw:Number=Math.abs(mesh.boundBox.maxZ - mesh.boundBox.minZ);
			
			var normalLeftRight:Vector3D = new Vector3D(1, 0, 0);//left right
			var normalTopBottom:Vector3D = new Vector3D(0, 1, 0);//top Bottom
			var normalFrontBack:Vector3D = new Vector3D(0, 0, 1);//front back
			
			var quarterRadian:Number = Math.PI / 4;
			var invQuarterRadian:Number = Math.PI - quarterRadian;
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				var normal:Vector3D = new Vector3D(normals[i*3], normals[i*3 + 1], normals[i*3 + 2]);
				var u:Number = Math.abs(x - vecMin.x) / length;
				var v:Number = Math.abs(y - vecMin.y) / length;
				var angle:Number = CompuRadian(normal, normalLeftRight);
				
				if (angle <= quarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - y / fl;
					uvs[i*2 + 1] = 1 - z / fw;
				}
				
				if (angle >= invQuarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = y / fl;
					uvs[i*2 + 1] = 1 - z / fw;
				}
				
				angle = CompuRadian(normal, normalFrontBack);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = x / fl;
					uvs[i*2 + 1] = 1 - y / fw;
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - x / fl;
					uvs[i*2 + 1] = 1 - y / fw;
				}
				
				angle = CompuRadian(normal, normalTopBottom);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = 1 - x / fl;
					uvs[i*2 + 1] = 1 - z / fw;
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = x / fl;
					uvs[i*2 + 1] = 1 - z / fw;
				}
			}
			
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			mesh.geometry.upload(stage3D.context3D);
			//	Main.m_A3D.m_scene.gMain.m_A3D.onContextCreate(null);
			
			return true;
		}
		
		public static function AdaptMeshUVFromSize(mesh:Mesh, length:Number, width:Number, height:Number, stage3D:Stage3D, scaleMode:Boolean = true):Boolean
		{
			if(mesh == null || length < 1 || width < 1 || stage3D == null)
			{
				return false;
			}
			
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			var vecMax:Vector3D  = new Vector3D(mesh.boundBox.maxX,mesh.boundBox.maxY,mesh.boundBox.maxZ);
			var vecMin:Vector3D  = new Vector3D(mesh.boundBox.minX,mesh.boundBox.minY,mesh.boundBox.minZ);			
			//		vecMax = mesh.matrix.transformVector(vecMax);
			//		vecMin = mesh.matrix.transformVector(vecMin);
			
		//	var lx:Number = Math.abs(vecMax.x - vecMin.x);
		//	var ly:Number = Math.abs(vecMax.y - vecMin.y);
		//	var lz:Number = Math.abs(vecMax.z - vecMin.z);
			
			var lx:Number = scaleMode ? length * 0.1 : length;
			var ly:Number = scaleMode ? width * 0.1 : width;
			var lz:Number = scaleMode ? height * 0.1 : height;
			
			lx = lx == 0 ? 1 : lx;
			ly = ly == 0 ? 1 : ly;
			lz = lz == 0 ? 1 : lz;
			
			var positions:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=null;
			if(height == 0)
			{
				normals = null;
			}
			else
			{
				try
				{
					normals=mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
				}
				catch(error:Error)
				{
					return false;
				}
			}			

			var uvs:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			var normalLeftRight:Vector3D = new Vector3D(1, 0, 0);//left right
			var normalTopBottom:Vector3D = new Vector3D(0, 1, 0);//top Bottom
			var normalFrontBack:Vector3D = new Vector3D(0, 0, 1);//front back
			
			var quarterRadian:Number = Math.PI / 4;
			var invQuarterRadian:Number = Math.PI - quarterRadian;
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				var normal:Vector3D = normals == null ? new Vector3D(0, 0, 1) : new Vector3D(normals[i*3], normals[i*3 + 1], normals[i*3 + 2]);
			//	var u:Number = Math.abs(x - vecMin.x) / length;
			//	var v:Number = Math.abs(y - vecMin.y) / length;
				
				if(normals == null)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = x / lx;
					uvs[i*2 + 1] = 1 - y / ly;
				}
				else
				{
					var angle:Number = CompuRadian(normal, normalLeftRight);
					
					if (angle <= quarterRadian)
					{
						var z:Number = position.z - vecMin.z;
						var y:Number = position.y - vecMin.y;
						uvs[i*2] = 1 - y / ly;
						uvs[i*2 + 1] = 1 - z / lz;
					}
					
					if (angle >= invQuarterRadian)
					{
						var z:Number = position.z - vecMin.z;
						var y:Number = position.y - vecMin.y;
						uvs[i*2] = y / ly;
						uvs[i*2 + 1] = 1 - z / lz;
					}
					
					angle = CompuRadian(normal, normalFrontBack);
					
					if (angle <= quarterRadian)
					{
						var x:Number = position.x - vecMin.x;
						var y:Number = position.y - vecMin.y;
						uvs[i*2] = x / lx;
						uvs[i*2 + 1] = 1 - y / ly;
					}
					
					if (angle >= invQuarterRadian)
					{
						var x:Number = position.x - vecMin.x;
						var y:Number = position.y - vecMin.y;
						uvs[i*2] = 1 - x / lx;
						uvs[i*2 + 1] = 1 - y / ly;
					}
					
					angle = CompuRadian(normal, normalTopBottom);
					
					if (angle <= quarterRadian)
					{
						var x:Number = position.x - vecMin.x;
						var z:Number = position.z - vecMin.z;
						uvs[i*2] = 1 - x / lx;
						uvs[i*2 + 1] = 1 - z / lz;
					}
					
					if (angle >= invQuarterRadian)
					{
						var x:Number = position.x - vecMin.x;
						var z:Number = position.z - vecMin.z;
						uvs[i*2] = x / lx;
						uvs[i*2 + 1] = 1 - z / lz;
					}
				}
			}
			
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			mesh.geometry.upload(stage3D.context3D);
			
			return true;
		}
		
		public static function AdaptMeshUV(mesh:Mesh, stage3D:Stage3D):Boolean
		{
			if(mesh == null || stage3D == null)
			{
				return false;
			}
			
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			var vecMax:Vector3D  = new Vector3D(mesh.boundBox.maxX,mesh.boundBox.maxY,mesh.boundBox.maxZ);
			var vecMin:Vector3D  = new Vector3D(mesh.boundBox.minX,mesh.boundBox.minY,mesh.boundBox.minZ);			
	//		vecMax = mesh.matrix.transformVector(vecMax);
	//		vecMin = mesh.matrix.transformVector(vecMin);
			
			var lx:Number = Math.abs(vecMax.x - vecMin.x);
			var ly:Number = Math.abs(vecMax.y - vecMin.y);
			var lz:Number = Math.abs(vecMax.z - vecMin.z);
			
		//	var mat1:TextureMaterial=mesh.getSurface(0).material as TextureMaterial;
			var positions:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=null;
			try
			{
				normals=mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			catch(error:Error)
			{
				return false;
			}
			var uvs:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
		
			var normalLeftRight:Vector3D = new Vector3D(1, 0, 0);//left right
			var normalTopBottom:Vector3D = new Vector3D(0, 1, 0);//top Bottom
			var normalFrontBack:Vector3D = new Vector3D(0, 0, 1);//front back
			
			var quarterRadian:Number = Math.PI / 4;
			var invQuarterRadian:Number = Math.PI - quarterRadian;
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				var normal:Vector3D = new Vector3D(normals[i*3], normals[i*3 + 1], normals[i*3 + 2]);
				var u:Number = Math.abs(x - vecMin.x) / length;
				var v:Number = Math.abs(y - vecMin.y) / length;
				var angle:Number = CompuRadian(normal, normalLeftRight);
				
				if (angle <= quarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - y / ly;
					uvs[i*2 + 1] = 1 - z / lz;
				}
				
				if (angle >= invQuarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = y / ly;
					uvs[i*2 + 1] = 1 - z / lz;
				}
				
				angle = CompuRadian(normal, normalFrontBack);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = x / lx;
					uvs[i*2 + 1] = 1 - y / ly;
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - x / lx;
					uvs[i*2 + 1] = 1 - y / ly;
				}
				
				angle = CompuRadian(normal, normalTopBottom);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = 1 - x / lx;
					uvs[i*2 + 1] = 1 - z / lz;
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = x / lx;
					uvs[i*2 + 1] = 1 - z / lz;
				}
			}
			
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			mesh.geometry.upload(stage3D.context3D);
			
			return true;
		}
		/**
		 * 更新模型的UV坐标 
		 * @param mesh
		 * @param stage3D
		 * @param forceScale
		 * @return 
		 * 
		 */		
		public static function UpdateMeshUV(mesh:Mesh, stage3D:Stage3D, forceScale:Boolean = false):Boolean
		{
			if(mesh == null || stage3D == null)
			{
				return false;
			}
			var mat1:TextureMaterial=mesh.getSurface(0).material as TextureMaterial;
			if(mat1==null)
			{
				return false;
			}
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			
			var vecMax:Vector3D  = new Vector3D(mesh.boundBox.maxX,mesh.boundBox.maxY,mesh.boundBox.maxZ);
			var vecMin:Vector3D  = new Vector3D(mesh.boundBox.minX,mesh.boundBox.minY,mesh.boundBox.minZ);					
			vecMax = mesh.matrix.transformVector(vecMax);
			vecMin = mesh.matrix.transformVector(vecMin);
			
			var length:Number = Math.abs(vecMax.x - vecMin.x);
			var width:Number = Math.abs(vecMax.y - vecMin.y);
			var height:Number = Math.abs(vecMax.z - vecMin.z);
			var positions:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=null;
			//cloud 2017.12.15 必须增加trycatch,有些模型资源没有法线信息会报错
			try
			{
				normals=mesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			}
			catch(e:Error)
			{
				print("UpdateMeshUV->"+mesh.name+" 获取法线信息失败！");
				return false;
			}
			var uvs:Vector.<Number>=mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			var fl:Number=100;
			var fw:Number=100;
			if(mat1.diffuseMap is L3DBitmapTextureResource)
			{
				fl=(mat1.diffuseMap as L3DBitmapTextureResource).Height;
				fw=(mat1.diffuseMap as L3DBitmapTextureResource).Width;
				if(!(mesh is L3DMesh) || forceScale)
				{
					fl *= 0.1;
					fw *= 0.1;
				}
			}
			
			var normalLeftRight:Vector3D = new Vector3D(1, 0, 0);//left right
			var normalTopBottom:Vector3D = new Vector3D(0, 1, 0);//top Bottom
			var normalFrontBack:Vector3D = new Vector3D(0, 0, 1);//front back
			
			var quarterRadian:Number = Math.PI / 4;
			var invQuarterRadian:Number = Math.PI - quarterRadian;
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				var normal:Vector3D = new Vector3D(normals[i*3], normals[i*3 + 1], normals[i*3 + 2]);
				var u:Number = Math.abs(x - vecMin.x) / length;
				var v:Number = Math.abs(y - vecMin.y) / length;
				var angle:Number = CompuRadian(normal, normalLeftRight);
				
				if (angle <= quarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - y / (fl * mesh.scaleY);
					uvs[i*2 + 1] = 1 - z / (fw * mesh.scaleZ);
				}
				
				if (angle >= invQuarterRadian)
				{
					var z:Number = position.z - vecMin.z;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = y / (fl * mesh.scaleY);
					uvs[i*2 + 1] = 1 - z / (fw * mesh.scaleZ);
				}
				
				angle = CompuRadian(normal, normalFrontBack);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = x / (fl * mesh.scaleX);
					uvs[i*2 + 1] = 1 - y / (fw * mesh.scaleY);
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var y:Number = position.y - vecMin.y;
					uvs[i*2] = 1 - x / (fl * mesh.scaleX);
					uvs[i*2 + 1] = 1 - y / (fw * mesh.scaleY);
				}
				
				angle = CompuRadian(normal, normalTopBottom);
				
				if (angle <= quarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = 1 - x / (fl * mesh.scaleX);
					uvs[i*2 + 1] = 1 - z / (fw * mesh.scaleZ);
				}
				
				if (angle >= invQuarterRadian)
				{
					var x:Number = position.x - vecMin.x;
					var z:Number = position.z - vecMin.z;
					uvs[i*2] = x / (fl * mesh.scaleX);
					uvs[i*2 + 1] = 1 - z / (fw * mesh.scaleZ);
				}
			}
			
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			//cloud 2017.11.28
			mesh.geometry.upload(stage3D.context3D);
			return true;
		}
		
		public static function CopyMeshUV(srcMesh:Mesh, destMesh:Mesh, stage3D:Stage3D):Boolean
		{
			if(srcMesh == null || destMesh == null || stage3D == null)
			{
				return false;
			}

			var uvs:Vector.<Number>=srcMesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			var duvs:Vector.<Number>=destMesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			if(uvs == null || duvs == null || uvs.length != duvs.length)
			{
				return false;
			}
			
			for(var i:int=0;i<uvs.length;i++)
			{
				duvs[i] = uvs[i];
			}
			
			srcMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			srcMesh.geometry.upload(stage3D.context3D);
			destMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(duvs));
			destMesh.geometry.upload(stage3D.context3D);

			return true;
		}
		
		public static function AutoAmendWallMeshUV(wallMesh:Mesh, stage3D:Stage3D):Boolean
		{
			if(wallMesh == null || stage3D == null || wallMesh.name != "wall_in" || wallMesh is L3DMesh || !CheckMeshHaveNormals(wallMesh))
			{
				return false;
			}
			
			if(wallMesh.boundBox == null)
			{
				wallMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(wallMesh);
			}
			
			var positions:Vector.<Number>=wallMesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var normals:Vector.<Number>=wallMesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			var uvs:Vector.<Number>=wallMesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			var inormal:Vector3D = new Vector3D(normals[0], normals[1], 0);
			inormal.normalize();
			var icenter:Vector3D = new Vector3D((wallMesh.boundBox.maxX + wallMesh.boundBox.minX)/2, (wallMesh.boundBox.maxY + wallMesh.boundBox.minY)/2, 0);
			var pointA:Vector3D = new Vector3D();
			var pointB:Vector3D = new Vector3D();

			var center:Vector3D = new Vector3D((wallMesh.boundBox.minX + wallMesh.boundBox.maxX) / 2, (wallMesh.boundBox.minY + wallMesh.boundBox.maxY) / 2, (wallMesh.boundBox.minZ + wallMesh.boundBox.maxZ) / 2);
			var minPoint:Vector3D = new Vector3D(wallMesh.boundBox.minX, wallMesh.boundBox.minY, wallMesh.boundBox.minZ);
			var maxPoint:Vector3D = new Vector3D(wallMesh.boundBox.maxX, wallMesh.boundBox.maxY, wallMesh.boundBox.maxZ);
			var iheight:Number = wallMesh.boundBox.maxZ - wallMesh.boundBox.minZ;
			
			var size:Point = new Point(new Point(maxPoint.x - minPoint.x, maxPoint.y - minPoint.y).length, maxPoint.z - minPoint.z);
			if(size.x <= 0 || size.y <= 0)
			{
				return false;
			}
			
			var wnormals:Vector.<Number>=wallMesh.geometry.getAttributeValues(VertexAttributes.NORMAL);
			var wnormal:Vector3D = new Vector3D(wnormals[0], wnormals[1], 0);
			wnormal.normalize();
			
			var normal:Vector3D = wnormal.clone();
			var tmatrix:Matrix3D = new Matrix3D();
			tmatrix.identity();
			tmatrix.appendRotation(90,Vector3D.Z_AXIS);
			var leftNormal:Vector3D = tmatrix.transformVector(normal); 
			leftNormal.normalize();
			var leftPoint:Vector3D = center.add(new Vector3D(leftNormal.x * size.x * 0.5, leftNormal.y * size.x * 0.5, 0));
			leftPoint.z = 0;
			var rightPoint:Vector3D = center.add(new Vector3D(leftNormal.x * size.x * -0.5, leftNormal.y * size.x * -0.5, 0));
			rightPoint.z = 0;
			
			pointA.x = rightPoint.x;
			pointA.y = rightPoint.y;
			pointA.z = rightPoint.z;
			pointB.x = leftPoint.x;
			pointB.y = leftPoint.y;
			pointB.z = leftPoint.z;
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				uvs[i*2] = Math.abs(new Vector3D(position.x - pointA.x, position.y - pointA.y, 0).length) / size.x;
				uvs[i*2 + 1] = 1 - Math.abs(position.z - pointA.z) / size.y;
			}
			
			wallMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			wallMesh.geometry.upload(stage3D.context3D);
			
			return true;
		}
		
		public static function AutoAmendFloorMeshUV(floorMesh:Mesh, stage3D:Stage3D):Boolean
		{
			if(floorMesh == null || stage3D == null || floorMesh.name != "floor" || floorMesh is L3DMesh)
			{
				return false;
			}
			
			if(floorMesh.boundBox == null)
			{
				floorMesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(floorMesh);
			}
			
			var minPoint:Vector3D = new Vector3D(floorMesh.boundBox.minX, floorMesh.boundBox.minY, floorMesh.boundBox.minZ);
			var maxPoint:Vector3D = new Vector3D(floorMesh.boundBox.maxX, floorMesh.boundBox.maxY, floorMesh.boundBox.maxZ);
			var size:Vector3D = new Vector3D(Math.abs(maxPoint.x - minPoint.x), Math.abs(maxPoint.y - minPoint.y), Math.abs(maxPoint.z - minPoint.z));
			
			if(size.x == 0 || size.y == 0)
			{
				return false;
			}
			
			var positions:Vector.<Number>=floorMesh.geometry.getAttributeValues(VertexAttributes.POSITION);
			var uvs:Vector.<Number>=floorMesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
			
			var count:int = positions.length / 3;
			for(var i:int = 0; i<count; i++)
			{
				var position:Vector3D = new Vector3D(positions[i*3], positions[i*3 + 1], positions[i*3 + 2]);
				uvs[i*2] = Math.abs(position.x - minPoint.x) / size.x;
				uvs[i*2 + 1] = 1 - Math.abs(position.y - minPoint.y) / size.y;
			}
			
			floorMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvs));
			floorMesh.geometry.upload(stage3D.context3D);
			
			return true;
		}
		
		public static function PasteMaterial(mesh:Mesh, material:Material, stage3D:Stage3D):Boolean
		{
			if(mesh == null || material == null)
			{
				return false;
			}
			
			if(mesh.geometry == null || mesh.numSurfaces == 0)
			{
				return false;
			}
			
			if(!(material is StandardMaterial) && !(material is TextureMaterial) && !(material is LightMapMaterial))
			{
				return false;
			}
			
			var meshMaterial:Material = mesh.getSurface(0).material;
			if(!(meshMaterial is StandardMaterial) && !(meshMaterial is TextureMaterial) && !(meshMaterial is LightMapMaterial))
			{
				return false;
			}
			
			var texture:BitmapTextureResource = null;
			if(material is LightMapMaterial)
			{
				texture = (material as LightMapMaterial).diffuseMap as BitmapTextureResource;
			}
			else if(material is TextureMaterial)
			{
				texture = (material as TextureMaterial).diffuseMap as BitmapTextureResource;
			}
			else if(material is StandardMaterial)
			{
				texture = (material as StandardMaterial).diffuseMap as BitmapTextureResource;
			}
			
			if(texture == null)
			{
				return false;
			}
			
			var clonedBitmap:BitmapData = null;
			try
			{
				clonedBitmap = texture.data.clone();
			}
			catch(error:Error)
			{
				clonedBitmap = null;
			}
			
			if(clonedBitmap == null)
			{
				return false;
			}
			
			var ct:* = null;
			if(texture is L3DBitmapTextureResource)
			{
				ct = new L3DBitmapTextureResource(clonedBitmap, null, stage3D, false, (texture as L3DBitmapTextureResource).maxLength);
				ct.Width = (texture as L3DBitmapTextureResource).Width;
				ct.Height = (texture as L3DBitmapTextureResource).Height;
				ct.Code = (texture as L3DBitmapTextureResource).Code;
				ct.ERPCode = (texture as L3DBitmapTextureResource).ERPCode;
				ct.VRMMode = (texture as L3DBitmapTextureResource).VRMMode;
				ct.Name = (texture as L3DBitmapTextureResource).Name;
				ct.Brand = (texture as L3DBitmapTextureResource).Brand;
				ct.Family = (texture as L3DBitmapTextureResource).Family;
				ct.Url = (texture as L3DBitmapTextureResource).Url;
				ct.Price = (texture as L3DBitmapTextureResource).Price;
				ct.userData = (texture as L3DBitmapTextureResource).userData;
			}
			else
			{
				ct = new BitmapTextureResource(clonedBitmap);
				(ct as BitmapTextureResource).upload(stage3D.context3D);
			}
			
			if(meshMaterial is LightMapMaterial)
			{
				if((meshMaterial as LightMapMaterial).diffuseMap != null)
				{
					(meshMaterial as LightMapMaterial).diffuseMap.dispose();
					(meshMaterial as LightMapMaterial).diffuseMap = null;
				}
				(meshMaterial as LightMapMaterial).diffuseMap = ct;
			}
			else if(material is TextureMaterial)
			{
				if((meshMaterial as TextureMaterial).diffuseMap != null)
				{
					(meshMaterial as TextureMaterial).diffuseMap.dispose();
					(meshMaterial as TextureMaterial).diffuseMap = null;
				}
				(meshMaterial as TextureMaterial).diffuseMap = ct;
			}
			else if(material is StandardMaterial)
			{
				if((meshMaterial as StandardMaterial).diffuseMap != null)
				{
					(meshMaterial as StandardMaterial).diffuseMap.dispose();
					(meshMaterial as StandardMaterial).diffuseMap = null;
				}
				(meshMaterial as StandardMaterial).diffuseMap = ct;
			}
			
			UpdateMeshUV(mesh, stage3D);
			
			return true;
		}
		
		public static function PickMeshPosition(mesh:Mesh, camera:Camera3D, localX:Number, localY:Number):Vector3D
		{
			if(mesh == null || camera == null)
			{
				return null;
			}
			
			var localOrigin:Vector3D = new Vector3D();
			var localDirection:Vector3D = new Vector3D();
			camera.calculateRay(localOrigin, localDirection, localX, localY);
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendScale(mesh.scaleX, mesh.scaleY, mesh.scaleZ);
			matrix.appendRotation(mesh.rotationZ * 180 / Math.PI, Vector3D.Z_AXIS);
			matrix.appendTranslation(mesh.x, mesh.y, mesh.z);
			var invertMatrix:Matrix3D = matrix.clone();
			invertMatrix.invert();
			var cp:Vector3D = invertMatrix.transformVector(new Vector3D(localOrigin.x + localDirection.x, localOrigin.y + localDirection.y, localOrigin.z + localDirection.z));
			var origin:Vector3D = invertMatrix.transformVector(localOrigin);
			var direction:Vector3D = new Vector3D(cp.x - origin.x, cp.y - origin.y, cp.z - origin.z);
			direction.normalize();
			var data:RayIntersectionData = mesh.intersectRay(origin, direction);
			if(data == null)
			{
				return null;
			}
			
			return matrix.transformVector(data.point);
		}

		public static function AmendRadian(v:Number):Number
		{
			return Object3DUtils.toRadians(AmendDegree(Object3DUtils.toDegrees(v)));
		}
		
		public static function AmendDegree(v:Number):Number
		{
			if(v >= 360)
			{
				do
				{
					v -= 360;
				}
				while(v >= 360);
			}
			else if(v <= -360)
			{
				do
				{
					v += 360;
				}
				while(v <= -360);
			}
			if(v > 180)
			{
				v -= 360; 
			}
			else if(v < -180)
			{
				v += 360;
			}
			return v;
		}
		
		public static function CloneByteArray(buffer:ByteArray):ByteArray
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			
			var ebuffer:ByteArray = new ByteArray();
			ebuffer.writeBytes(buffer, 0, buffer.length);
			
			return ebuffer;
		}
		
		public static function GetColorValueARGBArray(color:uint):Array
		{
			var arr:Array = new Array();
			var vara:uint = color >> 24 & 0xFF;  
			var varr:uint = color >> 16 & 0xFF;  
			var varg:uint = color >> 8  & 0xFF;
			var varb:uint = color & 0xFF;
			var a:Number = Number(vara) / 255.0;
			var r:Number = Number(varr) / 255.0;
			var g:Number = Number(varg) / 255.0;
			var b:Number = Number(varb) / 255.0;
			arr.push(a);
			arr.push(r);
			arr.push(g);
			arr.push(b);
			
			return arr;
		}
		
		public static function GetColorValueRGBArray(color:uint):Array
		{
			var arr:Array = new Array();
			var varr:uint = color >> 16 & 0xFF;  
			var varg:uint = color >> 8  & 0xFF;
			var varb:uint = color & 0xFF;
			var r:Number = Number(varr) / 255.0;
			var g:Number = Number(varg) / 255.0;
			var b:Number = Number(varb) / 255.0;
			arr.push(r);
			arr.push(g);
			arr.push(b);
			
			return arr;
		}
		
		public static function GCClearance():void
		{  
			try
			{  
				new LocalConnection().connect("foo");  
				new LocalConnection().connect("foo");  
			}
			catch(error:Error)
			{  
				
			} 
			try
			{
				new LocalConnection().connect("gc");  
				new LocalConnection().connect("gc");  
			}
			catch(error:Error)
			{  
				
			}
			try
			{
				conn1 = new LocalConnection();
				conn1.connect("sban garbage collection 1");
				conn2 = new LocalConnection();
				conn2.connect("sban garbage collection 1");
			}
			catch(e :*)
			{
				
			}
			finally
			{
				conn1 = null;
				conn2 = null;
			}
			System.gc();
		}
		
	}
}
package 
{	
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	
	import model.geom.Trianglulate;
	
	// 此类巨坑，创建的拐角窗范围有问题，后人慎入 !!!
	public class L3DWindows extends EventDispatcher
	{
		private var windowsName:String = "";
		private var windowsLine:Array = new Array();
		private var windowsFloatLine:Array = new Array();
		private var windowsInnerLine:Array = new Array();
		private var windowHeight:int = 2000;
		private var windowOffGround:int = 0;
		private var windowThickness:int = 20;
		private var partitionSpace:int = 800;
		private var windowFrameWidth:int = 60;
		private var windowFrameThickness:int = 50;
		private var bottomWindowHeight:int = 500;
		private var floatDistance:int = 700;
		private var windowTableThickness:int = 25;
		private var edgeDistance:int = 20;
		private var wallThickness:int = 200;
		private var floatSide:int = 0;
		private var leftWindowLength:int = 0;
		private var rightWindowLength:int = 0;
		private var havePartitions:Boolean = true;
		private var windowFrameColor:uint = 0xCCCCCC;
		private var windowBoardColor:uint = 0xDDFFFF;
		private var windowWallColor:uint = 0xFFFFFF;
	//	private var windowTableColor:uint = 0xF0F099;
		private var windowTableColor:uint = 0xFFFFFF;
		private var windowTransparency:Number = 0.33;
		private var windowsMesh:L3DMesh = null;
		public static const CloseParamWindowForm:String = "CloseParamWindowForm";
		
		public function L3DWindows()
		{
			
		}
		
		public function Build(windowName:String, windowsLine:Array, stage3D:Stage3D):L3DMesh
		{
			if(windowsLine == null || windowsLine.length < 2 || stage3D == null)
			{
				return null;
			}
			
			this.windowsLine = windowsLine;
			
			var model:L3DMesh = new L3DMesh();
			model.x = 0;
			model.y = 0;
			model.z = 0;
			this.windowsName = windowName == null || windowName.length == 0 ? "WINDOWS" : windowName;
			model.name = this.windowsName;
			model.linkedData = BuildFloatRoundPoints();
			
			var editData:Array = new Array();
			editData.push(windowsName);
			editData.push(windowsLine);
			editData.push(windowOffGround);
			editData.push(windowHeight);
			editData.push(floatDistance);
			editData.push(floatSide);
			editData.push(wallThickness);
			model.editData = editData;
			
			var frameMesh:L3DMesh = BuildFrameMesh(stage3D);
			if(frameMesh == null)
			{
				return null;
			}
			frameMesh.Mode = 30;
			
			var boardMesh:L3DMesh = BuildBoardMesh(stage3D);
			if(boardMesh == null)
			{
				return null;
			}
			boardMesh.Mode = 30;
			
			model.addChild(frameMesh);
			model.addChild(boardMesh);	
			
			var floatMesh:L3DMesh = BuildFloatMesh(stage3D);
			if(floatMesh != null)
			{
				floatMesh.Mode = 30;
				model.addChild(floatMesh);
			}
			
			var tableMesh:L3DMesh = BuildTableMesh(stage3D);
			if(tableMesh != null)
			{
				tableMesh.Mode = 30;
				model.addChild(tableMesh);
			}
			
			var topMesh:L3DMesh = BuildTopMesh(stage3D);
			if(topMesh != null)
			{
				topMesh.Mode = 30;
				model.addChild(topMesh);
			}
			
			if(model.numChildren == 0)
			{
				return null;
			}			
			
			//	model.ShowTopView = false;
			model.Mode = 30;
			model.catalog = 30;
			model.OffGround = WindowOffGround;
			model.BuildBoundBox();
			
			UploadResources(model, stage3D.context3D);
			
			windowsMesh = model;
			return model;
		}
		
		private function BuildFloatRoundPoints():Vector.<Vector3D>
		{
			if(floatDistance < 20)
			{
				return null;
			}
			
			var distance:int = this.floatDistance;
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var d:Number = distance + edgeDistance;
			if(floatSide != 0)
			{
				d *= -1;
			}
			var windowsFloatLine:Array = L3DUtils.GetOffsetPoints(this.windowsLine, d);
			if(windowsFloatLine == null)
			{
				return null;
			}
			
			for each(var point:Vector3D in windowsLine)
			{
				points.push(point.clone());
			}

			for(var i:int = windowsFloatLine.length - 1; i>=0; i--)
			{
				points.push(windowsFloatLine[i].clone());
			}
			
			return points;
		}
		
		public function get Exist():Boolean
		{
			return windowsMesh != null;
		}
		
		public function get WindowsModel():L3DMesh
		{
			return windowsMesh;
		}
		
		public function get WindowLength():int
		{
			if(windowsLine == null || windowsLine.length < 2)
			{
				return 0;
			}
			
			var length:int = 0;
			for(var i:int = 0; i < windowsLine.length - 1; i++)
			{
				var point1:Vector3D = windowsLine[i] as Vector3D;
				var point2:Vector3D = windowsLine[i + 1] as Vector3D;
				var point:Vector3D = new Vector3D(point2.x - point1.x, point2.y - point1.y, 0);
				length += point.length;
			}
			
			return length;
		}
		
		public function get LeftWindowLength():int
		{
		    return leftWindowLength;	
		}
		
		public function set LeftWindowLength(v:int):void
		{
			leftWindowLength = v;	
		}
		
		public function get RightWindowLength():int
		{
			return rightWindowLength;	
		}
		
		public function set RightWindowLength(v:int):void
		{
			rightWindowLength = v;	
		}
		
		public function get WindowHeight():int
		{
			return windowHeight;
		}
		
		public function set WindowHeight(height:int):void
		{
			windowHeight = height;
			if(windowHeight < 600)
			{
				windowHeight = 600;
			}
			else if((windowOffGround + windowHeight) > 2800)
			{
				windowHeight = 2800 - windowOffGround;
			}
		}
		
		public function get WindowOffGround():int
		{
			return windowOffGround;
		}
		
		public function set WindowOffGround(offGround:int):void
		{
			windowOffGround = offGround;
			if(windowOffGround < 0)
			{
				windowOffGround = 0;
			}
			else if((windowOffGround + windowHeight) > 2800)
			{
				windowOffGround = 2800 - windowHeight;
			}
		}
		
		public function get FloatDistance():int
		{
			return floatDistance;
		}
		
		public function set FloatDistance(distance:int):void
		{
			floatDistance = distance;
			if(floatDistance < 100)
			{				
			    floatDistance = 0;
			}
			else if(floatDistance > 1000)
			{
				floatDistance = 1000;
			}
		}
		
		public function get FloatSide():int
		{
			return floatSide;
		}
		
		public function set FloatSide(side:int):void
		{
			floatSide = side;		
		}
		
		public function get WallThickness():int
		{
			return wallThickness;
		}
		
		public function set WallThickness(v:int):void
		{
			wallThickness = v;
		}
		
		private function CompuWindowBoardFlatPoints():Array
		{
			if(windowsLine == null || windowsLine.length < 2)
			{
				return null;
			}
			
			return windowsLine;
		}
		
		private static function UploadResources(object:Object3D, context:Context3D):void
		{
			for each (var res:Resource in object.getResources(true))
			{
				res.upload(context);
			}
		}		
		
		private function BuildFrameMesh(stage3D:Stage3D):L3DMesh
		{
			windowsFloatLine = new Array();
			windowsInnerLine = new Array();
			
			if(this.windowsLine == null || this.windowsLine.length < 2)
			{
				return null;
			}
			var point:Vector3D
			var windowsLine:Array;
			
			windowsLine = [];
			if(floatDistance < 100)
			{
			    for each(point in this.windowsLine)
			    {
				    windowsLine.push(point);
			    }
			}
			else
			{				
				var d:Number = floatDistance;
				if(floatSide != 0)
				{
					d *= -1;
				}
				windowsFloatLine = L3DUtils.GetOffsetPoints(this.windowsLine, d);
				if(windowsFloatLine == null)
				{
					for each(point in this.windowsLine)
					{
						windowsLine.push(point);
					}
				}
				else
				{
					for each(point in windowsFloatLine)
					{
						windowsLine.push(point);
					}
				}	
				d = wallThickness * 0.5;
				if(floatSide == 0)
				{
					d *= -1;
				}
				windowsInnerLine = L3DUtils.GetOffsetPoints(this.windowsLine, d);
			}			
			
			var mesh:L3DMesh = new L3DMesh();
			var lightMapChannel:int = 0;
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);
			
			var numberVertices:int = 0;
			var vertices:Vector.<Number> = new Vector.<Number>();
			var texture0:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();			
			
			for(var i:int = 1;i< windowsLine.length;i++)
			{
				var startPoint:Vector3D = windowsLine[i - 1] as Vector3D;
				var endPoint:Vector3D = windowsLine[i] as Vector3D;
				startPoint.z = 0;
				endPoint.z = 0;
				var length:Number = GetVector(startPoint, endPoint).length;
				if(length < 10)
				{
					continue;
				}
				var matrix:Matrix3D = CompuWindowMatrix(startPoint, endPoint);
				var checkSegment:Number = length / (partitionSpace as Number);
				var numberSegmentWindows:int = checkSegment;
				if(numberSegmentWindows < 1)
				{
					numberSegmentWindows = 1;
				}
				else if((checkSegment - numberSegmentWindows) >= 0.5)
				{
					numberSegmentWindows += 1;
				}
				var startPoint0:Vector3D = new Vector3D(0, windowFrameThickness * -0.5, 0);
				var startPoint1:Vector3D = new Vector3D(windowFrameWidth, windowFrameThickness * -0.5, 0);
				var startPoint2:Vector3D = new Vector3D(windowFrameWidth, windowFrameThickness * 0.5, 0);
				var startPoint3:Vector3D = new Vector3D(0, windowFrameThickness * 0.5, 0);
				var startPoint4:Vector3D = new Vector3D(0, windowFrameThickness * -0.5, windowHeight);
				var startPoint5:Vector3D = new Vector3D(windowFrameWidth, windowFrameThickness * -0.5, windowHeight);
				var startPoint6:Vector3D = new Vector3D(windowFrameWidth, windowFrameThickness * 0.5, windowHeight);
				var startPoint7:Vector3D = new Vector3D(0, windowFrameThickness * 0.5, windowHeight);
				startPoint0 = matrix.transformVector(startPoint0);
				startPoint1 = matrix.transformVector(startPoint1);
				startPoint2 = matrix.transformVector(startPoint2);
				startPoint3 = matrix.transformVector(startPoint3);
				startPoint4 = matrix.transformVector(startPoint4);
				startPoint5 = matrix.transformVector(startPoint5);
				startPoint6 = matrix.transformVector(startPoint6);
				startPoint7 = matrix.transformVector(startPoint7);
				vertices.push(startPoint0.x);
				vertices.push(startPoint0.y);
				vertices.push(startPoint0.z);
				vertices.push(startPoint1.x);
				vertices.push(startPoint1.y);
				vertices.push(startPoint1.z);
				vertices.push(startPoint2.x);
				vertices.push(startPoint2.y);
				vertices.push(startPoint2.z);
				vertices.push(startPoint3.x);
				vertices.push(startPoint3.y);
				vertices.push(startPoint3.z);
				vertices.push(startPoint4.x);
				vertices.push(startPoint4.y);
				vertices.push(startPoint4.z);
				vertices.push(startPoint5.x);
				vertices.push(startPoint5.y);
				vertices.push(startPoint5.z);
				vertices.push(startPoint6.x);
				vertices.push(startPoint6.y);
				vertices.push(startPoint6.z);
				vertices.push(startPoint7.x);
				vertices.push(startPoint7.y);
				vertices.push(startPoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;
				var endPoint0:Vector3D = new Vector3D(length + windowFrameWidth * -1.0, windowFrameThickness * -0.5, 0);
				var endPoint1:Vector3D = new Vector3D(length, windowFrameThickness * -0.5, 0);
				var endPoint2:Vector3D = new Vector3D(length, windowFrameThickness * 0.5, 0);
				var endPoint3:Vector3D = new Vector3D(length + windowFrameWidth * -1.0, windowFrameThickness * 0.5, 0);
				var endPoint4:Vector3D = new Vector3D(length + windowFrameWidth * -1.0, windowFrameThickness * -0.5, windowHeight);
				var endPoint5:Vector3D = new Vector3D(length, windowFrameThickness * -0.5, windowHeight);
				var endPoint6:Vector3D = new Vector3D(length, windowFrameThickness * 0.5, windowHeight);
				var endPoint7:Vector3D = new Vector3D(length + windowFrameWidth * -1.0, windowFrameThickness * 0.5, windowHeight);
				endPoint0 = matrix.transformVector(endPoint0);
				endPoint1 = matrix.transformVector(endPoint1);
				endPoint2 = matrix.transformVector(endPoint2);
				endPoint3 = matrix.transformVector(endPoint3);
				endPoint4 = matrix.transformVector(endPoint4);
				endPoint5 = matrix.transformVector(endPoint5);
				endPoint6 = matrix.transformVector(endPoint6);
				endPoint7 = matrix.transformVector(endPoint7);
				vertices.push(endPoint0.x);
				vertices.push(endPoint0.y);
				vertices.push(endPoint0.z);
				vertices.push(endPoint1.x);
				vertices.push(endPoint1.y);
				vertices.push(endPoint1.z);
				vertices.push(endPoint2.x);
				vertices.push(endPoint2.y);
				vertices.push(endPoint2.z);
				vertices.push(endPoint3.x);
				vertices.push(endPoint3.y);
				vertices.push(endPoint3.z);
				vertices.push(endPoint4.x);
				vertices.push(endPoint4.y);
				vertices.push(endPoint4.z);
				vertices.push(endPoint5.x);
				vertices.push(endPoint5.y);
				vertices.push(endPoint5.z);
				vertices.push(endPoint6.x);
				vertices.push(endPoint6.y);
				vertices.push(endPoint6.z);
				vertices.push(endPoint7.x);
				vertices.push(endPoint7.y);
				vertices.push(endPoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;
				if(numberSegmentWindows > 1)
				{
					var segmentLength:int = length / numberSegmentWindows;
					for(var j:int = 0;j< numberSegmentWindows - 1;j++)
					{
						var segmentLength2:int = segmentLength * (j + 1);
						var segmentPoint0:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * -0.5, windowFrameThickness * -0.5, 0);
						var segmentPoint1:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * 0.5, windowFrameThickness * -0.5, 0);
						var segmentPoint2:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * 0.5, windowFrameThickness * 0.5, 0);
						var segmentPoint3:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * -0.5, windowFrameThickness * 0.5, 0);
						var segmentPoint4:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * -0.5, windowFrameThickness * -0.5, windowHeight);
						var segmentPoint5:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowHeight);
						var segmentPoint6:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowHeight);
						var segmentPoint7:Vector3D = new Vector3D(segmentLength2 + windowFrameWidth * -0.5, windowFrameThickness * 0.5, windowHeight);
						segmentPoint0 = matrix.transformVector(segmentPoint0);
						segmentPoint1 = matrix.transformVector(segmentPoint1);
						segmentPoint2 = matrix.transformVector(segmentPoint2);
						segmentPoint3 = matrix.transformVector(segmentPoint3);
						segmentPoint4 = matrix.transformVector(segmentPoint4);
						segmentPoint5 = matrix.transformVector(segmentPoint5);
						segmentPoint6 = matrix.transformVector(segmentPoint6);
						segmentPoint7 = matrix.transformVector(segmentPoint7);
						vertices.push(segmentPoint0.x);
						vertices.push(segmentPoint0.y);
						vertices.push(segmentPoint0.z);
						vertices.push(segmentPoint1.x);
						vertices.push(segmentPoint1.y);
						vertices.push(segmentPoint1.z);
						vertices.push(segmentPoint2.x);
						vertices.push(segmentPoint2.y);
						vertices.push(segmentPoint2.z);
						vertices.push(segmentPoint3.x);
						vertices.push(segmentPoint3.y);
						vertices.push(segmentPoint3.z);
						vertices.push(segmentPoint4.x);
						vertices.push(segmentPoint4.y);
						vertices.push(segmentPoint4.z);
						vertices.push(segmentPoint5.x);
						vertices.push(segmentPoint5.y);
						vertices.push(segmentPoint5.z);
						vertices.push(segmentPoint6.x);
						vertices.push(segmentPoint6.y);
						vertices.push(segmentPoint6.z);
						vertices.push(segmentPoint7.x);
						vertices.push(segmentPoint7.y);
						vertices.push(segmentPoint7.z);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						texture0.push(0);
						indices.push(numberVertices);
						indices.push(numberVertices + 1);
						indices.push(numberVertices + 3);
						indices.push(numberVertices + 1);
						indices.push(numberVertices + 2);
						indices.push(numberVertices + 3);				
						indices.push(numberVertices + 4);
						indices.push(numberVertices + 5);
						indices.push(numberVertices + 7);
						indices.push(numberVertices + 5);
						indices.push(numberVertices + 6);
						indices.push(numberVertices + 7);				
						indices.push(numberVertices);
						indices.push(numberVertices + 1);
						indices.push(numberVertices + 5);
						indices.push(numberVertices);
						indices.push(numberVertices + 5);
						indices.push(numberVertices + 4);				
						indices.push(numberVertices + 2);
						indices.push(numberVertices + 3);
						indices.push(numberVertices + 7);
						indices.push(numberVertices + 2);
						indices.push(numberVertices + 7);
						indices.push(numberVertices + 6);				
						indices.push(numberVertices + 3);
						indices.push(numberVertices);
						indices.push(numberVertices + 4);
						indices.push(numberVertices + 3);
						indices.push(numberVertices + 4);
						indices.push(numberVertices + 7);				
						indices.push(numberVertices + 1);
						indices.push(numberVertices + 2);
						indices.push(numberVertices + 6);
						indices.push(numberVertices + 1);
						indices.push(numberVertices + 6);
						indices.push(numberVertices + 5);
						numberVertices += 8;
					}
				}
				var topFramePoint0:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowHeight - windowFrameWidth);
				var topFramePoint1:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowHeight - windowFrameWidth);
				var topFramePoint2:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowHeight - windowFrameWidth);
				var topFramePoint3:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowHeight - windowFrameWidth);
				var topFramePoint4:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowHeight);
				var topFramePoint5:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowHeight);
				var topFramePoint6:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowHeight);
				var topFramePoint7:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowHeight);
				topFramePoint0 = matrix.transformVector(topFramePoint0);
				topFramePoint1 = matrix.transformVector(topFramePoint1);
				topFramePoint2 = matrix.transformVector(topFramePoint2);
				topFramePoint3 = matrix.transformVector(topFramePoint3);
				topFramePoint4 = matrix.transformVector(topFramePoint4);
				topFramePoint5 = matrix.transformVector(topFramePoint5);
				topFramePoint6 = matrix.transformVector(topFramePoint6);
				topFramePoint7 = matrix.transformVector(topFramePoint7);
				vertices.push(topFramePoint0.x);
				vertices.push(topFramePoint0.y);
				vertices.push(topFramePoint0.z);
				vertices.push(topFramePoint1.x);
				vertices.push(topFramePoint1.y);
				vertices.push(topFramePoint1.z);
				vertices.push(topFramePoint2.x);
				vertices.push(topFramePoint2.y);
				vertices.push(topFramePoint2.z);
				vertices.push(topFramePoint3.x);
				vertices.push(topFramePoint3.y);
				vertices.push(topFramePoint3.z);
				vertices.push(topFramePoint4.x);
				vertices.push(topFramePoint4.y);
				vertices.push(topFramePoint4.z);
				vertices.push(topFramePoint5.x);
				vertices.push(topFramePoint5.y);
				vertices.push(topFramePoint5.z);
				vertices.push(topFramePoint6.x);
				vertices.push(topFramePoint6.y);
				vertices.push(topFramePoint6.z);
				vertices.push(topFramePoint7.x);
				vertices.push(topFramePoint7.y);
				vertices.push(topFramePoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;
				var inFramePoint0:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, bottomWindowHeight);
				var inFramePoint1:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, bottomWindowHeight);
				var inFramePoint2:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, bottomWindowHeight);
				var inFramePoint3:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, bottomWindowHeight);
				var inFramePoint4:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, bottomWindowHeight + windowFrameWidth);
				var inFramePoint5:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, bottomWindowHeight + windowFrameWidth);
				var inFramePoint6:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, bottomWindowHeight + windowFrameWidth);
				var inFramePoint7:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, bottomWindowHeight + windowFrameWidth);
				inFramePoint0 = matrix.transformVector(inFramePoint0);
				inFramePoint1 = matrix.transformVector(inFramePoint1);
				inFramePoint2 = matrix.transformVector(inFramePoint2);
				inFramePoint3 = matrix.transformVector(inFramePoint3);
				inFramePoint4 = matrix.transformVector(inFramePoint4);
				inFramePoint5 = matrix.transformVector(inFramePoint5);
				inFramePoint6 = matrix.transformVector(inFramePoint6);
				inFramePoint7 = matrix.transformVector(inFramePoint7);
				vertices.push(inFramePoint0.x);
				vertices.push(inFramePoint0.y);
				vertices.push(inFramePoint0.z);
				vertices.push(inFramePoint1.x);
				vertices.push(inFramePoint1.y);
				vertices.push(inFramePoint1.z);
				vertices.push(inFramePoint2.x);
				vertices.push(inFramePoint2.y);
				vertices.push(inFramePoint2.z);
				vertices.push(inFramePoint3.x);
				vertices.push(inFramePoint3.y);
				vertices.push(inFramePoint3.z);
				vertices.push(inFramePoint4.x);
				vertices.push(inFramePoint4.y);
				vertices.push(inFramePoint4.z);
				vertices.push(inFramePoint5.x);
				vertices.push(inFramePoint5.y);
				vertices.push(inFramePoint5.z);
				vertices.push(inFramePoint6.x);
				vertices.push(inFramePoint6.y);
				vertices.push(inFramePoint6.z);
				vertices.push(inFramePoint7.x);
				vertices.push(inFramePoint7.y);
				vertices.push(inFramePoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;				
				var bottomFramePoint0:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, 0);
				var bottomFramePoint1:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, 0);
				var bottomFramePoint2:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, 0);
				var bottomFramePoint3:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, 0);
				var bottomFramePoint4:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowFrameWidth);
				var bottomFramePoint5:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * -0.5, windowFrameWidth);
				var bottomFramePoint6:Vector3D = new Vector3D(length - windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowFrameWidth);
				var bottomFramePoint7:Vector3D = new Vector3D(windowFrameWidth * 0.5, windowFrameThickness * 0.5, windowFrameWidth);
				bottomFramePoint0 = matrix.transformVector(bottomFramePoint0);
				bottomFramePoint1 = matrix.transformVector(bottomFramePoint1);
				bottomFramePoint2 = matrix.transformVector(bottomFramePoint2);
				bottomFramePoint3 = matrix.transformVector(bottomFramePoint3);
				bottomFramePoint4 = matrix.transformVector(bottomFramePoint4);
				bottomFramePoint5 = matrix.transformVector(bottomFramePoint5);
				bottomFramePoint6 = matrix.transformVector(bottomFramePoint6);
				bottomFramePoint7 = matrix.transformVector(bottomFramePoint7);
				vertices.push(bottomFramePoint0.x);
				vertices.push(bottomFramePoint0.y);
				vertices.push(bottomFramePoint0.z);
				vertices.push(bottomFramePoint1.x);
				vertices.push(bottomFramePoint1.y);
				vertices.push(bottomFramePoint1.z);
				vertices.push(bottomFramePoint2.x);
				vertices.push(bottomFramePoint2.y);
				vertices.push(bottomFramePoint2.z);
				vertices.push(bottomFramePoint3.x);
				vertices.push(bottomFramePoint3.y);
				vertices.push(bottomFramePoint3.z);
				vertices.push(bottomFramePoint4.x);
				vertices.push(bottomFramePoint4.y);
				vertices.push(bottomFramePoint4.z);
				vertices.push(bottomFramePoint5.x);
				vertices.push(bottomFramePoint5.y);
				vertices.push(bottomFramePoint5.z);
				vertices.push(bottomFramePoint6.x);
				vertices.push(bottomFramePoint6.y);
				vertices.push(bottomFramePoint6.z);
				vertices.push(bottomFramePoint7.x);
				vertices.push(bottomFramePoint7.y);
				vertices.push(bottomFramePoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				texture0.push(0);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;
			}			
			mesh.geometry.numVertices = numberVertices;
			
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
			mesh.geometry.indices = indices;			
			
			var material:Material = BuildFrameMaterial(stage3D);
			
			mesh.addSurface(material, 0, indices.length / 3);
			mesh.name = "WINDOWFRAME";	
			
			mesh.MaterialMode = 30;
		//	L3DMesh.UpdateForEnviromentView(mesh, stage3D);
			
			return mesh;
		}
		
		private function BuildBoardMesh(stage3D:Stage3D):L3DMesh
		{
			if(this.windowsLine == null || this.windowsLine.length < 2)
			{
				return null;
			}
			
			var windowsLine:Array = new Array();
			if(floatDistance < 100 || windowsFloatLine == null || windowsFloatLine.length == 0)
			{
				for each(var point:Vector3D in this.windowsLine)
				{
					windowsLine.push(point);
				}
			}
			else
			{
				for each(var point:Vector3D in windowsFloatLine)
				{
					windowsLine.push(point);
				}
			}
			
			var mesh:L3DMesh = new L3DMesh();
			var lightMapChannel:int = 0;
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);
			
			var numberVertices:int = 0;
			var vertices:Vector.<Number> = new Vector.<Number>();
			var texture0:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();			
			
			for(var i:int = 1;i< windowsLine.length;i++)
			{
				var startPoint:Vector3D = windowsLine[i - 1] as Vector3D;
				var endPoint:Vector3D = windowsLine[i] as Vector3D;
				startPoint.z = 0;
				endPoint.z = 0;
				var length:Number = GetVector(startPoint, endPoint).length;
				if(length < 10)
				{
					continue;
				}
				var matrix:Matrix3D = CompuWindowMatrix(startPoint, endPoint);
				var boardPoint0:Vector3D = new Vector3D(0, windowThickness * -0.5, windowFrameThickness * 0.5);
				var boardPoint1:Vector3D = new Vector3D(length, windowThickness * -0.5, windowFrameThickness * 0.5);
				var boardPoint2:Vector3D = new Vector3D(length, windowThickness * 0.5, windowFrameThickness * 0.5);
				var boardPoint3:Vector3D = new Vector3D(0, windowThickness * 0.5, windowFrameThickness * 0.5);
				var boardPoint4:Vector3D = new Vector3D(0, windowThickness * -0.5, windowHeight - windowFrameThickness * 0.5);
				var boardPoint5:Vector3D = new Vector3D(length, windowThickness * -0.5, windowHeight - windowFrameThickness * 0.5);
				var boardPoint6:Vector3D = new Vector3D(length, windowThickness * 0.5, windowHeight - windowFrameThickness * 0.5);
				var boardPoint7:Vector3D = new Vector3D(0, windowThickness * 0.5, windowHeight - windowFrameThickness * 0.5);
				boardPoint0 = matrix.transformVector(boardPoint0);
				boardPoint1 = matrix.transformVector(boardPoint1);
				boardPoint2 = matrix.transformVector(boardPoint2);
				boardPoint3 = matrix.transformVector(boardPoint3);
				boardPoint4 = matrix.transformVector(boardPoint4);
				boardPoint5 = matrix.transformVector(boardPoint5);
				boardPoint6 = matrix.transformVector(boardPoint6);
				boardPoint7 = matrix.transformVector(boardPoint7);
				vertices.push(boardPoint0.x);
				vertices.push(boardPoint0.y);
				vertices.push(boardPoint0.z);
				vertices.push(boardPoint1.x);
				vertices.push(boardPoint1.y);
				vertices.push(boardPoint1.z);
				vertices.push(boardPoint2.x);
				vertices.push(boardPoint2.y);
				vertices.push(boardPoint2.z);
				vertices.push(boardPoint3.x);
				vertices.push(boardPoint3.y);
				vertices.push(boardPoint3.z);
				vertices.push(boardPoint4.x);
				vertices.push(boardPoint4.y);
				vertices.push(boardPoint4.z);
				vertices.push(boardPoint5.x);
				vertices.push(boardPoint5.y);
				vertices.push(boardPoint5.z);
				vertices.push(boardPoint6.x);
				vertices.push(boardPoint6.y);
				vertices.push(boardPoint6.z);
				vertices.push(boardPoint7.x);
				vertices.push(boardPoint7.y);
				vertices.push(boardPoint7.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);				
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 5);
				indices.push(numberVertices);
				indices.push(numberVertices + 5);
				indices.push(numberVertices + 4);				
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 7);
				indices.push(numberVertices + 6);				
				indices.push(numberVertices + 3);
				indices.push(numberVertices);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 4);
				indices.push(numberVertices + 7);				
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 6);
				indices.push(numberVertices + 5);
				numberVertices += 8;
			}	
			
			mesh.geometry.numVertices = numberVertices;			
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
			mesh.geometry.indices = indices;			
			
			var material:Material = BuildBoardMaterial(stage3D);
			
			mesh.addSurface(material, 0, indices.length / 3);
			mesh.name = "WINDOWBOARD";	
			
			mesh.MaterialMode = 45;
	//    	mesh.UpdateForEnviromentView(mesh, stage3D);
			
			return mesh;
		}	
		
		private function BuildFloatMesh(stage3D:Stage3D):L3DMesh
		{
			if(windowsLine == null || windowsLine.length < 2)
			{
				return null;
			}
			
			if(floatDistance < 100 || windowsFloatLine == null || windowsFloatLine.length == 0 || windowsInnerLine == null || windowsInnerLine.length == 0)
			{
				var d:Number = wallThickness * 0.5;
				if(floatSide != 0)
				{
					d *= -1;
				}
				windowsFloatLine = L3DUtils.GetOffsetPoints(this.windowsLine, d);
				d = wallThickness * 0.5;
				if(floatSide == 0)
				{
					d *= -1;
				}
				windowsInnerLine = L3DUtils.GetOffsetPoints(this.windowsLine, d);
			}
			
			var mesh:L3DMesh = new L3DMesh();
			var lightMapChannel:int = 0;
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			mesh.geometry = new Geometry();
			mesh.geometry.addVertexStream(attributes);
			
			var numberVertices:int = 0;
			var vertices:Vector.<Number> = new Vector.<Number>();
			var texture0:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			for(var i:int = 0;i<2;i++)
			{
				var point0:Vector3D = i==0 ? L3DUtils.CopyVector3D(windowsInnerLine[0] as Vector3D) : L3DUtils.CopyVector3D(windowsInnerLine[windowsInnerLine.length - 1] as Vector3D);
				var point1:Vector3D = i==0 ? L3DUtils.CopyVector3D(windowsFloatLine[0] as Vector3D) : L3DUtils.CopyVector3D(windowsFloatLine[windowsFloatLine.length - 1] as Vector3D);
				var inPoint1:Vector3D = new Vector3D(point0.x, point0.y, 0);
				var outPoint1:Vector3D = new Vector3D(point1.x, point1.y, 0);
				var inPoint2:Vector3D = new Vector3D(point0.x, point0.y, windowHeight);
				var outPoint2:Vector3D = new Vector3D(point1.x, point1.y, windowHeight);
				vertices.push(inPoint1.x);
				vertices.push(inPoint1.y);
				vertices.push(inPoint1.z);
				vertices.push(inPoint2.x);
				vertices.push(inPoint2.y);
				vertices.push(inPoint2.z);
				vertices.push(outPoint1.x);
				vertices.push(outPoint1.y);
				vertices.push(outPoint1.z);
				vertices.push(outPoint2.x);
				vertices.push(outPoint2.y);
				vertices.push(outPoint2.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);				
			/*	indices.push(numberVertices);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);	*/
				numberVertices += 4;
			}
			
			for(var i:int = 0;i<2;i++)
			{
				var point0:Vector3D = i==0 ? L3DUtils.CopyVector3D(windowsInnerLine[0] as Vector3D) : L3DUtils.CopyVector3D(windowsInnerLine[windowsInnerLine.length - 1] as Vector3D);
				var point1:Vector3D = i==0 ? L3DUtils.CopyVector3D(windowsFloatLine[0] as Vector3D) : L3DUtils.CopyVector3D(windowsFloatLine[windowsFloatLine.length - 1] as Vector3D);
				var inPoint1:Vector3D = new Vector3D(point0.x, point0.y, 0);
				var outPoint1:Vector3D = new Vector3D(point1.x, point1.y, 0);
				var inPoint2:Vector3D = new Vector3D(point0.x, point0.y, windowHeight);
				var outPoint2:Vector3D = new Vector3D(point1.x, point1.y, windowHeight);
				vertices.push(inPoint1.x);
				vertices.push(inPoint1.y);
				vertices.push(inPoint1.z);
				vertices.push(inPoint2.x);
				vertices.push(inPoint2.y);
				vertices.push(inPoint2.z);
				vertices.push(outPoint1.x);
				vertices.push(outPoint1.y);
				vertices.push(outPoint1.z);
				vertices.push(outPoint2.x);
				vertices.push(outPoint2.y);
				vertices.push(outPoint2.z);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
				texture0.push(0);
				texture0.push(0);
				texture0.push(1);
				texture0.push(1);
		/*		indices.push(numberVertices);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 3);	*/			
				indices.push(numberVertices);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 1);
				indices.push(numberVertices + 2);
				indices.push(numberVertices + 3);
				indices.push(numberVertices + 1);
				numberVertices += 4;
			}
			
			mesh.geometry.numVertices = numberVertices;			
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], texture0);
			mesh.geometry.indices = indices;
			
			var material:Material = BuildWallMaterial(stage3D);
			
			mesh.addSurface(material, 0, indices.length / 3);
			mesh.name = "WINDOWFLOAT";				
			
			return mesh;
		}
		
		private function BuildTableMesh(stage3D:Stage3D):L3DMesh
		{
			if(windowsLine == null || windowsLine.length < 2)
			{
				return null;
			}
			
			var distance:int = floatDistance;
			if(distance < 100)
			{
				distance = wallThickness * 0.5;
			}
			
			var points:Array = new Array();
			var d:Number = distance + edgeDistance;
			if(floatSide != 0)
			{
				d *= -1;
			}
			var windowsFloatLine:Array = L3DUtils.GetOffsetPoints(windowsLine, d);
			if(windowsFloatLine == null)
			{
				return null;
			}
			else
			{
				for each(var point:Vector3D in windowsFloatLine)
				{
					points.push(new Point(point.x, point.y));
				}
			}
			d = wallThickness * 0.5 + edgeDistance;
			if(floatSide == 0)
			{
				d *= -1;
			}
			windowsFloatLine = L3DUtils.GetOffsetPoints(windowsLine, d);
			if(windowsFloatLine == null)
			{
				return null;
			}
			else
			{
				for(var i:int = windowsFloatLine.length - 1; i>=0;i--)
				{
					var vpoint:Vector3D = windowsFloatLine[i] as Vector3D;					
					points.push(new Point(vpoint.x, vpoint.y));
				}
			}			
			var boardTriangleResult:Array = new Array();
			Trianglulate.process(points, boardTriangleResult);			
			if(boardTriangleResult.length == 0)
			{
				return null;
			}
			
			var max:Vector3D = new Vector3D();
			var min:Vector3D = new Vector3D();
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				for(var j:int = 0; j<3; j++)
				{
					var cpoint:Point = boardTriangleResult[i][j] as Point;
					if(i==0 && j==0)
					{
						max.x = cpoint.x;
						max.y = cpoint.y;
						min.x = cpoint.x;
						min.y = cpoint.y;
					}
					else
					{
						max.x = Math.max(max.x, cpoint.x);
						max.y = Math.max(max.y, cpoint.y);
						min.x = Math.min(min.x, cpoint.x);
						min.y = Math.min(min.y, cpoint.y);
					}
				}
			}
			
			var boardMesh:L3DMesh = new L3DMesh();
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[1]);
			attributes.push(VertexAttributes.TEXCOORDS[1]);
			attributes.push(VertexAttributes.NORMAL);
			attributes.push(VertexAttributes.NORMAL);
			attributes.push(VertexAttributes.NORMAL);
			boardMesh.geometry = new Geometry();
			boardMesh.geometry.addVertexStream(attributes);
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			var textures0:Vector.<Number> = new Vector.<Number>();
			var textures1:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				var point1:Point = boardTriangleResult[i][0] as Point;
				var point2:Point = boardTriangleResult[i][1] as Point;
				var point3:Point = boardTriangleResult[i][2] as Point;
				vertices.push(point1.x - 950, point1.y, -200);
				vertices.push(point2.x - 950, point2.y, -200);
				vertices.push(point3.x - 950, point3.y, -200);
				var u1:Number = (point1.x - min.x) / 1000;
				var v1:Number = (point1.y - min.y) / 1000;
				var u2:Number = (point2.x - min.x) / 1000;
				var v2:Number = (point2.y - min.y) / 1000;
				var u3:Number = (point3.x - min.x) / 1000;
				var v3:Number = (point3.y - min.y) / 1000;
				textures0.push(u1, v1, u2, v2, u3, v3);
				textures1.push(u1, v1, u2, v2, u3, v3);
				normals.push(0,0,1,0,0,1,0,0,1);
			}
			
			for(var i:int = 0; i<points.length; i++)
			{
				var startPoint:Point = points[i];
				var endPoint:Point = i == points.length - 1 ? points[0] : points[i+1];
				vertices.push(startPoint.x - 950, startPoint.y, -200);
				vertices.push(endPoint.x - 950, endPoint.y, -200);
				vertices.push(startPoint.x - 950, startPoint.y, -windowTableThickness - 200);
				vertices.push(startPoint.x - 950, startPoint.y, -windowTableThickness - 200);
				vertices.push(endPoint.x - 950, endPoint.y, -200);
				vertices.push(endPoint.x - 950, endPoint.y, -windowTableThickness - 200);
				textures0.push(0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1);
				textures1.push(0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1);
				normals.push(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
			}
			
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				var point1:Point = boardTriangleResult[i][0] as Point;
				var point2:Point = boardTriangleResult[i][1] as Point;
				var point3:Point = boardTriangleResult[i][2] as Point;
				vertices.push(point1.x - 950, point1.y, -200);
				vertices.push(point3.x - 950, point3.y, -200);
				vertices.push(point2.x - 950, point2.y, -200);
				var u1:Number = (point1.x - min.x) / 1000;
				var v1:Number = (point1.y - min.y) / 1000;
				var u2:Number = (point2.x - min.x) / 1000;
				var v2:Number = (point2.y - min.y) / 1000;
				var u3:Number = (point3.x - min.x) / 1000;
				var v3:Number = (point3.y - min.y) / 1000;
				textures0.push(u1, v1, u3, v3, u2, v2);
				textures1.push(u1, v1, u3, v3, u2, v2);
				normals.push(0,0,1,0,0,1,0,0,1);
			}
			
			for(var i:int = 0; i<points.length; i++)
			{
				var startPoint:Point = points[i];
				var endPoint:Point = i == points.length - 1 ? points[0] : points[i+1];
				vertices.push(startPoint.x - 950, startPoint.y, -200);
				vertices.push(startPoint.x - 950, startPoint.y, -windowTableThickness - 200);
				vertices.push(endPoint.x - 950, endPoint.y, -200);
				vertices.push(startPoint.x - 950, startPoint.y, -windowTableThickness - 200);
				vertices.push(endPoint.x - 950, endPoint.y, -windowTableThickness - 200);
				vertices.push(endPoint.x - 950, endPoint.y, -200);
				textures0.push(0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0);
				textures1.push(0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0);
				normals.push(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
			}
			
			var iNumber:int = vertices.length / 3;
			for (var i=0; i < iNumber; i+=3)
			{
				indices.push(i);
				indices.push(i + 1);
				indices.push(i + 2);
			}
			
			boardMesh.geometry.numVertices = vertices.length / 3;
			boardMesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			boardMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], textures0);
			boardMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1], textures1);
			boardMesh.geometry.setAttributeValues(VertexAttributes.NORMAL, normals);
			boardMesh.geometry.indices = indices;

			var material:Material = BuildTableMaterial(stage3D);			
			boardMesh.addSurface(material, 0, indices.length / 3);
			boardMesh.matrix = new Matrix3D();
			boardMesh.matrix.identity();
			boardMesh.name = "WINDOWTABLE";				
			
			return boardMesh;
		}
		
		public static function GetCheckSidePoint(wallIntersectionPoint:Vector3D, leftWallDir:Vector3D, rightWallDir:Vector3D, floatSide:int):Vector3D
		{
		//	var leftDir:Vector3D = new Vector3D(leftWallEndPoint.x - wallIntersectionPoint.x, leftWallEndPoint.y - wallIntersectionPoint.y, 0);
		//	var rightDir:Vector3D = new Vector3D(rightWallEndPoint.x - wallIntersectionPoint.x, rightWallEndPoint.y - wallIntersectionPoint.y, 0);
			leftWallDir.normalize();
			rightWallDir.normalize();
			var leftPoint:Vector3D = new Vector3D(wallIntersectionPoint.x + leftWallDir.x * 1500, wallIntersectionPoint.y + leftWallDir.y * 1500, 0);
			var rightPoint:Vector3D = new Vector3D(wallIntersectionPoint.x + rightWallDir.x * 1500, wallIntersectionPoint.y + rightWallDir.y * 1500, 0);
			var d:Number = 500;
			if(floatSide != 0)
			{
				d *= -1;
			}
			var windowsLine:Array = new Array(leftPoint, wallIntersectionPoint, rightPoint);
			var windowsFloatLine:Array = L3DUtils.GetOffsetPoints(windowsLine, d);
			if(windowsFloatLine == null)
			{
				return wallIntersectionPoint.clone();
			}
			
			return windowsFloatLine[1] as Vector3D;
		}
		
		private function BuildTopMesh(stage3D:Stage3D):L3DMesh
		{
			if(windowsLine == null || windowsLine.length < 2)
			{
				return null;
			}
			
			var distance:int = this.floatDistance;
			var windowTableThickness:int = this.windowTableThickness;
			var edgeDistance:int = this.edgeDistance;
			
			if(distance < 100)
			{
				distance = wallThickness * 0.5;
				windowTableThickness = 1;
				edgeDistance = 0;
			}
			
			var distance:int = floatDistance;
			if(distance < 120)
			{
				distance = wallThickness * 0.5;
			}
			
			var points:Array = new Array();
			var d:Number = distance + edgeDistance;
			if(floatSide != 0)
			{
				d *= -1;
			}
			var windowsFloatLine:Array = L3DUtils.GetOffsetPoints(windowsLine, d);
			if(windowsFloatLine == null)
			{
				return null;
			}
			else
			{
				for each(var point:Vector3D in windowsFloatLine)
				{
					points.push(new Point(point.x, point.y));
				}
			}
			d = wallThickness * 0.5 + edgeDistance;
			if(floatSide == 0)
			{
				d *= -1;
			}
			windowsFloatLine = L3DUtils.GetOffsetPoints(windowsLine, d);
			if(windowsFloatLine == null)
			{
				return null;
			}
			else
			{
				for(var i:int = windowsFloatLine.length - 1; i>=0;i--)
				{
					var vpoint:Vector3D = windowsFloatLine[i] as Vector3D;					
					points.push(new Point(vpoint.x, vpoint.y));
				}
			}			
			var boardTriangleResult:Array = new Array();
			Trianglulate.process(points, boardTriangleResult);			
			if(boardTriangleResult.length == 0)
			{
				return null;
			}
			
			var max:Vector3D = new Vector3D();
			var min:Vector3D = new Vector3D();
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				for(var j:int = 0; j<3; j++)
				{
					var cpoint:Point = boardTriangleResult[i][j] as Point;
					if(i==0 && j==0)
					{
						max.x = cpoint.x;
						max.y = cpoint.y;
						min.x = cpoint.x;
						min.y = cpoint.y;
					}
					else
					{
						max.x = Math.max(max.x, cpoint.x);
						max.y = Math.max(max.y, cpoint.y);
						min.x = Math.min(min.x, cpoint.x);
						min.y = Math.min(min.y, cpoint.y);
					}
				}
			}
			
			var boardMesh:L3DMesh = new L3DMesh();
			var attributes:Array = new Array();
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.POSITION);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[0]);
			attributes.push(VertexAttributes.TEXCOORDS[1]);
			attributes.push(VertexAttributes.TEXCOORDS[1]);
			attributes.push(VertexAttributes.NORMAL);
			attributes.push(VertexAttributes.NORMAL);
			attributes.push(VertexAttributes.NORMAL);
			boardMesh.geometry = new Geometry();
			boardMesh.geometry.addVertexStream(attributes);
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			var textures0:Vector.<Number> = new Vector.<Number>();
			var textures1:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				var point1:Point = boardTriangleResult[i][0] as Point;
				var point2:Point = boardTriangleResult[i][1] as Point;
				var point3:Point = boardTriangleResult[i][2] as Point;
				vertices.push(point1.x - 950, point1.y, windowHeight - 200);
				vertices.push(point2.x - 950, point2.y, windowHeight - 200);
				vertices.push(point3.x - 950, point3.y, windowHeight - 200);
				var u1:Number = (point1.x - min.x) / 1000;
				var v1:Number = (point1.y - min.y) / 1000;
				var u2:Number = (point2.x - min.x) / 1000;
				var v2:Number = (point2.y - min.y) / 1000;
				var u3:Number = (point3.x - min.x) / 1000;
				var v3:Number = (point3.y - min.y) / 1000;
				textures0.push(u1, v1, u2, v2, u3, v3);
				textures1.push(u1, v1, u2, v2, u3, v3);
				normals.push(0,0,-1,0,0,-1,0,0,-1);
			}
			
			for(var i:int = 0; i<boardTriangleResult.length; i++)
			{
				var point1:Point = boardTriangleResult[i][0] as Point;
				var point2:Point = boardTriangleResult[i][1] as Point;
				var point3:Point = boardTriangleResult[i][2] as Point;
				vertices.push(point1.x - 950, point1.y, windowHeight - 200);
				vertices.push(point3.x - 950, point3.y, windowHeight - 200);
				vertices.push(point2.x - 950, point2.y, windowHeight - 200);
				var u1:Number = (point1.x - min.x) / 1000;
				var v1:Number = (point1.y - min.y) / 1000;
				var u2:Number = (point2.x - min.x) / 1000;
				var v2:Number = (point2.y - min.y) / 1000;
				var u3:Number = (point3.x - min.x) / 1000;
				var v3:Number = (point3.y - min.y) / 1000;
				textures0.push(u1, v1, u3, v3, u2, v2);
				textures1.push(u1, v1, u3, v3, u2, v2);
				normals.push(0,0,-1,0,0,-1,0,0,-1);
			}
			
			var iNumber:int = vertices.length / 3;
			for (var i=0; i < iNumber; i+=3)
			{
				indices.push(i);
				indices.push(i + 1);
				indices.push(i + 2);
			}
			
			boardMesh.geometry.numVertices = vertices.length / 3;
			boardMesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			boardMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], textures0);
			boardMesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1], textures1);
			boardMesh.geometry.setAttributeValues(VertexAttributes.NORMAL, normals);
			boardMesh.geometry.indices = indices;
			
			var material:Material = BuildWallMaterial(stage3D);			
			boardMesh.addSurface(material, 0, indices.length / 3);
			boardMesh.matrix = new Matrix3D();
			boardMesh.matrix.identity();
			boardMesh.name = "WINDOWTOP";				
			
			return boardMesh;
		}
		
		private static function GetVector(startPoint:Vector3D, endPoint:Vector3D):Vector3D
		{
			var v:Vector3D = new Vector3D();
			v.x = endPoint.x - startPoint.x;
			v.y = endPoint.y - startPoint.y;
			v.z = endPoint.z - startPoint.z;
			return v;
		}
		
		private static function CompuWindowMatrix(startPoint:Vector3D, endPoint:Vector3D):Matrix3D
		{
			var v:Vector3D = GetVector(startPoint, endPoint);
			v.z = 0.0;
			v.normalize();
			var angle:Number = Math.atan2(v.y, v.x);
		//	angle += (Math.PI * 0.5);
			var matrix:Matrix3D = new Matrix3D();
			matrix.identity();	
			matrix.appendRotation(angle * 180 / Math.PI, new Vector3D(0,0,1));
			matrix.appendTranslation(startPoint.x, startPoint.y, startPoint.z);			
			return matrix;
		}		

		private function BuildFrameMaterial(stage3D:Stage3D):Material
		{
		//	return new FillMaterial(windowFrameColor);
			var diffuseMap:L3DBitmapTextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, windowFrameColor), null, stage3D, false, 512);
			var lightMap:TextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, 0x888888), null, stage3D, false, 64);
			var material:Material = new LightMapMaterial(diffuseMap, lightMap);			
			return material;
		}
		
		private function BuildBoardMaterial(stage3D:Stage3D):Material
		{
			return new FillMaterial(windowBoardColor, 0.5);
		}
		
		private function BuildWallMaterial(stage3D:Stage3D):Material
		{
		//	return new FillMaterial(windowWallColor);
			var diffuseMap:L3DBitmapTextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, windowWallColor), null, stage3D, false, 512);
			var lightMap:TextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, 0x6A6A6A), null, stage3D, false, 64);
			var material:Material = new LightMapMaterial(diffuseMap, lightMap);			
			return material;
		}
		
		private function BuildTableMaterial(stage3D:Stage3D):Material
		{
		//	return new FillMaterial(windowTableColor);
			var diffuseMap:L3DBitmapTextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, windowTableColor), null, stage3D, false, 512);
			var lightMap:TextureResource = new L3DBitmapTextureResource(new BitmapData(16, 16, false, 0x888888), null, stage3D, false, 64);
			var material:Material = new LightMapMaterial(diffuseMap, lightMap);			
			return material;
		}

		public function BuildWindowsComplete(catalog:int = 30, paramLength1:Number = 0, paramLength2:Number = 0):void
		{
			var info:String= Exist ? "完成":"为空";
			if(windowsMesh != null)
			{
				windowsMesh.Mode = catalog;
				windowsMesh.Align(0);
				windowsMesh.OffGround = windowOffGround;
				windowsMesh.Name = windowsName;
				windowsMesh.paramLength1 = paramLength1;
				windowsMesh.paramLength2 = paramLength2;
			}
			var events:L3DBuildWindowEvent = new L3DBuildWindowEvent(L3DBuildWindowEvent.BUILDWINDOW, info, windowsMesh, WindowLength, windowHeight, 0, floatDistance, leftWindowLength, rightWindowLength);
			this.dispatchEvent(events);			
		}
	}
}
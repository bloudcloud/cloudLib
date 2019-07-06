package clapboardCode.sdObject
{
	import flash.display.BitmapData;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.graphics.BitmapFill;
	import mx.graphics.BitmapFillMode;
	
	import spark.primitives.Graphic;
	import spark.primitives.Path;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DMaterialInformations;
	
	import clapboardCode.components.WallBoardRectangle;
	import clapboardCode.models.WallBoardPartType;
	
	import cloud.core.datas.maps.CHashMap;
	
	import extension.cloud.singles.C3DUtil;
	
	import model.geom.Trianglulate;
	
	import utils.ObjectTool;
	
	public class BoardComp extends UIComponent
	{
		
		//投影到xoz平面
		private static const _proj_mat:Matrix3D=new Matrix3D(new Vector.<Number>([
																	1,0,0,0,
																	0,0,0,0,
																	0,0,1,0,
																	0,0,0,1])
															);
		public var dat:WallBoardDragTool ;
		//参数化板
		private var _board:Object = null;
		//纹理贴图
		private var _bitmap:BitmapData = null;
		private var oldOrig:Point = null;
		private var _materialHashMap:CHashMap;
		private var _loadNum:int;
		
		public function get bitmap():BitmapData
		{
			return _bitmap;
		}

		public function set bitmap(value:BitmapData):void
		{
			_bitmap = value;
		}
			
		public function get board():Object
		{
			return _board;
		}
		
		public function set board(value:Object):void
		{
			_board = value;
			if(_board==null)return;
			_board.uiObject = this;
			print(value);
			if( _board.type == WallBoardPartType.FLOWER_BOARD )
			{
				loadTexture(null,_board.cornerRotation);
			}
			else
				loadTexture(null);
		}
		
		public function loadGraphicTexture(bm:BitmapData):void
		{
				_bitmap = bm;
				project();
				this.graphics.clear();
				onDraw();
		}

		private var information:L3DMaterialInformations;
		private var loadingBuffer:ByteArray = null;
		
		public function getMidColor():uint
		{
			if(_bitmap == null)
			{
				return 0x000000;
			}
			
			var color:uint = _bitmap.getPixel(_bitmap.width / 2, _bitmap.height / 2);
			var R:int = (color>>16)&0xFF;
			var G:int = (color>> 8)&0xFF;
			var B:int = (color)&0xFF;
			if(R < 100 && G < 100 && B < 100)
			{
				return 0xFFFFFF;
			}
			
			return 0x000000;
		}
	
//		private function SearchMaterialInfoHandler(event:L3DLibraryEvent):void
//		{
//			if(event.MaterialInformation == null)
//			{					
//				return;
//			}
//			event.MaterialInformation.addEventListener(L3DLibraryEvent.LoadPreview, LoadPreviewCompleteHandler);
//			event.MaterialInformation.LoadPreview();
//		}
//
//		
//		private function LoadPreviewCompleteHandler(event:L3DLibraryEvent):void
//		{
//			var material:L3DMaterialInformations = event.target as L3DMaterialInformations;
//			material.removeEventListener(L3DLibraryEvent.LoadPreview, LoadPreviewCompleteHandler);
//			if(event.PreviewBitmap == null)
//			{
//				return;
//			}
//			project();
//			var maxV:Number = Math.max(_proj_w, _proj_h);
//			var w:Number =  Math.ceil(Math.min(_proj_w, _proj_h) / maxV * event.PreviewBitmap.width);
//			if(w>=event.PreviewBitmap.width){
//				w = w - 1;
//			}
//			var h:Number = Math.ceil(event.PreviewBitmap.height);
//			if(h>=event.PreviewBitmap.height){
//				h = h - 1;
//			}
//			var s:Vector3D = material.GetSizeVector();
//			if(s.z > 0)
//			{
//				if(s.x > s.z)
//				{
//					w = 500;
//					h = 500 * s.z / s.x;
//				}
//				else
//				{
//					h = 500;
//					w = 500 * s.x / s.z;
//				}
//			}
//			var checkBitmap:BitmapData = L3DMaterial.BitmapSizeScale(event.PreviewBitmap, w, h);
//			_bitmap = checkBitmap;
//			this.graphics.clear();
//			if(event.PreviewBitmap != null)
//			{
//				event.PreviewBitmap.dispose();
//				event.PreviewBitmap = null;
//			}
//			onDraw();
//		}
		
		private var bRect:WallBoardRectangle; 
		
		/**
		* 加载材质贴图 
		* 
		*/
		public function loadTexture(materialInfo:L3DMaterialInformations=null,rotation:Number=0):void
		{
			svgRotation = rotation;
			svgPath = "";
			_loadNum = 0;
			
			switch(board.type)
			{
				case WallBoardPartType.INTO_BOARD:
				{
					bRect = _board as WallBoardRectangle;
					if(null != bRect.lineMaterial){
						_loadNum++;
						materialInfo = new L3DMaterialInformations();
						materialInfo.code = bRect.lineMaterial;
						materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoCompleteHandler);
						materialInfo.SearchMaterialInformation(materialInfo.code);
					}
					break;
				}
				default:{
					if(null != _board.material){
						_loadNum++;
						materialInfo = new L3DMaterialInformations();
						materialInfo.code = _board.material;
						materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoCompleteHandler);
						materialInfo.SearchMaterialInformation(materialInfo.code);
						if(_board.type==WallBoardPartType.FLOWER_BOARD)
						{
							_loadNum++;
							materialInfo = new L3DMaterialInformations();
							materialInfo.code = _board.code;
							materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, searchFlowerBoardComplete);
							materialInfo.SearchMaterialInformation(materialInfo.code);
						}
					}
				}
			}
			
		}
		private function searchFlowerBoardComplete(evt:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations = evt.MaterialInformation;
			materialInfo.addEventListener(L3DMaterialInformations.DownloadLinkedData,loadSVGComplete);
			materialInfo.DownloadLinkedDataBuffer();
		}
		private function SearchMaterialInfoCompleteHandler(event:L3DLibraryEvent):void{
			var materialInfo:L3DMaterialInformations=event.MaterialInformation;
			materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadMaterialBufferCompleteHandler);
			materialInfo.DownloadMaterial();
		}
		private function LoadMaterialBufferCompleteHandler(evt:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations=evt.target as L3DMaterialInformations;
			materialInfo.removeEventListener(evt.type,LoadMaterialBufferCompleteHandler);
			materialInfo.previewBuffer=evt.MaterialBuffer;
			materialInfo.addEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			materialInfo.LoadPreview();
		}
		private var svgPath:String = "";
		private function loadSVGComplete(evt:L3DLibraryEvent):void
		{
			if(evt.data==null) return;
			var materialInfo:L3DMaterialInformations;
			materialInfo=getMaterialInfo(evt.target.code);
			if(materialInfo==null)
			{
				materialInfo=evt.target as L3DMaterialInformations;
				saveMaterialInfo(evt.target.code, evt.target as L3DMaterialInformations);
				materialInfo.userData7=_board.L;
				materialInfo.userData6=_board.H;
				materialInfo.userData5=scale;
				var xml:XML=XML(evt.data);
				materialInfo.userData8=xml.path.@d.toString();
			}
			doDraw(materialInfo);
		}
		private function loadPreviewHandler(event:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations = event.target as L3DMaterialInformations;
			materialInfo.removeEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			saveMaterialInfo(materialInfo.code,materialInfo);
			materialInfo.Preview=event.PreviewBitmap;
			doUpdateCurrentBoardQuotaData(materialInfo);
			doDraw(materialInfo);
		}
		private function doUpdateCurrentBoardQuotaData(materialInfo:L3DMaterialInformations):void
		{
			if(_board)
			{
				_board.price = materialInfo.price;
				_board.cName = materialInfo.name;
				_board.size = materialInfo.GetSizeVector();
				_board.byteArray = materialInfo.previewBuffer;
			}
		}
		private function doDraw(materialInfo:L3DMaterialInformations=null):void
		{
			if(null==materialInfo) return;
			if(materialInfo.Preview!=null)
			{
			 	_bitmap=materialInfo.Preview;
				if(board.texRotation !=0)
				{
					_bitmap = ObjectTool.bitmapdataRotate(_bitmap,board.texRotation);
				}
			}
			if(materialInfo.userData8!=null)
				svgPath = materialInfo.userData8.toString();
			if(--_loadNum==0)
				onDraw(false,materialInfo);
		}
		private function saveMaterialInfo(code:String,materialInfo:L3DMaterialInformations):void
		{
			if(!_materialHashMap.containsKey(materialInfo.code))
			{
				_materialHashMap.put(code,materialInfo);
			}
		}
		private function getMaterialInfo(code:String):L3DMaterialInformations
		{
			return _materialHashMap.get(code) as L3DMaterialInformations;
		}
		/**
		 *高亮 
		 * 
		 */
		public function highlight():void
		{
			onDraw(true);

		}
		
		/**
		 *取消高亮 
		 * 
		 */
		public function unhighlight():void
		{
			this.graphics.clear();
			onDraw();
		}
		
		//比例尺
		private var _scale:Number = 2.0;
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		public function get materialHashMap():CHashMap
		{
			return _materialHashMap;
		}
		public function BoardComp(materialHashMap:CHashMap,bd:Object=null, sc:Number=1.0)
		{
			super();
			_materialHashMap=materialHashMap;
			board = bd;
			_scale = sc;
			if(null != _board)
			{
				project();
				//onDraw();
			}
		}
		
		public function onDraw(isDrawOutLine:Boolean = false, materialInfo:L3DMaterialInformations=null):void
		{

			if(_board == null)return;
			
			this.removeChildren();
			this.width = _proj_w/scale;
			this.height = _proj_h/scale;
			switch(board.type)
			{
				case WallBoardPartType.INTO_BOARD:
				{
					//画嵌板
					drawQianBan(isDrawOutLine);
					break;
				}
				case WallBoardPartType.FLOWER_BOARD:
					drawFlower(isDrawOutLine);
					break;
				default:
				{
					//画面板，上，地脚，腰线,角花
					drawRect(isDrawOutLine);
					break;
				}
			}
		}
		
		private function drawRect(isDrawOutLine:Boolean = false):void
		{
			if(_board == null)return;	
			this.graphics.clear();
			if(_bitmap != null)
			{
				var matrix:Matrix = new Matrix();
				matrix.scale(1/_scale,1/_scale);
				this.graphics.beginBitmapFill(_bitmap,matrix,true,false);
			}
			else
				this.graphics.beginFill(0xDAD6D1);
			if(_board.hasOwnProperty("uvPoints") &&_board.uvPoints.length > 0)
			{
				var indices:Vector.<int> = new Vector.<int>();
				var vertexes:Vector.<Number> = new Vector.<Number>();
				var points:Array = [];
				points.push(new Vector3D(0,0),new Vector3D(0,this.height -1),new Vector3D(this.width,this.height),new Vector3D(this.width,0));
				Trianglulate.getTristrip(points, vertexes, indices);
				var uvs:Vector.<Number>=new Vector.<Number>();
				var uDir:Vector3D = new Vector3D(1,0,0);
				var vDir:Vector3D = new Vector3D(0,1,0);
				var uMax:Number = this.width;
				var vMax:Number = this.height - 1;
				var scaleX:Number = this.width/_board.L;
				var scaleY:Number  = this.height /_board.H;
				C3DUtil.Instance.getUV(points[0],points[2],uDir,vDir,_board.uvPoints[2].x*scaleX,_board.uvPoints[2].y*scaleY,uvs);
				C3DUtil.Instance.getUV(points[1],points[2],uDir,vDir,_board.uvPoints[2].x*scaleX,_board.uvPoints[2].y*scaleY,uvs);
				C3DUtil.Instance.getUV(points[2],points[2],uDir,vDir,_board.uvPoints[2].x*scaleX,_board.uvPoints[2].y*scaleY,uvs);
				C3DUtil.Instance.getUV(points[3],points[2],uDir,vDir,_board.uvPoints[2].x*scaleX,_board.uvPoints[2].y*scaleY,uvs);
				this.graphics.drawTriangles(vertexes, indices, uvs);
			}
			else
			{
				this.graphics.drawRect(0,0,this.width, this.height-1);
			}
			this.graphics.endFill();
//			this.graphics.lineStyle(1,0x000000,.5);
//			this.graphics.drawRect(0,0,this.width,this.height -1 );
//			this.graphics.endFill();
			if(isDrawOutLine)
			{
				this.graphics.lineStyle(2,0xffff00,1);
				this.graphics.drawRect(0,0,this.width,this.height -1 );
				this.graphics.endFill();
			}

		}
		private var svgGraphic:Graphic = new Graphic();
		private function drawFlower(isDrawOutLine:Boolean = false):void
		{
			this.graphics.clear();
			if( this.contains(svgGraphic) )
				this.removeChild(svgGraphic);
			if(isDrawOutLine)
				this.graphics.lineStyle(2,0xffff00,1);
			if(_bitmap != null && svgPath != "")
			{
				svgGraphic = new Graphic(); 
				this.addChild(svgGraphic);
				var path4:Path = new Path();
				path4.data = svgPath;
				path4.width = _board.L;
				path4.height = _board.H;
				var bitmapFill4:BitmapFill = new BitmapFill();
				bitmapFill4.source = _bitmap;
				bitmapFill4.fillMode = BitmapFillMode.REPEAT;
				path4.fill=bitmapFill4;
				path4.winding = GraphicsPathWinding.EVEN_ODD;
				svgGraphic.addElement(path4);
				svgGraphic.width = _board.L;
				svgGraphic.height =_board.H;
				svgGraphic.validateNow();
				if( svgRotation == 90 )
				{
					svgGraphic.x = _board.L/scale;
					svgGraphic.y = 0;
				}
				else if( svgRotation == -90 || svgRotation == 270 )
				{
					svgGraphic.x = 0;
					svgGraphic.y = board.H/scale;
				}
				else if( svgRotation == 180 )
				{
					svgGraphic.x = _board.L/scale;
					svgGraphic.y = _board.H/scale;
				}
				else
				{
					svgGraphic.x = 0;
					svgGraphic.y = 0;
				}
				svgGraphic.scaleX = svgGraphic.scaleY = 1/scale;
				svgGraphic.rotation = svgRotation;
				/*var group:Group = new Group();
				group.width = 600;
				group.height = 600;
				group.addElement(svgraphic);
				PopUpManager.addPopUp(group,FlexGlobals.topLevelApplication as DisplayObject,false);*/
//				var bmp:BitmapData = new BitmapData(164,164);
//				bmp.draw(this);
//				var group:UIComponent = new UIComponent();
//				group.width = 164;
//				group.height = 164;
//				group.addChild(new Bitmap(bmp));
//				PopUpManager.addPopUp(group,FlexGlobals.topLevelApplication as DisplayObject,false);
			}
			else
			{
				this.graphics.beginFill(0xDAD6D1);
				this.graphics.drawRect(0,0,this.width, this.height-1);
				this.graphics.endFill();
			}
			
		}
		
		private function drawQianBan(isDrawOutLine:Boolean = false):void
		{
			updateQianBan(board as WallBoardRectangle,isDrawOutLine);
			this.graphics.endFill();
		}
		/**
		 * 根据一点，从物体集合中获取拣选到的物体 
		 * @param pos	一个点的坐标
		 * @param objects	物体集合
		 * @return Object	拣选到的物体对象
		 * 
		 */		
		public function getCollisionObject(pos:Vector3D, objects:Array):Object
		{
			var collisionObj:Object;
			var collisions:Array=new Array();
			var minX:Number=int.MAX_VALUE,minY:Number=int.MAX_VALUE;
			var maxX:Number=int.MIN_VALUE,maxY:Number=int.MIN_VALUE;
			var minArea:Number=int.MAX_VALUE;
			for each(var obj:Object in objects)
			{
				if(pos.w==0)
				{
					//2D
					for each(var point:Vector3D in obj.points)
					{
						if(minX>point.x) minX=point.x;
						if(maxX<point.x) maxX=point.x;
						if(minY>point.y) minY=point.y;
						if(maxY<point.y) maxY=point.y;
					}
					if(pos.x>minX && pos.x<maxX && pos.y>minY && pos.y<maxY)
					{
						//选中物体
						collisions.push(obj);
					}
					minX=minY=int.MAX_VALUE;
					maxX=maxY=int.MIN_VALUE;
				}
				else
				{
					//3D
				}
			}
			if(collisions.length==1)
			{
				collisionObj=collisions[0];
			}
			else if(collisions.length>1)
			{
				//选择面积最小的对象
				for each(obj in collisionObj)
				{
					if(minArea>obj.length*obj.height)
					{
						minArea=obj.length*obj.height;
						collisionObj=obj;
					}
				}
				minArea=int.MAX_VALUE;
			}
			return collisionObj;
		}

		public function onCallBack(arg:Array):void
		{
			var p:Point = new Point();
			if(this.x!=arg[4].x)
				p.x = board.origPoint.x + (this.width - Math.abs(arg[1].x -arg[0].x))/2*_scale;
			else
				p.x = board.origPoint.x - (this.width - Math.abs(arg[1].x -arg[0].x))/2*_scale;			
			if(this.y==arg[4].y)			
				p.y = board.origPoint.y + (this.height - (arg[2].y+arg[3].y)/2)*_scale;	
			else
				p.y = board.origPoint.y;

			this.width = Math.abs(arg[1].x -arg[0].x);
			this.height =  Math.abs(arg[1].y -arg[2].y);
			_board.L = this.width*_scale;
			_board.H = this.height*_scale;
			_board.setOrigPoint(p);
			setPosition();
			if(dat != null)
			{
				dat.visible =false;
			}
			updateQianBan(_board as WallBoardRectangle);
		}
		public function updateQianBan(board:WallBoardRectangle,isDrawOutLine:Boolean = false):void
		{
			this.graphics.clear();
			var WBRect:WallBoardRectangle = board;
			if(!WBRect)return;
			var thick:Number = WBRect.lineWidth/scale;
			var outRingPoint:Vector.<Point> = new Vector.<Point>();
			var inRingPoint:Vector.<Point> = new Vector.<Point>();
			//左上角开始，顺时针
			outRingPoint.push(new Point(0,0));
			outRingPoint.push(new Point(this.width,0));
			outRingPoint.push(new Point(this.width,this.height));
			outRingPoint.push(new Point(0,this.height));
			
			inRingPoint.push(new Point(thick,thick));
			inRingPoint.push(new Point(this.width - thick,thick));
			inRingPoint.push(new Point(this.width - thick,this.height - thick));
			inRingPoint.push(new Point(thick,this.height - thick));
//			if(isDrawOutLine)
//				this.graphics.lineStyle(2,0xffff00,1);
			if(_bitmap != null)
			{
				var matrix:Matrix = new Matrix();
				matrix.scale(1/_scale,1/_scale);
				this.graphics.beginBitmapFill(_bitmap,matrix,true,true);
			}
			else
				this.graphics.beginFill(0xDAD6D1);
			this.graphics.drawRect(0,0,this.width,thick);//上
			this.graphics.drawRect(this.width - thick,thick,thick,this.height - 2*thick);//右
			this.graphics.drawRect(0,this.height - thick,this.width,thick);//下
			this.graphics.drawRect(0,thick,thick,this.height - 2*thick);//左
			this.graphics.endFill();
//			this.graphics.lineStyle(1,0x000000,.5);
//			for(var i:int =0;i<outRingPoint.length;i++)
//			{
//				var a:Point = outRingPoint[i];
//				var b:Point = outRingPoint[(i+1)%outRingPoint.length];
//				var c:Point = inRingPoint[(i+1)%outRingPoint.length];
//				var d:Point = inRingPoint[i];
//				this.graphics.moveTo(a.x,a.y);
//				this.graphics.lineTo(b.x,b.y);
//				this.graphics.lineTo(c.x,c.y);
//				this.graphics.lineTo(d.x,d.y);
//				//this.graphics.lineTo(a.x,a.y);
//			}
//			this.graphics.endFill();
			if(isDrawOutLine)
			{
				this.graphics.lineStyle(2,0xffff00,1);
				for(var i:int =0;i<outRingPoint.length;i++)
				{
					var a:Point = outRingPoint[i];
					var b:Point = outRingPoint[(i+1)%outRingPoint.length];
					var c:Point = inRingPoint[(i+1)%outRingPoint.length];
					var d:Point = inRingPoint[i];
					this.graphics.moveTo(a.x,a.y);
					this.graphics.lineTo(b.x,b.y);
					this.graphics.lineTo(c.x,c.y);
					this.graphics.lineTo(d.x,d.y);
					//this.graphics.lineTo(a.x,a.y);
				}
			}
		}
		public function onRefresh(orig:Point = null):void
		{
			
			if(dat&&this.contains(dat))
			{
				this.removeChild(dat);
			}
			this.graphics.clear();
			setPosition(orig);
			onDraw();
		}
		public function setPosition(orig:Point = null):void
		{
			if(_board == null)return;
			project();
			if(orig == null){
				orig = oldOrig;
			}
			else
			{
				oldOrig = orig;
			}
			this.x = orig.x + _proj_o.x/_scale - _proj_w/_scale/2;
			this.	y = orig.y - _proj_o.y/_scale - _proj_h/_scale;
		}
	
		private var _proj_w:Number = 0;
		private var _proj_h:Number = 0;
		private var _proj_o:Point = new Point();
		private var svgRotation:Number = 0;
		private function project():void
		{
			this._proj_w = board.L;	
			this._proj_h = board.H;
			
			this._proj_o.x = board.origPoint.x;
			this._proj_o.y = board.origPoint.y;
		}
		
		public function get projectWidth():Number{
			return this._proj_w;
		}
		public function get projectHeight():Number{
			return this._proj_h;
		}
		public function get projectPosition():Point{
			return new Point(this._proj_o.x, this._proj_o.y);
		}	
		
	}
}
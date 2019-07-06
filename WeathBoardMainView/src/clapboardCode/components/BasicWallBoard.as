package clapboardCode.components
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DLibraryWebService;
	import L3DLibrary.L3DMaterialInformations;
	
	import clapboardCode.models.WallBoardMaterial;
	import clapboardCode.models.WallBoardPartType;
	import clapboardCode.models.WallBoardPriceData;
	
	import extension.cloud.dict.CWebServiceDict;
	import extension.cloud.singles.C3DUtil;
	
	import model.geom.Trianglulate;
	
	import utils.ObjectTool;
	import utils.lx.managers.GlobalManager;
	
	public class BasicWallBoard extends Sprite
	{
		
		private var _data:XML;
		
		// X坐标
		public var positionX:Number =0;
		//类型
		public var type:String = "";
		//长
		public var L:Number = 0;
		//高
		public var H:Number = 0;
		//厚度
		public var W:Number = 0;
		//离地高
		public var offGround:Number = 0;
		
		private var _byteArray:ByteArray;
		
		private var _cName:String = "";
		
		private var _price:Number = 0;
//		/**
//		 * 父容器是否需要更新 
//		 */		
//		private var _invalidParent:Boolean;
		
		
		
		//模型编码
		public var code:String = "";
		//贴图材质编码
		public var material:String = "";
		//对应的UI Object
		public var uiObject:Object = null
		//所属父单元
		private var _parentUnit:Object = null;
		//板件的坐标原点
		private var _origPoint:Point = new Point(0,0);
		//只有顶部的时候板件高度
		public var positionY:Number = 0;
		//板件选择角度
		public var texRotation:Number =0;
		private var _centerPointRelative:Point = new Point();
		private var _centerPointCoordinate:Point = new Point();
		private var _cornerRotation:Number = 0;
		//角花svg路劲
		private  var _svgPath:String ="";

		public static const LoadMaterialComplete:String = "BasicWallBoard_LoadMaterialComplete";
		
		private var _uvPoints:Array = [];
		public function get uvPoints():Array
		{
			return _uvPoints;
		}
		
		public function set uvPoints(value:Array):void
		{
			_uvPoints = value;
		}
		public function get svgPath():String
		{
			return _svgPath;
		}

		public function set svgPath(value:String):void
		{
			_svgPath = value;
		}

		public function get cornerRotation():Number
		{
			return _cornerRotation;
		}

		public function set cornerRotation(value:Number):void
		{
			_cornerRotation = value;
		}

		public function get size():Vector3D
		{
			return _size;
		}

		public function set size(value:Vector3D):void
		{
			_size = value;
		}

		public function get price():Number
		{
			return _price;
		}

		public function set price(value:Number):void
		{
			_price = value;
		}

		public function get cName():String
		{
			return _cName;
		}

		public function set cName(value:String):void
		{
			_cName = value;
		}

		public function get byteArray():ByteArray
		{
			return _byteArray;
		}

		public function set byteArray(value:ByteArray):void
		{
			_byteArray = value;
		}

		public function get origPoint():Point
		{
			return _origPoint;
		}
		public function set origPoint(p:Point):void
		{
			 _origPoint.copyFrom(p);
		}
		
		
		public function get parentUnit():Object
		{
			return _parentUnit;
		}
		public function set parentUnit(value:Object):void
		{
			if(_parentUnit!=value)
			{
				if(value==null)
				{
					_origPoint.y+=-(_parentUnit as BasicWallBoard).origPoint.y;
				}
				else if(_parentUnit==null)
				{
					_origPoint.y+=(value as BasicWallBoard).origPoint.y;
				}
				else
				{
					_origPoint.y+=-(parentUnit as BasicWallBoard).origPoint.y+(value as BasicWallBoard).origPoint.y;
				}
				offGround=_origPoint.y;
				_parentUnit = value;
			}
		}
		
		public function BasicWallBoard()
		{
			super();
		}

		public function setXMLData(xml:XML):void
		{
			_data = xml;
		}
		
		public function get data():XML
		{
			return _data;
		}
		
		public function get vo():Object
		{
			return null;
		}
		
		public function searchMaterial():void
		{
			
		}
		
		public function getCenterPointRelative():Point
		{
			_centerPointRelative.x = this.width*0.5;
			_centerPointRelative.y = this.height*0.5;
			return _centerPointRelative.clone();
		}
		
		public function getCenterPointCoordinate():Point
		{
			_centerPointCoordinate.x = this.width*0.5 + this.x;
			_centerPointCoordinate.y = this.height*0.5 + this.y;
			return _centerPointCoordinate.clone();
		}
		
		/**
		 * 根据主板的中点坐标计算自己的坐标
		 */
		public function calcCoordinateByCenter(mainCenter:Point):void
		{
			var ox:Number = mainCenter.x + vo.x;
			var oy:Number = vo.offGround +vo.height;					
			this.x = ox - this.width*0.5;
			this.y = mainCenter.y*2-oy;
		}
		
		/**
		 * 
		 */
		private function setOffgroud():void
		{
			offGround = this.origPoint.y;
		}
		
		/**
		 * 矩形画填充材质
		 */
		public function drawMaterial(bmd:BitmapData,ang:Number =0):void
		{
			if(bmd != null)
			{
				if(ang != 0)
					bmd  = ObjectTool.bitmapdataRotate(bmd,ang);
				this.graphics.beginBitmapFill(bmd);
			}
			else
			{
				this.graphics.beginFill(0xDAD6D1);
			}
			if(this.hasOwnProperty("uvPoints") &&this.uvPoints.length > 0)
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
				C3DUtil.Instance.getUV(points[0],points[2],uDir,vDir,this.uvPoints[2].x,this.uvPoints[2].y,uvs);
				C3DUtil.Instance.getUV(points[1],points[2],uDir,vDir,this.uvPoints[2].x,this.uvPoints[2].y,uvs);
				C3DUtil.Instance.getUV(points[2],points[2],uDir,vDir,this.uvPoints[2].x,this.uvPoints[2].y,uvs);
				C3DUtil.Instance.getUV(points[3],points[2],uDir,vDir,this.uvPoints[2].x,this.uvPoints[2].y,uvs);
				this.graphics.drawTriangles(vertexes, indices, uvs);
			}
			else
			{
				this.graphics.drawRect(0,0,vo.length, vo.height);
			}
			this.graphics.endFill();
//			this.graphics.beginBitmapFill(bmd,null,true,true);
//			this.graphics.drawRect(0,0,vo.length,vo.height);
//			this.graphics.endFill();
		}
		
		/**
		 * 添加材质
		 */
		public function addMaterial():void
		{
			
		}
		
		public function clone():Object
		{
			var bd:BasicWallBoard = new BasicWallBoard();
			bd.code = this.code
			bd.material = this.material
			bd.type = this.type;
			bd.L = this.L;
			bd.W = this.W;
			bd.H = this.H;
			bd.offGround = this.offGround;
			bd.positionX = this.positionX;
			bd.origPoint = this.origPoint;
			bd.texRotation = this.texRotation;
			return bd;
		}
		
		public function dispose():void
		{
			_data = null;
			_centerPointRelative = null;
			_centerPointCoordinate = null;
		}
		
		/**
		 * 解析xml
		 */
		public function deserilizeXML(xml:XML):void
		{
			code=String(xml.@code);
			material=String(xml.@material);
			type=String(xml.@type);
			L=Number(xml.@length);
			W=Number(xml.@width);
			H=Number(xml.@height);
			offGround=Number(xml.@offGround);
			positionX = Number(xml.@offLeft);
			texRotation = Number(xml.@texRotation);
			if((xml.@type) == WallBoardPartType.TOPLINE_BOARD&&Number(xml.@positionY) !=0)
			{
				_origPoint = new Point(positionX,xml.@positionY);
				positionY = offGround;
			}
			else
			{
				_origPoint = new Point(positionX,offGround);
			}
		}
		
		/**
		 * 移动原点坐标 
		 * @param p
		 * 
		 */
		public function setTranslation(p:Point):void
		{
			this.origPoint.x+=p.x;
			this.origPoint.y+=p.y;
			setOffgroud();
		}
		/**
		 * 设置原点坐标 
		 * @param p
		 * 
		 */
		public function setOrigPoint(orig:Point):void 
		{
			var p:Point = new Point(orig.x-origPoint.x, orig.y-origPoint.y);
			setTranslation(p);
			setOffgroud();
		}
		
		public function searchMaterialByCode(code:String):void
		{
			var materialInfo:L3DMaterialInformations
			this.code=code;
			if(WallBoardMaterial.instance.hasMaterial(code)){
				materialInfo = WallBoardMaterial.instance.getMaterial(this.code) as L3DMaterialInformations;
				drawMaterial(materialInfo.Preview);
				return;
			}
			materialInfo = new L3DMaterialInformations();
			materialInfo.code = code;
			materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoCompleteHandler);
			materialInfo.SearchMaterialInformation(materialInfo.code);
		}
		
		private function SearchMaterialInfoCompleteHandler(event:L3DLibraryEvent):void{
			var materialInfo:L3DMaterialInformations = event.target as L3DMaterialInformations;
			
			//zh 2018.8.3
			GlobalManager.Instance.serviceMGR.sendWebRequest(CWebServiceDict.REQUEST_GETVIEWDETAILBUFFERFROMCODE,SearchMaterialInformationResult, SearchMaterialInformationFault, materialInfo.code, 0);
 		}
		
		private function SearchMaterialInformationResult(event:ResultEvent):void
		{
			var buffer:ByteArray = event.result as ByteArray;
			var e:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			var materialInfo:L3DMaterialInformations;
			if(buffer != null && buffer.length > 0)
			{
				materialInfo = new L3DMaterialInformations(buffer, "");				
				e.MaterialInformation = materialInfo;
			}
			else
			{
				e.MaterialInformation = null;
			}
			//			print("LoadMaterialBuffer:"+materialInfo.code);
			//			print("LoadMaterialBuffer  URL:"+materialInfo.url); 
			materialInfo.addEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			materialInfo.LoadPreview();
		}
		
		private function SearchMaterialInformationFault(event:FaultEvent):void
		{
			var e:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			e.MaterialInformation = null;
			dispatchEvent(e);
		}
		
		private function loadPreviewHandler(event:L3DLibraryEvent):void
		{
			var materialInfo:L3DMaterialInformations = event.target as L3DMaterialInformations;
			//			print("loadPreview:"+materialInfo.code);
			materialInfo.removeEventListener(L3DLibraryEvent.LoadPreview,loadPreviewHandler);
			materialInfo.Preview = event.PreviewBitmap;
			byteArray = materialInfo.previewBuffer;
			cName = materialInfo.name;
			price = materialInfo.price;
			size = materialInfo.GetSizeVector();
			WallBoardMaterial.instance.addMaterial(this.code,materialInfo);
			drawMaterial(materialInfo.Preview);
		}
		
		private var _size:Vector3D = null;
		
		public function get wallBoardPriceData():WallBoardPriceData
		{
			var wbpd:WallBoardPriceData = new WallBoardPriceData();
			wbpd.type = type;
			wbpd.length = L;
			wbpd.width = W;
			wbpd.height = H;
			wbpd.code = code;
			wbpd.name = cName;
			wbpd.price = price;
			wbpd.previewBuffer = byteArray;
			wbpd.size = size;
			wbpd.material = material;
			return wbpd;
		}
		
	}
}
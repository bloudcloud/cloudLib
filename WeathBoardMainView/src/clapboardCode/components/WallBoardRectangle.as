package clapboardCode.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.graphics.BitmapFill;
	import mx.graphics.BitmapFillMode;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	import spark.primitives.Graphic;
	import spark.primitives.Path;
	
	import L3DLibrary.L3DMaterialInformations;
	
	import clapboardCode.models.WallBoardMaterial;
	import clapboardCode.models.WallBoardPriceData;
	
	import utils.ObjectTool;
	
	import wallDecorationModule.model.vo.CClapboardRectangleVO;

	public class WallBoardRectangle extends BasicWallBoard
	{
		private var realCode:String;
		private var boardCode:String;
		//嵌板厚度
		public var thick:Number = 10;
		//lineType：线类型
		public var lineType:String = "";
		//lineCode：线模型编码
		public var lineCode:String = "";
		public var lineName:String = "";
		//lineMaterial：线材质编码
		private var _lineMaterial:String = "";
		//cornerType：角花类型
		public var cornerType:String = "";
		public var cornerName:String = "";
		//cornerCode：角花模型编码
		public var cornerCode:String = "";
		//cornerMaterial：角花材质编码
		private var _cornerMaterial:String = "";
		//cornerLength：角花长度
		public var cornerLength:Number = 0;
		//cornerWidth：角花宽度
		public var cornerWidth:Number = 0;
		//线厚度
		public var lineWidth:Number = 20;
		/**
		 * 线条的个数 
		 */		
		public var lineNum:Number;
		//嵌板里面的面板
		public var paramBasicBoard:BasicWallBoard = new BasicWallBoard;

		//嵌板角花
		public var paramCornerBoard:Vector.<BasicWallBoard> = new Vector.<BasicWallBoard>;
		//所有的引用子嵌板部件
		public var paramBoard:Vector.<WallBoardRectangle> = new Vector.<WallBoardRectangle>();
		
		//当前嵌板区域围点
		public var roundPoints:Vector.<Vector3D>;
		//嵌板
		public function WallBoardRectangle()
		{
			super();
		}


		public function get cornerMaterial():String
		{
			return _cornerMaterial;
		}

		public function set cornerMaterial(value:String):void
		{
			_cornerMaterial = value;
		}

		public function get lineMaterial():String
		{
			return _lineMaterial;
		}

		public function set lineMaterial(value:String):void
		{
			_lineMaterial = value;
		}

		override public function setXMLData(xml:XML):void
		{
			super.setXMLData(xml);
			if(String(xml.name())=="CClapboardRectangleVO")
				var classDict:Class =CClapboardRectangleVO;
			_vo = new classDict(getQualifiedClassName(CClapboardRectangleVO));
			_vo.deserialize(xml);
			
//			var arg:Array = String(_vo.lineCode).split("_");
			realCode = String(_vo.lineMaterial);
			boardCode = String(_vo.material);
			cornerMaterial = String(_vo.cornerMaterial);
			cornerCode = String(_vo.cornerCode);
			cornerLength = Number(_vo.cornerLength);
			cornerWidth = Number(_vo.cornerWidth);
			this.graphics.beginFill(0x00ff00,0.01);
			this.graphics.drawRect(0,0,vo.length,vo.height);
			this.graphics.endFill();
		}
		
		override public function searchMaterial():void
		{
			WallBoardMaterial.instance.searchMaterialByCode(realCode);
			if(boardCode != null&&boardCode !="")
			{
				WallBoardMaterial.instance.searchMaterialByCode(boardCode);
			}
			if(cornerMaterial != null&&cornerMaterial !="")
			{
				WallBoardMaterial.instance.searchMaterialByCode(cornerMaterial);
			}
		}
		
		private var _vo:Object;
		
		override public function get vo():Object
		{
			return _vo;
		}
		override public function calcCoordinateByCenter(mainCenter:Point):void
		{
			var ox:Number;
			var oy:Number;
			ox = mainCenter.x + vo.x;
			oy = parentUnit?(parentUnit as BasicWallBoard).vo.offGround+vo.offGround+vo.height : vo.offGround+vo.height;
			this.x = ox - this.width*0.5;
			this.y = mainCenter.y*2-oy;
		}
		override public function addMaterial():void
		{
			var material:L3DMaterialInformations = WallBoardMaterial.instance.getMaterial(realCode) as L3DMaterialInformations;
			if(boardCode != null)
			{
				var material1:L3DMaterialInformations = WallBoardMaterial.instance.getMaterial(boardCode) as L3DMaterialInformations;
			}
//			if(cornerMaterial != null)
//			{
//				var material2:L3DMaterialInformations = WallBoardMaterial.instance.getMaterial(cornerMaterial) as L3DMaterialInformations;
//			}

			if(material!=null)
			{
				var bmd:BitmapData = material.Preview;
				drawMaterial(bmd);
			}
			if(material1!=null)
			{
				var bmd1:BitmapData = material1.Preview;
				drawMaterial1(bmd1,_vo.texRotation);
			}
//			if(material2!=null)
//			{
//				var bmd2:BitmapData = material1.Preview;
//				drawMaterial2(bmd2);
//			}

		}
		
		override public function drawMaterial(bmd:BitmapData,ang:Number =0):void
		{
			thick = vo.lineWidth;
			this.graphics.beginBitmapFill(bmd,null,true,true);
			this.graphics.drawRect(0,0,vo.length,thick);//上
			this.graphics.drawRect(vo.length-thick,thick,thick,vo.height-thick*2);//右
			this.graphics.drawRect(0,vo.height-thick,vo.length,thick);//下
			this.graphics.drawRect(0,thick,thick,vo.height-thick*2);//下
			this.graphics.endFill();
		}
		 public function drawMaterial1(bmd:BitmapData,ang:Number =0):void
		{
			 thick = vo.lineWidth;
			 if(bmd != null)
			 {
				 var  bmd1:BitmapData;
				 if(ang != 0)
				 {
					  bmd1  = ObjectTool.bitmapdataRotate(bmd,ang);					 
				 }else
				 {
					 bmd1 =bmd.clone();
				 }
				 this.graphics.beginBitmapFill(bmd1);
			 }
			 else
				 this.graphics.beginFill(0xDAD6D1);
			 this.graphics.drawRect(thick,thick,vo.length-vo.lineWidth*2, vo.height-vo.lineWidth*2);
			 this.graphics.endFill();
		}
		 public function drawMaterial2(bmd:BitmapData,svgPath:String =""):void
		 {
			 svgPath ="M5.59,162.81l-.47-7.72L9.28,139.5l5.44-13.59-.87-3.59-2.94.88-5,0-4.47-4.44L.16,111.78l1.91-6.25,1.47-1.12L1.22,99.69l0-4.06,4-8.37,4.63-6.56L5.44,70.31l-3-11.59,1.19-5.59L9.47,42.5l-4-11.87L2.56,19.31l4.88-8.62,7.28-2.16,32.81,2.22L60.41,4.53h7.25l9.19,4.81,5.72-1.56,9.38-4.69,4.91,2.09,3.94,5.59,4-7.37L110.09.28h8l6.31,5.22v5.44l-.22,2.16,5.84.56,11.5-4.72L156.94,5H164V6l-3,1.16L140.69,19.56l-12.31,7.81L123,27.16l1.32,6,5.8,4.28,5.16,10.81v4.94L133,61l-4.41,6.16-5.34,4.13-17.59-2.37-5.91-3.47-3-6.22-.34-8.75L83.56,47.91,60.09,54.47l-9.25,9.66L46,80.38,46,86.88l10,1.72L63,91.34,69.84,97l2.72,5.94.78,8.31-1.45,8.92-5.14,9.74-4.87,4.75-3.87,1-13.19-1.47-12.12,1.38-6.62-.72-.75-2.53Z";
				 if(bmd != null && svgPath != "")
				 {
					 var i:int =0;
					 for(i = 0 ; i < 4; i++)
					 {
						 var svgraphic:Graphic = new Graphic();
	//					 this.addChild(svgraphic);
						 var path4:Path = new Path();
						 path4.data = svgPath;
						 path4.width = cornerLength;
						 path4.height =cornerWidth;
						 var bitmapFill4:BitmapFill = new BitmapFill();
						 bitmapFill4.source = bmd.clone();
						 bitmapFill4.fillMode = BitmapFillMode.REPEAT;
						 path4.fill=bitmapFill4;
						 path4.winding = GraphicsPathWinding.EVEN_ODD;
						 svgraphic.addElement(path4);
						 svgraphic.width = cornerLength;
						 svgraphic.height =cornerWidth;
						 svgraphic.validateNow();
						 var svgRotation:Number = 0;
						 switch(i)
						 {
							 case 0:
								 svgRotation =0;
								 svgraphic.x = 0;
								 svgraphic.y = 0;
								 break;
							 case 1:
								 svgRotation =90;
								 svgraphic.x = vo.length;
								 svgraphic.y = 0;
								 break;
							 case 2:
								 svgRotation =180;
								 svgraphic.x = vo.length;
								 svgraphic.y = vo.height;
								 break;
							 case 3:
								 svgRotation =270;
								 svgraphic.x = 0;
								 svgraphic.y = vo.height;
								 break;
						 }
						 svgraphic.scaleX = svgraphic.scaleY = 1;
						 svgraphic.rotation = svgRotation;
//						 var uic:Group = new Group();
//						 uic.width = cornerLength;
//						 uic.height = cornerWidth;
//						 uic.addElement(svgraphic);
//						 PopUpManager.addPopUp(uic,FlexGlobals.topLevelApplication as DisplayObject,false);
//						 var bmdata:BitmapData = new BitmapData(cornerLength,cornerWidth);
//						 bmdata.draw(svgraphic);
//						 var sp:UIComponent = new UIComponent();
//						 sp.width = cornerLength;
//						 sp.height = cornerWidth;
//						 sp.addChild(new Bitmap(bmdata));
//						 PopUpManager.addPopUp(sp,FlexGlobals.topLevelApplication as DisplayObject,false);
//						 this.graphics.beginBitmapFill(bmdata);
//						 this.graphics.drawRect(svgraphic.x,svgraphic.y,bmdata.width,bmdata.height);
					 }
				 }
		 }
		override public function dispose():void
		{
			super.dispose();
			_vo = null;
		}
		
		override public function deserilizeXML(xml:XML):void
		{
			super.deserilizeXML(xml);
			lineType = String(xml.@lineType);
			lineCode = String(xml.@lineCode);
			lineMaterial = String(xml.@lineMaterial);
			lineWidth = Number(xml.@lineWidth);
			lineNum=Number(xml.@lineNum);
			cornerType = String(xml.@cornerType);
			cornerCode = String(xml.@cornerCode);
			cornerMaterial = String(xml.@cornerMaterial);
			cornerLength = Number(xml.@cornerLength);
			cornerWidth = Number(xml.@cornerWidth);
		}
		
		override public function clone():Object
		{
			var bd:WallBoardRectangle = new WallBoardRectangle();
			var bbd:Object = super.clone();
			bd.code = bbd.code
			bd.material = bbd.material
			bd.type = bbd.type;
			bd.L = bbd.L;
			bd.W = bbd.W;
			bd.H = bbd.H;
			bd.offGround = bbd.offGround;
			bd.positionX = bbd.positionX;
			bd.origPoint = bbd.origPoint;
			bd.lineType = this.lineType;
			bd.lineCode = this.lineCode;
			bd.lineMaterial = this.lineMaterial;
			bd.lineWidth = this.lineWidth;
			bd.lineNum=lineNum;
			bd.cornerType = this.cornerType;
			bd.cornerCode = this.cornerCode;
			bd.cornerMaterial = this.cornerMaterial;
			bd.cornerLength = this.cornerLength;
			bd.cornerWidth = this.cornerWidth;
			bd.roundPoints = this.roundPoints;
//			for each(var wbr:WallBoardRectangle in this.paramBoard)
//			{
//				bd.paramBoard.push(wbr.clone() as WallBoardRectangle);
//			}
			return bd;
		}
		/**
		 * 移除相应的嵌板面板 
		 * @param bd
		 * 
		 */
		public function removeBasicBoard(bd:Object):void
		{
			(bd as BasicWallBoard).material ="";
			(bd as BasicWallBoard).L =0;
			(bd as BasicWallBoard).H =0;
		}
		/**
		 * 移除相应的子件 
		 * @param bd
		 * 
		 */
		public function removeBoard(bd:Object):void
		{
			var TBRect:WallBoardRectangle = (bd as WallBoardRectangle);
			for(var i :int = 0; i < paramBoard.length; ++i)
			{
				if(paramBoard[i] == TBRect)
				{
					paramBoard.splice(i, 1);
					return;
				}
			}
		}
		/**
		 * 根据code的类型,获取报价数据 
		 * @param code
		 * @return WallBoardPriceData
		 * 
		 */		
		public function getWallBoardPriceData(code:String):WallBoardPriceData
		{
			var wbpd:WallBoardPriceData;
			if(code && code==lineCode)
			{
				wbpd = new WallBoardPriceData();
				wbpd.type = lineType;
				wbpd.length = L;
				wbpd.width = W;
				wbpd.height = H;
				wbpd.name = cName;
				wbpd.price = price;
				wbpd.previewBuffer = byteArray;
				wbpd.code=lineCode;
				wbpd.material=lineMaterial;
			}
			else if(code && code==cornerCode)
			{
				wbpd = new WallBoardPriceData();
				wbpd.type = cornerType;
				wbpd.length = L;
				wbpd.width = W;
				wbpd.height = H;
				wbpd.name = cName;
				wbpd.price = price;
				wbpd.previewBuffer = byteArray;
				wbpd.code=cornerCode;
				wbpd.material=cornerMaterial;
			}
			
			return wbpd;
		}
		override public function get wallBoardPriceData():WallBoardPriceData
		{
			var wbpd:WallBoardPriceData;
			if(material)
			{
				wbpd = new WallBoardPriceData();
				wbpd.type = type;
				wbpd.length = L;
				wbpd.width = W;
				wbpd.height = H;
				wbpd.name = cName;
				wbpd.price = price;
				wbpd.previewBuffer = byteArray;
				wbpd.size = size;
				wbpd.code=code;
				wbpd.material=material;
			}
			return wbpd;
		}
		
	}
}
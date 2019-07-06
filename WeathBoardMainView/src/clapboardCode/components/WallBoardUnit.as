package clapboardCode.components
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	import mx.graphics.ImageSnapshot;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	
	import L3DLibrary.L3DMaterialInformations;
	
	import clapboardCode.models.WallBoardMaterial;
	
	import wallDecorationModule.model.vo.CClapboardUnitVO;

	public class WallBoardUnit extends BasicWallBoard
	{
		public function WallBoardUnit()
		{
			super();

		}
		
		public var paramBoardRectangle:Vector.<WallBoardRectangle> = new Vector.<WallBoardRectangle>();
		public var paramBoardLine:Vector.<WallBoardLine> = new Vector.<WallBoardLine>();
		public var isNeedToScale:Boolean = false;
		public var areaUnitIndex:int =0;//所属区域id
		public var tempWall:int =-1;//所属区域id
		public var tempArea:int =-1;//所属区域id
		public var uniqueID:String ="";//用来判断单元件的标识。
		public var tempPoint:Vector3D = new Vector3D();//3d中返回来时临时存放的初始点。
		public var tempLength:Number = -1;//从3d中返回来时的长度
		public var tempHeight:Number = -1;//从3d中返回来时的长度
		private var _count:int = 1;
		public var TilingMode:int =-1;
		public var TilingPoint:Array =[];
		public var scX:Number  =1;
		public var originObj:Object;
		public var scY:Number =1;
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		override public function setXMLData(xml:XML):void
		{
			super.setXMLData(xml);
			if(String(xml.name())=="CClapboardUnitVO")
				var classDict:Class=CClapboardUnitVO;
			_vo = new classDict(getQualifiedClassName(CClapboardUnitVO));
			_vo.deserialize(xml);
			offGround = vo.offGround;
			this.graphics.beginFill(0x00ffff,0.01);
			this.graphics.drawRect(0,0,vo.length,vo.height);
			this.graphics.endFill();
		}
		
		override public function searchMaterial():void
		{
			WallBoardMaterial.instance.searchMaterialByCode(_vo.material);
		}
		
		private var _vo:Object;
		override public function get vo():Object
		{
			return _vo;
		}
		
		private var center:Point;
		public function addSubElement(element:BasicWallBoard):void
		{
			if(center==null)
				center = this.getCenterPointRelative();
			if(element.parentUnit !=null&&element.parentUnit.hasOwnProperty("paramBasicBoard"))
			{
				element.calcCoordinateByCenter(center);
			}	
			element.calcCoordinateByCenter(center);
			this.addChild(element);
		}
		
		override public function addMaterial():void
		{
			var code:String = vo.material;
			var material:L3DMaterialInformations = WallBoardMaterial.instance.getMaterial(code) as L3DMaterialInformations;
			if(material==null){
				return;
			}
			this.uvPoints.length = 0;
			var temparr:Array=material.spec.split("X");
			this.uvPoints.push(new Vector3D(0,0),new Vector3D(0,temparr[1]),new Vector3D(temparr[0],temparr[1]),new Vector3D(temparr[0],0));
			var bmd:BitmapData = material.Preview.clone();
			drawMaterial(bmd,_vo.texRotation);
			
			var element:BasicWallBoard;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				element = this.getChildAt(i) as BasicWallBoard;
				element.addMaterial();
			}
		}
		
		public function getBitmapData():BitmapData
		{
			var bmd:BitmapData = new BitmapData(this.width,this.height);
//			var bmd:BitmapData =ImageSnapshot.captureBitmapData(this);
			bmd.draw(this);
			return bmd;
		}
		
		override public function dispose():void
		{
			super.dispose();
			var element:BasicWallBoard;
			while(this.numChildren>0){
				element = this.removeChildAt(0) as BasicWallBoard;
				element.dispose();
				element = null;
			}
		}
		private function copyArray(arr:Array):Array 
		{
			var arr1:Array = new Array;
			for(var i:int =0;i<arr.length;i++)
			{
				var p:Vector3D =arr[i] as Vector3D;
				arr1.push(p.clone());
			}
			return arr1;
		}

		/**
		 * 移除相应的子件 
		 * @param bd
		 * 
		 */
		public function removeBoard(bd:Object):void
		{
			var TBRect:WallBoardRectangle = (bd as WallBoardRectangle);
			var i :int;
			for(i  = 0; i < paramBoardRectangle.length; ++i)
			{
				if(paramBoardRectangle[i] == TBRect)
				{
					paramBoardRectangle.splice(i, 1);
					return;
				}
			}
			var TBLine:WallBoardLine = (bd as WallBoardLine);
			for(i = 0; i < paramBoardLine.length; ++i)
			{
				if(paramBoardLine[i] == TBLine)
				{
					paramBoardLine.splice(i, 1);
					return;
				}
			}
		}
		override public function clone():Object
		{
			var bd:WallBoardUnit = new WallBoardUnit();
			var bbd:Object = super.clone();
			bd.code = bbd.code;
			bd.areaUnitIndex = this.areaUnitIndex;
			bd.material = bbd.material
			bd.type = bbd.type;
			bd.L = bbd.L;
			bd.W = bbd.W;
			bd.TilingMode = this.TilingMode;
			bd.TilingPoint =copyArray(this.TilingPoint);
			bd.scX =this.scX;
			bd.scY =this.scY;
			bd.texRotation =bbd.texRotation;
//			for each(var wbl:WallBoardLine in this.paramBoardLine)
//			{
//				 bd.paramBoardLine.push(wbl.clone() as WallBoardLine);
//			}
//			for each(var wbr:WallBoardRectangle in this.paramBoardRectangle)
//			{
//				bd.paramBoardRectangle.push(wbr.clone() as WallBoardRectangle);
//			}			
			bd.H = bbd.H;
			bd.offGround = bbd.offGround;
			bd.positionX = bbd.positionX;
			bd.origPoint = bbd.origPoint;
			return bd;
		}
	}
}
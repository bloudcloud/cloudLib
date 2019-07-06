package clapboardCode.components
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import L3DLibrary.L3DMaterialInformations;
	
	import clapboardCode.models.WallBoardMaterial;

	public class WallBoardLine extends BasicWallBoard
	{
		private var realCode:String;
		//顶线、腰线、地脚线
		public function WallBoardLine()
		{
			super();
		}
		
		override public function setXMLData(xml:XML):void
		{
			super.setXMLData(xml);
			if(String(xml.name())=="CClapboardLineVO")
				var classDict:Class =WlapboardLineVO;
			_vo = new classDict(getQualifiedClassName(WlapboardLineVO));
			_vo.deserialize(xml);
			
//			var arg:Array = String(_vo.code).split("_");
			realCode = String(_vo.material);
			
			this.graphics.beginFill(0x00ff00,0.01);
			this.graphics.drawRect(0,0,vo.length,vo.height);
			this.graphics.endFill();
		}
		
		override public function searchMaterial():void
		{
			WallBoardMaterial.instance.searchMaterialByCode(realCode);
		}
		
		/**
		 * 线是按照最靠下的中点算
		 */
		override public function calcCoordinateByCenter(mainCenter:Point):void
		{
			var ox:Number = mainCenter.x + vo.x;
			var oy:Number ;
			if(vo.positionY &&vo.positionY !=0)
			{
				oy = vo.positionY +vo.height;						
			}else
			{
				oy = vo.offGround +vo.height;						
			}
			this.x = ox - this.width*0.5;
			this.y = mainCenter.y*2-oy;
		}
		
		private var _vo:Object;
		
		override public function get vo():Object
		{
			return _vo;
		}
		
		override public function addMaterial():void
		{
			var material:L3DMaterialInformations = WallBoardMaterial.instance.getMaterial(realCode) as L3DMaterialInformations;
			if(!material){
				searchMaterialByCode(realCode);
			}else{
				var bmd:BitmapData = material.Preview;
				drawMaterial(bmd);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_vo = null;
		}
	}
}
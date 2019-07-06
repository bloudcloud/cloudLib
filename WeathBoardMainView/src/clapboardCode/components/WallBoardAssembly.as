package clapboardCode.components
{
	import clapboardCode.models.WallBoardMaterial;
	
	import utils.DatasEvent;
	

	public class WallBoardAssembly
	{
		private var materialNum:int;
		
		public var wallBoardUnit:WallBoardUnit;
		public var readyToStageFunc:Function;
		
		public function WallBoardAssembly()
		{
		}
		
		/**
		 * 添加单元体XML
		 */
		public function parseUnitXML(xml:XML):void
		{
			if(xml==null){
				return;
			}
			
			reset();
			
			dispose();
			
			WallBoardMaterial.instance.addEventListener(WallBoardMaterial.LoadMaterialComplete,loadUnitCompleteHandler);
		}
		
		private function loadUnitCompleteHandler(event:DatasEvent):void
		{
			reset();
			
			//单元体添加材质
			wallBoardUnit.addMaterial();
		}
		private function doCreatePart(xml:XML,arg:Array,parentPart:Object=null):void
		{
			var xmlList:XMLList=xml.children();
			var len:int=xmlList.length();
			var name:String;
			materialNum+=len;
			for(var i:int=0;i<len;i++)
			{
				xml=xmlList[i] as XML;
				name=String(xml.name());
				if(name == "CClapboardUnitVO")
				{
					//再加上主板的计数
					wallBoardUnit = new WallBoardUnit();
					wallBoardUnit.setXMLData(xml);
					wallBoardUnit.parentUnit=parentPart;
					doCreatePart(xml,arg,wallBoardUnit);
				}
				else if(name == "CClapboardLineVO"){
					var wallBoardLine:WallBoardLine = new WallBoardLine();
					wallBoardLine.setXMLData(xml);
					wallBoardLine.parentUnit=parentPart;
					arg.push(wallBoardLine);
				}else if(name == "CClapboardRectangleVO"){
					var wallBoardRectangle:WallBoardRectangle = new WallBoardRectangle();
					wallBoardRectangle.setXMLData(xml);
					wallBoardRectangle.parentUnit=parentPart;
					if(xml.@material !="")
					{
						materialNum++;
					}
					arg.push(wallBoardRectangle);
					for each(var childxml:XML in xml.CClapboardRectangleVO)
					{
						materialNum++;
						var wallBoardRectangle1:WallBoardRectangle = new WallBoardRectangle();
						wallBoardRectangle1.setXMLData(childxml);
						wallBoardRectangle1.parentUnit=wallBoardRectangle;
						if(childxml.@material !="")
						{
							materialNum++;
						}
						arg.push(wallBoardRectangle1);
					}
				}
			}
		}
		public function parseXML(xml:XML,wall:int =-1,area:int =-1,points:Array =null,mode:int =0,boardLen:Number =1,originData:Object =null):void
		{
 			if(xml==null)
			{
				return;
			}
			
			reset();
			
			dispose();
			
			WallBoardMaterial.instance.addEventListener(WallBoardMaterial.LoadMaterialComplete,loadCompleteHandler);
			//先算出列表的长度
			var arg:Array=[];
			doCreatePart(xml,arg);
			if(wall >=0)
			{
				wallBoardUnit.tempWall = wall;
				wallBoardUnit.tempArea = area;
				wallBoardUnit.tempPoint = points[3];
				wallBoardUnit.originObj = originData;
				wallBoardUnit.tempHeight = Math.abs(points[1].y - points[2].y);
				if(mode !=2)
				{
					wallBoardUnit.tempLength = Math.abs(points[0].x-points[1].x);
				}else
				{
					var tempLen:Number = Math.abs(points[0].x-points[1].x);
					var tempCount:int =Math.floor(tempLen/boardLen);
					wallBoardUnit.tempLength = tempCount*boardLen;
				}
					
			}
			//添加子件进单元体
			for (var j:int = 0; j < arg.length; j++) 
			{
				wallBoardUnit.addSubElement(arg[j]);
			}
			//添加材质
			wallBoardUnit.searchMaterial();
			for (var k:int = 0; k < arg.length; k++) 
			{
				(arg[k] as BasicWallBoard).searchMaterial();
			}
		}
		
		private var count:int;
		private function loadCompleteHandler(event:DatasEvent):void
		{
			count++;
//			print(count);
			if(count==materialNum){
				
				reset();
				
				//单元体添加材质
				wallBoardUnit.addMaterial();
				
				if(readyToStageFunc!=null)
				{
					readyToStageFunc(wallBoardUnit);
				}
				return;
			}
		}
		
		private function reset():void
		{
			WallBoardMaterial.instance.removeEventListener(WallBoardMaterial.LoadMaterialComplete,loadCompleteHandler);
			WallBoardMaterial.instance.removeEventListener(WallBoardMaterial.LoadMaterialComplete,loadUnitCompleteHandler);
			materialNum = 0;
			count=0;
		}
		
		private function dispose():void
		{
			if(wallBoardUnit!=null)
			{
				wallBoardUnit.dispose();
				wallBoardUnit = null;
			}
		}
	}
}
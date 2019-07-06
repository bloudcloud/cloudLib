package clapboardCode.components
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import clapboardCode.models.WallBoardPartType;
	
	import clapboardCode.sdObject.BoardComp;

	public class WallBoardCalculate
	{
		private var assembly:WallBoardAssembly = new WallBoardAssembly();

		public function WallBoardCalculate()
		{
		}
		//根据上下位置删除方案的顶线跟腰线
		public function DelUnitByPosition(point:Vector3D,unit:WallBoardUnit):WallBoardUnit
		{
			var i:int =0;
			var wbl:WallBoardLine;
			if(point.y ==0)
			{
				for ( i =0;i<unit.paramBoardLine.length;i++)
				{
					wbl = unit.paramBoardLine[i];
					if(wbl.type == WallBoardPartType.BOTTOMLINE_BOARD||wbl.type ==WallBoardPartType.BELTLINE_BOARD)
					{
						unit.paramBoardLine.splice(i,1);
						i=-1;
					}
					if(wbl.type == WallBoardPartType.TOPLINE_BOARD)
					{
						wbl.positionY = wbl.origPoint.y;
					}
				}
				unit.paramBoardRectangle = null;
			}else
			{
				for ( i =0;i<unit.paramBoardLine.length;i++)
				{ 
					wbl = unit.paramBoardLine[i];
					if(wbl.type == WallBoardPartType.TOPLINE_BOARD||wbl.type ==WallBoardPartType.BELTLINE_BOARD)
					{
						unit.paramBoardLine.splice(i,1);
						i=-1;
					}
				}
				unit.paramBoardRectangle = null;
			}
			return unit;
		}
		//改变主面板的时候同步其他部件的大小
		public function setAllBoardPosition(unit:WallBoardUnit,dx:Number,dy:Number):WallBoardUnit
		{
			for each (var wbl:WallBoardLine in unit.paramBoardLine)
			{
				wbl.L = unit.L;
				if(wbl.type ==WallBoardPartType.TOPLINE_BOARD)
				{
					wbl.setOrigPoint(new Point(unit.origPoint.x,(wbl.origPoint.y+wbl.H)*dy-wbl.H));				
				}else
				{
					wbl.setOrigPoint(new Point(unit.origPoint.x,wbl.origPoint.y*dy));								

				}
			}
			for each (var wbr:WallBoardRectangle in unit.paramBoardRectangle)
			{
				setRectBoardPosition(wbr,dx,dy)	;		
			}
			return unit;
		}
		public function setAllRectBoard(wbr:WallBoardRectangle):void
		{
			if(wbr.paramBasicBoard&&wbr.paramBasicBoard.material !="")
			{
				wbr.paramBasicBoard.L = wbr.L-wbr.lineWidth*2;
				wbr.paramBasicBoard.H =wbr.H-wbr.lineWidth*2;
				wbr.paramBasicBoard.setOrigPoint(new Point(wbr.origPoint.x,wbr.origPoint.y+wbr.lineWidth));
			}
		}
		private function setRectBoardPosition(wbr:WallBoardRectangle,dx:Number,dy:Number):void
		{
			wbr.L = wbr.L*dx;
			wbr.H = wbr.H*dy;
			wbr.setOrigPoint(new Point(wbr.origPoint.x*dx,wbr.origPoint.y*dy));				
			if(wbr.paramBasicBoard!=null &&wbr.paramBasicBoard.material!="")
			{
				var pbb:BasicWallBoard = wbr.paramBasicBoard;
				pbb.L =  (pbb.L+wbr.lineWidth*2)*dx-wbr.lineWidth*2;//pbb.L*dx;
				pbb.H = (pbb.H+wbr.lineWidth*2)*dy-wbr.lineWidth*2;
				pbb.setOrigPoint(new Point(pbb.origPoint.x*dx,wbr.origPoint.y+wbr.lineWidth));
			}
			if(wbr.paramCornerBoard &&wbr.paramCornerBoard.length > 0)
			{
				for each(var pcb:BasicWallBoard in wbr.paramCornerBoard)
				{
					var fixX:Number =(pcb.L)*(dx-1);
					var fixY:Number = pcb.H*(dy-1);
					switch(pcb.cornerRotation)
					{
						case 0:
							pcb.setOrigPoint(new Point(pcb.origPoint.x*dx-fixX,pcb.origPoint.y*dy+fixY));
							break;
						case 90:
							pcb.setOrigPoint(new Point(pcb.origPoint.x*dx+fixX,pcb.origPoint.y*dy+fixY));
							break;
						case 180:
							pcb.setOrigPoint(new Point(pcb.origPoint.x*dx+fixX,pcb.origPoint.y*dy-fixY));
							break;
						case -90:
							pcb.setOrigPoint(new Point(pcb.origPoint.x*dx-fixX,pcb.origPoint.y*dy-fixY));
							break;
					}
				}
			}
			for each(var wbr1:WallBoardRectangle in wbr.paramBoard)	
			{
				setRectBoardPosition(wbr1,dx,dy);
			}
		}
		/**
		 * 解析所有护墙板的墙面区域计划数据,封装成UNIT数据集合
		 * @param regionDatas 墙面区域计划数据集合
		 * @return Vector.<Vector.<Object>> unit数据集合
		 * 
		 */		
		public function deserilizeAndSetUNIT(regionDatas:Array):Vector.<Vector.<Object>>
		{
			var _unit:Vector.<Vector.<Object>> = new Vector.<Vector.<Object>>;
			_unit.length =19;
			for(var i:int =0;i<regionDatas.length;i++)
			{
				if(regionDatas[i] ==null) continue;
				var a:Array = regionDatas[i];
				for(var j:int = 0;j<a.length;j++)
				{
					if (a[j] ==null) continue;
					var obj:Object = a[j] as Object;
					var unit:WallBoardUnit = new WallBoardUnit();
					var p:Point =new Point();
					p.x =obj.points[3].x;
					p.y = obj.points[3].y;
					unit = deserilizeXMLData(obj.xml,j,p);			
					unit.setOrigPoint(new Point(unit.L/2,unit.origPoint.y));
					unit.areaUnitIndex = j;
					unit.TilingMode =obj.mode;
					unit.scX =obj.scaleX;
					unit.scY =obj.scaleY;
					unit.TilingPoint =copyArray(obj.points);

					unit.uniqueID =i+"_"+j+"_"+"0";
					if(_unit[i] != null)
						_unit[i].push(unit);
					else
					{
						var tempU:Vector.<Object> = new Vector.<Object>;
						tempU.push(unit);
						_unit[i] =tempU;
					}
				}
			}
			return _unit;
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
		//生成3D需要用到的object
		public function create3DObject(xml:XML,point:Array,type:int,scx:Number,scy:Number):Object
		{
			var obj:Object = new Object();
			obj["mode"] = type;
			obj["points"] = point;
			obj["xml"] = xml;
			obj["scaleX"] = scx;
			obj["scaleY"] = scy;		
			return obj;
		}
		/*对比xml找出相应的区域跟墙*/
		public function  ongetWallAndAreaByXML(xml:XML,arr:Array):Object
		{
			for(var i:int =0;i<arr.length;i++)
			{
				if(arr[i]==null)continue;
				if(arr[i].xml == xml)
				{
					var obj:Object = new Object();
					obj["area"]= arr[i].areaIndex;
					obj["wallid"] = arr[i].wallIndex;
					arr.splice(i,1);
					return obj;
				}
			}
			return null;
		}
		public function findBoardCompByUnit(BC:Vector.<BoardComp>,unit:WallBoardUnit):BoardComp
		{
			for each(var obj:BoardComp in BC)
			{
				if(unit ==obj.board)
				{
					return obj;
				}
			}
			return null;
		}
		
		public function findUnitFromAllUnit(Index:int,unit:Vector.<Object>):Object
		{
			for (var i:int =0;i<unit.length;i++)
			{
				if((unit[i] as WallBoardUnit).areaUnitIndex == Index)
				{
					var obj:Object = new Object;
					obj["wbu"] = unit[i] as WallBoardUnit;
					obj["index"] = i;
					return obj;
				}
			}
			return null;
		}
		/*根据数据解析成xml*/
		public function onGetXMLData(unit:Object):XML
		{
			var rootXML:XML;
			var arr:Array = [];
			var childXML:XML;
			var tmpXML:XML;
			//根据object 生成xml
			if(unit.material!="")
			{
				rootXML=new XML(<root></root>);
				childXML=new XML(<CClapboardUnitVO type={unit.type} length={unit.L} height={unit.H} material={unit.material} isMaterialTask="true" texRotation={unit.texRotation} leftSpacing={unit.positionX} offGround = {unit.offGround}> </CClapboardUnitVO>);
				rootXML.appendChild(childXML);
			}else
			{
				return null;
			}
			
			if(unit.paramBoardRectangle&&unit.paramBoardRectangle.length > 0)
			{
				for each(var pbr:WallBoardRectangle in unit.paramBoardRectangle)
				{
					tmpXML =new XML(<CClapboardRectangleVO  type={pbr.type} lineClassName={"CClapboardLineVO"} lineType={pbr.lineType} lineNum={pbr.lineNum} code={pbr.code} material={(pbr.paramBasicBoard)?pbr.paramBasicBoard.material:pbr.material} lineCode={pbr.lineCode} lineMaterial={pbr.lineMaterial} cornerClassName={"CClapboardRectangleCornerVO"} cornerType ={getCornerBoardData(pbr).cornerType}  cornerCode={getCornerBoardData(pbr).cornerCode} texRotation={(pbr.paramBasicBoard)?pbr.paramBasicBoard.texRotation:pbr.texRotation} cornerMaterial ={getCornerBoardData(pbr).cornerMaterial}  cornerLength= {getCornerBoardData(pbr).cornerLength} cornerWidth={getCornerBoardData(pbr).cornerWidth}  lineWidth={pbr.lineWidth} length ={pbr.L} height ={pbr.H} x={pbr.positionX} offGround={pbr.offGround - unit.offGround}></CClapboardRectangleVO>);
//					tmpXML =new XML(<CClapboardRectangleVO  type={pbr.type} lineClassName={"CClapboardLineVO"} lineType={pbr.lineType} lineNum={pbr.lineNum} code={pbr.code} material={(pbr.paramBasicBoard)?pbr.paramBasicBoard.material:pbr.material} lineCode={pbr.lineCode} lineMaterial={pbr.lineMaterial} cornerClassName={"CClapboardRectangleCornerVO"} cornerType ={pbr.cornerType} cornerCode={pbr.cornerCode} texRotation={(pbr.paramBasicBoard)?pbr.paramBasicBoard.texRotation:pbr.texRotation} cornerMaterial ={pbr.cornerMaterial} cornerLength={pbr.cornerLength} cornerWidth={pbr.cornerWidth}  lineWidth={pbr.lineWidth} length ={pbr.L} height ={pbr.H} x={pbr.positionX} offGround={pbr.offGround}></CClapboardRectangleVO>);
					
					for each (var pbr1:WallBoardRectangle in pbr.paramBoard)
					{
						tmpXML.appendChild(new XML(<CClapboardRectangleVO  type={pbr1.type} lineClassName={"CClapboardLineVO"} lineType={pbr1.lineType} lineNum={pbr.lineNum} code={pbr1.code} material={(pbr1.paramBasicBoard)?pbr1.paramBasicBoard.material:pbr1.material} lineCode={pbr1.lineCode} cornerClassName={"CClapboardRectangleCornerVO"} cornerType ={getCornerBoardData(pbr1).cornerType} cornerCode={getCornerBoardData(pbr1).cornerCode}cornerMaterial ={getCornerBoardData(pbr1).cornerMaterial} cornerLength={getCornerBoardData(pbr1).cornerLength} cornerWidth={getCornerBoardData(pbr1).cornerWidth} texRotation={(pbr1.paramBasicBoard)?pbr1.paramBasicBoard.texRotation:pbr1.texRotation} lineMaterial={pbr1.lineMaterial} lineWidth={pbr1.lineWidth} length ={pbr1.L} height ={pbr1.H} x={pbr1.positionX} offGround={pbr1.offGround-pbr.offGround - unit.offGround}/>));
					}
					childXML.appendChild(tmpXML);				
				}	
			}
			if(unit.paramBoardLine&&unit.paramBoardLine.length > 0)
			{			
				for each(var pbl:WallBoardLine in unit.paramBoardLine)
				{
					if(pbl.type ==WallBoardPartType.TOPLINE_BOARD&&pbl.positionY !=0)
					{
						//在门窗的上面的护墙板的顶线需要特殊处理下。
						tmpXML =new XML(<CClapboardLineVO type={pbl.type} length={pbl.L} height={pbl.H} x={pbl.positionX} positionY={pbl.offGround} offGround={pbl.offGround - unit.offGround} code={pbl.code} material={pbl.material}/>)
						childXML.appendChild(tmpXML);						

					}else
					{
						tmpXML =new XML(<CClapboardLineVO type={pbl.type} length={pbl.L} height={pbl.H} x={pbl.positionX} offGround={pbl.offGround - unit.offGround} code={pbl.code} material={pbl.material}/>)
						childXML.appendChild(tmpXML);						
					}
				}
			}
			return rootXML;
		}
		
		
		private function getCornerBoardData(pbr:WallBoardRectangle):WallBoardRectangle
		{
			var obj:Object = {};
			var wbr:WallBoardRectangle = new WallBoardRectangle();
			if( (!pbr || pbr.paramCornerBoard.length == 0))
				return wbr;
			if( pbr.paramCornerBoard.length > 0 )
			{
				wbr.cornerType = pbr.paramCornerBoard[0].type;
				wbr.cornerCode = pbr.paramCornerBoard[0].code;
				wbr.cornerMaterial = pbr.paramCornerBoard[0].material;
				wbr.cornerLength = pbr.paramCornerBoard[0].L;
				wbr.cornerWidth = pbr.paramCornerBoard[0].H;
			}
			return wbr;
			
		}

		//解析xml，index为当前区域id
		public function deserilizeXMLData(xml:XML,index:int,point:Point =null):WallBoardUnit
		{
			var unit:WallBoardUnit;
			if(!point) point = new Point();
			
			var xmlList:XMLList=xml.children();
			var len:int=xmlList.length();
			var childXML:XML;
			for(var i:int=0; i<len; i++)
			{
				childXML=xmlList[i];
				if(childXML.name()=="CClapboardUnitVO")
				{
					unit = new WallBoardUnit();
					unit.areaUnitIndex=index;
					unit.deserilizeXML(childXML);
					var childList:XMLList=childXML.children();
					var childLen:int=childList.length();
					for(var j:int=0; j<childLen; j++)
					{
						doDeserilizeXMLData(childList[j],unit);
					}
				}
				else
				{
					doDeserilizeXMLData(childXML,unit);
				}
			}
			return unit;
		}
		private function doDeserilizeXMLData(xml:XML,unit:WallBoardUnit):void
		{
			var pBasic:BasicWallBoard;
			var cornerBasic:BasicWallBoard;
			var i:int = 0 ;
			if(String(xml.name()) == "CClapboardLineVO"){
				var wallBoardLine:WallBoardLine = new WallBoardLine();
				wallBoardLine.deserilizeXML(xml);
				unit.paramBoardLine.push(wallBoardLine);
			}else if(String(xml.name()) == "CClapboardRectangleVO"){
				var wallBoardRectangle:WallBoardRectangle = new WallBoardRectangle();
				wallBoardRectangle.deserilizeXML(xml);
				//	wallBoardRectangle.setTranslation(point);
				if(wallBoardRectangle.material !="")
				{
					pBasic = new BasicWallBoard();
					pBasic.material = wallBoardRectangle.material;
					pBasic.L = wallBoardRectangle.L-wallBoardRectangle.lineWidth*2;
					pBasic.H = wallBoardRectangle.H-wallBoardRectangle.lineWidth*2;
					pBasic.parentUnit = wallBoardRectangle;
					pBasic.type = WallBoardPartType.UNIT_BOARD;
					//pBasic.setTranslation(new Point(pBasic.L/2,wallBoardRectangle.offGround));
					pBasic.texRotation = wallBoardRectangle.texRotation;
					wallBoardRectangle.paramBasicBoard = pBasic;
				}
				if(wallBoardRectangle.cornerMaterial !="")
				{
					for( i = 0 ; i < 4 ; i ++ )
					{
						cornerBasic = new BasicWallBoard();
						cornerBasic.type = WallBoardPartType.FLOWER_BOARD;
						cornerBasic.code = wallBoardRectangle.cornerCode;
						cornerBasic.material = wallBoardRectangle.cornerMaterial;
						cornerBasic.H = wallBoardRectangle.cornerWidth;
						cornerBasic.L = wallBoardRectangle.cornerLength;
						if( i == 2 )
							cornerBasic.cornerRotation = -90;
						else if( i == 3 )
							cornerBasic.cornerRotation = 180;
						else
							cornerBasic.cornerRotation = i*90;
						cornerBasic.material = wallBoardRectangle.cornerMaterial;
						wallBoardRectangle.paramCornerBoard.push(cornerBasic);
					}
					
				}
				
				for each(var childxml:XML in xml.CClapboardRectangleVO)
				{
					var wallBoardRectangle1:WallBoardRectangle = new WallBoardRectangle();
					wallBoardRectangle1.deserilizeXML(childxml);
					//wallBoardRectangle1.setTranslation(new Point(wallBoardRectangle1.L/2,wallBoardRectangle1.offGround));
					
					wallBoardRectangle1.parentUnit = wallBoardRectangle;
					wallBoardRectangle.paramBoard.push(wallBoardRectangle1);
					if(wallBoardRectangle1.material !="")
					{
						pBasic = new BasicWallBoard();
						pBasic.material = wallBoardRectangle1.material;
						pBasic.L = wallBoardRectangle1.L-wallBoardRectangle1.lineWidth*2;
						pBasic.H = wallBoardRectangle1.H-wallBoardRectangle1.lineWidth*2;
						pBasic.parentUnit = wallBoardRectangle1;
						pBasic.type = WallBoardPartType.UNIT_BOARD;
						//	pBasic.setTranslation(new Point(pBasic.L/2,wallBoardRectangle1.offGround));
						pBasic.texRotation = wallBoardRectangle1.texRotation;

						wallBoardRectangle1.paramBasicBoard = pBasic;
					}
					if(wallBoardRectangle1.cornerMaterial !="")
					{
						for( i = 0 ; i < 4 ; i ++ )
						{
							cornerBasic = new BasicWallBoard();
							cornerBasic.code = wallBoardRectangle1.cornerCode;
							cornerBasic.type = WallBoardPartType.FLOWER_BOARD;
							cornerBasic.L = wallBoardRectangle1.cornerLength;
							if( i == 2 )
								cornerBasic.cornerRotation = -90;
							else if( i == 3 )
								cornerBasic.cornerRotation = 180;
							else
								cornerBasic.cornerRotation = i*90;
							cornerBasic.H = wallBoardRectangle1.cornerWidth;
							cornerBasic.material = wallBoardRectangle1.cornerMaterial;
							wallBoardRectangle1.paramCornerBoard.push(cornerBasic);
						}
					}
				}
				unit.paramBoardRectangle.push(wallBoardRectangle);
			}
		}
	}
}
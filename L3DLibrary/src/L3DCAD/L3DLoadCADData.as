package L3DCAD
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import L3DLibrary.L3DLibraryWebService;
	import L3DLibrary.LivelyLibrary;
	
	import extension.lrj.dict.UIConstDict;
	
	import utils.DatasEvent;
	import utils.LJAlert;
	import utils.lx.managers.GlobalManager;

	public class L3DLoadCADData extends EventDispatcher
	{
	//	private var webService:WebService = new WebService();
		private var enabled:Boolean = false;
		private var ratio:Number = 10;
		private var edgeSpace:Number = 30;
		private var processingForm:L3DProgressForm = new L3DProgressForm();
		private var processingTimer:Timer = new Timer(100, 0);	
		private var parent:Object = null;
		public static const OnLoadMosaicComplete:String = "OnLoadMosaicComplete";
		
		public function L3DLoadCADData()
		{
			processingTimer.addEventListener(TimerEvent.TIMER, processingTimerHandler);
			super();
		}		
		
		public function get Enabled():Boolean
		{
			return L3DLibrary.L3DLibraryWebService.WebServiceEnable;
		}
		
		public function LoadJPGXMLBuffer(buffer:ByteArray, t_Binary:int, t_Dilate:int, t_MorphOpen:int, t_Gaussian:int, t_Canny:int, t_Hough:int, t_Gap:Number, t_Scale:Number, parent:Object, previewMode:Boolean):void
		{
			if(!Enabled || buffer == null || buffer.length == 0 || parent == null)
			{
				LivelyLibrary.ShowMessage("服务未启动或JPG文件为空或JPG文件存在错误", 2);
				return;
			}
			if(buffer.length > 10485760)
			{
				Alert.show("JPG文件不可大于10M");
				return;
			}
			this.parent = parent;
			var ft:ByteArray = new ByteArray();
			ft.writeInt(t_Binary);
			ft.writeInt(t_Dilate);
			ft.writeInt(t_MorphOpen);
			ft.writeInt(t_Gaussian);
			ft.writeInt(t_Canny);
			ft.writeInt(t_Hough);
			ft.writeFloat(t_Gap);
			ft.writeFloat(t_Scale);
			this.parent = parent;
			processingForm.horizontalCenter = 0;
			processingForm.verticalCenter = 0;
			parent.addElement(processingForm);
			processingForm.Percent = 0;	
			processingTimer.start();
			if(previewMode)
			{
//				var atObj:AsyncToken = L3DLibrary.L3DLibraryWebService.LibraryService.PreviewJPG(buffer, ft);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(PreviewResult, LoadFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/7 
				GlobalManager.Instance.serviceMGR.previewJPG(PreviewResult, LoadFault, buffer, ft);
			}
			else
			{
//				var atObj:AsyncToken = L3DLibrary.L3DLibraryWebService.LibraryService.ImportJPG(buffer, ft);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadResult, LoadFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/7 
				GlobalManager.Instance.serviceMGR.importJPG(LoadResult, LoadFault, buffer, ft);
			}
		}		
	
		public function LoadCADXMLBuffer(buffer:ByteArray, dxfMode:Boolean, parent:Object):void
		{
			if(!Enabled || buffer == null || buffer.length == 0 || parent == null)
			{
				LivelyLibrary.ShowMessage("服务未启动或CAD文件为空或CAD文件存在错误", 1);
				return;
			}
			if(buffer.length > 5242880)
			{
				LivelyLibrary.ShowMessage("CAD文件不可大于5M", 1);
				return;
			}
			this.parent = parent;
			processingForm.horizontalCenter = 0;
			processingForm.verticalCenter = 0;
			parent.addElement(processingForm);
			processingForm.Percent = 0;
			processingTimer.start();
			var atObj:AsyncToken = dxfMode ? L3DLibrary.L3DLibraryWebService.LibraryService.LoadRoomDXF(buffer) : L3DLibrary.L3DLibraryWebService.LibraryService.LoadRoom(buffer);
			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadResult, LoadFault);
			atObj.addResponder(rpObj);
		}
		
		public function LoadMosaicXMLBuffer(buffer:ByteArray, dxfMode:Boolean, parent:Object):void
		{
			if(!Enabled || buffer == null || buffer.length == 0 || parent == null)
			{
				LivelyLibrary.ShowMessage("服务未启动或CAD文件为空或CAD文件存在错误", 1);
				return;
			}
			if(buffer.length > 10485760)
			{
				LivelyLibrary.ShowMessage("CAD文件不可大于10M", 1);
				return;
			}
			this.parent = parent;
			processingForm.horizontalCenter = 0;
			processingForm.verticalCenter = 0;
			parent.addElement(processingForm);
			processingForm.Percent = 0;	
			processingTimer.start();
//			var atObj:AsyncToken = L3DLibrary.L3DLibraryWebService.LibraryService.ImportMosaicCAD(buffer, dxfMode);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadMosaicResult, LoadMosaicFault);
//			atObj.addResponder(rpObj);

//			lrj 2017/12/7 
			GlobalManager.Instance.serviceMGR.importMosaicCAD(LoadMosaicResult,LoadMosaicFault, buffer, dxfMode);
			
		}
		
		private function processingTimerHandler(event:TimerEvent):void
		{
			processingForm.ShowPercent();
		}
		
		private function PreviewResult(reObj:ResultEvent):void
		{
			var xml:XML = new XML(reObj.result);
			PreviewRoomInformation(xml);
		}
		
		private function LoadResult(reObj:ResultEvent):void
		{
			//lx
			if(reObj.result!=null ){
				var xml:XML = new XML(reObj.result);
				
//				lrj 19.1.7 临时 保存xml
//				GlobalManager.Instance.dispatchEvent(new DatasEvent(UIConstDict.XML_SAVE, xml));
				
				LoadRoomInformation(xml);
			}else{
				LJAlert.show("图像识别的结果为空",2);
			}
		}
		
		private function LoadFault(feObj:FaultEvent):void
		{
			processingTimer.stop();
			parent.removeElement(processingForm);
			LivelyLibrary.ShowMessage(feObj.fault.toString(), 1);
		}
		
		private function LoadMosaicResult(reObj:ResultEvent):void
		{
		//	var xml:XML = new XML(reObj.result);
			var xmlStr:String = reObj.result as String;
			processingTimer.stop();
			parent.removeElement(processingForm);
			var event:DataEvent = new DataEvent(OnLoadMosaicComplete);
			event.data = xmlStr;
			this.dispatchEvent(event);
		}
		
		private function LoadMosaicFault(feObj:FaultEvent):void
		{
			processingTimer.stop();
			parent.removeElement(processingForm);
			LivelyLibrary.ShowMessage(feObj.fault.toString(), 1);
		}
		
		private function PreviewRoomInformation(xml:XML):void
		{
			var event:L3DLoadCADDataEvent;
			if(xml == null || xml.room.line.length() == 0)
			{
				processingTimer.stop();
				parent.removeElement(processingForm);				
				event = new L3DLoadCADDataEvent(null, null, null, null, ratio, edgeSpace);
				this.dispatchEvent(event);	
				return;
			}
			
			var minPoint:Vector3D = new Vector3D();
			var maxPoint:Vector3D = new Vector3D();
			
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();	
			var lineCount:int = xml.room.line.length();
			
			var startPoint:Vector3D;
			var endPoint:Vector3D;
			for(var i:int=0; i<lineCount; i++)
			{			
				startPoint = new Vector3D();
				startPoint.x = Number(xml.room.line[i].@startx);
				startPoint.y = Number(xml.room.line[i].@starty);
				startPoint.z = Number(xml.room.line[i].@startz);
				endPoint = new Vector3D();
				endPoint.x = Number(xml.room.line[i].@endx);
				endPoint.y = Number(xml.room.line[i].@endy);
				endPoint.z = Number(xml.room.line[i].@endz);
				points.push(startPoint);
				points.push(endPoint);
				if(i == 0)
				{
					minPoint.x = Math.min(startPoint.x,endPoint.x);
					minPoint.y = Math.min(startPoint.y,endPoint.y);
					minPoint.z = Math.min(startPoint.z,endPoint.z);
					maxPoint.x = Math.max(startPoint.x,endPoint.x);
					maxPoint.y = Math.max(startPoint.y,endPoint.y);
					maxPoint.z = Math.max(startPoint.z,endPoint.z);
				}
				else
				{
					minPoint.x = Math.min(minPoint.x, Math.min(startPoint.x,endPoint.x));
					minPoint.y = Math.min(minPoint.y, Math.min(startPoint.y,endPoint.y));
					minPoint.z = Math.min(minPoint.z, Math.min(startPoint.z,endPoint.z));
					maxPoint.x = Math.max(maxPoint.x, Math.max(startPoint.x,endPoint.x));
					maxPoint.y = Math.max(maxPoint.y, Math.max(startPoint.y,endPoint.y));
					maxPoint.z = Math.max(maxPoint.z, Math.max(startPoint.z,endPoint.z));
				}
			}
			
			var wpoints:Vector.<Vector3D> = new Vector.<Vector3D>();	
			var wallCount:int = xml.room.wall.length();
			
			for(i=0; i<wallCount; i++)
			{			
				startPoint = new Vector3D();
				startPoint.x = Number(xml.room.wall[i].@startx);
				startPoint.y = Number(xml.room.wall[i].@starty);
				startPoint.z = Number(xml.room.wall[i].@startz);
				endPoint = new Vector3D();
				endPoint.x = Number(xml.room.wall[i].@endx);
				endPoint.y = Number(xml.room.wall[i].@endy);
				endPoint.z = Number(xml.room.wall[i].@endz);
				wpoints.push(startPoint);
				wpoints.push(endPoint);
			}
			
			var width:Number = maxPoint.x - minPoint.x;
			var height:Number = maxPoint.y - minPoint.y;
			
			if(width < 500 || height < 500)
			{
				processingTimer.stop();
				parent.removeElement(processingForm);				
				event = new L3DLoadCADDataEvent(null, null, null, null, ratio, edgeSpace);
				this.dispatchEvent(event);	
				return;	
			}
			
			var imageWidth:int = width / ratio + edgeSpace;
			var imageHeight:int = height / ratio + edgeSpace;
			
			var canvasPanel:Sprite = new Sprite();
			canvasPanel.width = imageWidth;
			canvasPanel.height = imageHeight;
			canvasPanel.graphics.clear();
			canvasPanel.graphics.beginFill(0xFFFFFF,1);
			canvasPanel.graphics.drawRect(0,0,imageWidth,imageHeight);
			canvasPanel.graphics.endFill();
			canvasPanel.graphics.lineStyle(20, 0x000000, 1);
			
			if(wpoints.length > 0)
			{	
				for(var m:int=0;m<wpoints.length;m+=2)
				{					
					var startPoint1:Vector3D = wpoints[m];
					var endPoint1:Vector3D = wpoints[m+1];
					startPoint1.x -= minPoint.x;
					startPoint1.y -= minPoint.y;
					startPoint1.z -= minPoint.z;
					endPoint1.x -= minPoint.x;
					endPoint1.y -= minPoint.y;
					endPoint1.z -= minPoint.z;
					canvasPanel.graphics.moveTo(startPoint1.x * 0.1 + edgeSpace * 0.5, imageHeight - startPoint1.y * 0.1 - edgeSpace * 0.5);
					canvasPanel.graphics.lineTo(endPoint1.x * 0.1 + edgeSpace * 0.5, imageHeight - endPoint1.y * 0.1 - edgeSpace * 0.5);
				}
			}
			
			var bitmap:BitmapData=new BitmapData(imageWidth,imageHeight,true,0x000000);
			bitmap.draw(canvasPanel,new Matrix());
			
			processingTimer.stop();
			parent.removeElement(processingForm);
			
			event = new L3DLoadCADDataEvent(bitmap, points, null, null, ratio, edgeSpace);
			this.dispatchEvent(event);			
		}
		
		private function LoadRoomInformation(xml:XML):void
		{
			var event:L3DLoadCADDataEvent
			if(xml == null)
			{
				processingTimer.stop();
				parent.removeElement(processingForm);				
				event = new L3DLoadCADDataEvent(null, null, null, null, ratio, edgeSpace);
				this.dispatchEvent(event);	
				return;
			}
			
			var minPoint:Vector3D = new Vector3D();
			var maxPoint:Vector3D = new Vector3D();
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var lineCount:int = xml.room.line.length();
	
			for(var i:int=0; i<lineCount; i++)
			{			
				var startPoint:Vector3D = new Vector3D();
				startPoint.x = Number(xml.room.line[i].@startx);
				startPoint.y = Number(xml.room.line[i].@starty);
				startPoint.z = Number(xml.room.line[i].@startz);
				var endPoint:Vector3D = new Vector3D();
				endPoint.x = Number(xml.room.line[i].@endx);
				endPoint.y = Number(xml.room.line[i].@endy);
				endPoint.z = Number(xml.room.line[i].@endz);
				//lx屏蔽
//				points.push(startPoint);
//				points.push(endPoint);				
				if(i == 0)
				{
					minPoint.x = Math.min(startPoint.x,endPoint.x);
					minPoint.y = Math.min(startPoint.y,endPoint.y);
					minPoint.z = Math.min(startPoint.z,endPoint.z);
					maxPoint.x = Math.max(startPoint.x,endPoint.x);
					maxPoint.y = Math.max(startPoint.y,endPoint.y);
					maxPoint.z = Math.max(startPoint.z,endPoint.z);
				}
				else
				{
					minPoint.x = Math.min(minPoint.x, Math.min(startPoint.x,endPoint.x));
					minPoint.y = Math.min(minPoint.y, Math.min(startPoint.y,endPoint.y));
					minPoint.z = Math.min(minPoint.z, Math.min(startPoint.z,endPoint.z));
					maxPoint.x = Math.max(maxPoint.x, Math.max(startPoint.x,endPoint.x));
					maxPoint.y = Math.max(maxPoint.y, Math.max(startPoint.y,endPoint.y));
					maxPoint.z = Math.max(maxPoint.z, Math.max(startPoint.z,endPoint.z));
				}
			}
			
			var width:Number = maxPoint.x - minPoint.x;
			var height:Number = maxPoint.y - minPoint.y;
			
			if(width < 500 || height < 500)
			{
				processingTimer.stop();
				parent.removeElement(processingForm);				
				event = new L3DLoadCADDataEvent(null, null, null, null, ratio, edgeSpace);
				this.dispatchEvent(event);	
			    return;	
			}
			
			var imageWidth:int = width / ratio + edgeSpace;
			var imageHeight:int = height / ratio + edgeSpace;
			
			var canvasPanel:Sprite = new Sprite();
			canvasPanel.width = imageWidth;
			canvasPanel.height = imageHeight;
			canvasPanel.graphics.clear();
			canvasPanel.graphics.beginFill(0xFFFFFF,1);
			canvasPanel.graphics.drawRect(0,0,imageWidth,imageHeight);
			canvasPanel.graphics.endFill();
			canvasPanel.graphics.lineStyle(3, 0x000000, 1);
			
			//lx屏蔽
//			if(points.length > 0)
//			{	
//			    for(var m:int=0;m<points.length;m+=2)
//			    {					
//				    var startPoint1:Vector3D = points[m];
//				    var endPoint1:Vector3D = points[m+1];
//				    startPoint1.x -= minPoint.x;
//				    startPoint1.y -= minPoint.y;
//				    startPoint1.z -= minPoint.z;
//				    endPoint1.x -= minPoint.x;
//			    	endPoint1.y -= minPoint.y;
//			    	endPoint1.z -= minPoint.z;
//			    	canvasPanel.graphics.moveTo(startPoint1.x * 0.1 + edgeSpace * 0.5, imageHeight - startPoint1.y * 0.1 - edgeSpace * 0.5);
//			    	canvasPanel.graphics.lineTo(endPoint1.x * 0.1 + edgeSpace * 0.5, imageHeight - endPoint1.y * 0.1 - edgeSpace * 0.5);
//			    }
//			}
			
			var wallLines:Vector.<L3DWallInfo> = new Vector.<L3DWallInfo>();
			var wallCount:int = xml.room.wall.length();
			if(wallCount > 0)
			{			
			    for(var n:int = 0;n<wallCount;n++)
			    {			
			    	var startPoint2:Vector3D = new Vector3D();
			    	startPoint2.x = Number(xml.room.wall[n].@startx) - minPoint.x;
			    	startPoint2.y = maxPoint.y - Number(xml.room.wall[n].@starty);
			    	startPoint2.z = Number(xml.room.wall[n].@startz) - minPoint.z;
			    	var endPoint2:Vector3D = new Vector3D();
			    	endPoint2.x = Number(xml.room.wall[n].@endx) - minPoint.x;
			    	endPoint2.y = maxPoint.y - Number(xml.room.wall[n].@endy);
			    	endPoint2.z = Number(xml.room.wall[n].@endz) - minPoint.z;
			    	var thickness:Number = Number(xml.room.wall[n].@thickness);
			    	var wallLine:L3DWallInfo = new L3DWallInfo(startPoint2, endPoint2, thickness);
			    	wallLines.push(wallLine);
		    	}
			}
			
			var furnitures:Vector.<L3DFurnitureInfo> = new Vector.<L3DFurnitureInfo>();
			var doorCount:int = xml.room.door.length();
			var furniture:L3DFurnitureInfo;
			if(doorCount > 0)
			{
				for(n = 0;n<doorCount;n++)
				{	
					furniture = new L3DFurnitureInfo();
					furniture.catalog = 3;
					furniture.position.x = Number(xml.room.door[n].@centerx) - minPoint.x;
					furniture.position.y = maxPoint.y - Number(xml.room.door[n].@centery);
					furniture.position.z = Number(xml.room.door[n].@centerz) - minPoint.z;
					furniture.size.x = Number(xml.room.door[n].@width);
					furniture.size.y = Number(xml.room.door[n].@thickness);
					furniture.size.z = Number(xml.room.door[n].@height);
					furniture.rotation = Number(xml.room.door[n].@rotate);
					furniture.type = 0;
                    furnitures.push(furniture);
				}	
			}
			
			var windowCount:int = xml.room.window.length();
			if(windowCount > 0)
			{
				for(n = 0;n<windowCount;n++)
				{	
					furniture = new L3DFurnitureInfo();
					furniture.catalog = 4;
					furniture.position.x = Number(xml.room.window[n].@centerx) - minPoint.x;
					furniture.position.y = maxPoint.y - Number(xml.room.window[n].@centery);
					furniture.position.z = Number(xml.room.window[n].@centerz) - minPoint.z;
					furniture.size.x = Number(xml.room.window[n].@width);
					furniture.size.y = Number(xml.room.window[n].@thickness);
					furniture.size.z = Number(xml.room.window[n].@height);
					furniture.rotation = Number(xml.room.window[n].@rotate);
					furniture.offGround = Number(xml.room.window[n].@offGround);
					furniture.type = Number(xml.room.window[n].@type);
					furnitures.push(furniture);
				}	
			}
			
			var bitmap:BitmapData=new BitmapData(imageWidth,imageHeight,true,0x000000);
			bitmap.draw(canvasPanel,new Matrix());
			
			processingTimer.stop();
			parent.removeElement(processingForm);
			
			event = new L3DLoadCADDataEvent(bitmap, points, wallLines, furnitures, ratio, edgeSpace);
			this.dispatchEvent(event);			
		//	Alert.show("导入完成");
		}
		
		public var recognizeWall:Vector.<L3DWallInfo>;
		public var recognizeFurniture:Vector.<L3DFurnitureInfo>;
		public var recognizeFloor:Vector.<CL3DFloorInfo>;
		
		public function recognizeFloorInfo(json:Object,scale:Number=1):void
		{
			if(json == null)
			{
				return;
			}
			
			var floorCount:int=json.floors.length;
		}
		/**
		 * 识别图型的房型信息处理
		 * @param json
		 * @return 
		 */		
		public function recognizeRoomInfo(json:Object,scale:Number = 1):void
		{
			if(json == null)
			{
				return;
			}
			var floors:Vector.<CL3DFloorInfo>;
			var floorInfo:CL3DFloorInfo;
			var roundPointsObj:Array;
			//房间信息
			var floorCount:int=json.floor.length;
			recognizeFloor=new Vector.<CL3DFloorInfo>();
			for(var i:int=0; i<floorCount; i++)
			{
				floorInfo=new CL3DFloorInfo();
				roundPointsObj=json.floor[i];
				for(var j:int=0; j<roundPointsObj.length; j++)
				{
					floorInfo.roundPoint3Ds.push(roundPointsObj[j].x*scale,roundPointsObj[j].y*scale,0);
				}
				recognizeFloor.push(floorInfo);
			}
			
			var thickness:Number = 240;
			//墙体信息
			var wallLines:Vector.<L3DWallInfo> = new Vector.<L3DWallInfo>();
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			var lineCount:int = json.walls.length;
			var minPoint:Vector3D = new Vector3D();
			minPoint.x = Number.MAX_VALUE;
			minPoint.y = Number.MAX_VALUE;
			for(var i:int=0; i<lineCount; i++)
			{			
				var startPoint:Vector3D = new Vector3D();
				startPoint.x = Number(json.walls[i].x1 * scale);
				startPoint.y = Number(json.walls[i].y1 * scale);
				startPoint.z = 0 * scale;
				var endPoint:Vector3D = new Vector3D();
				endPoint.x = Number(json.walls[i].x2 * scale);
				endPoint.y = Number(json.walls[i].y2 * scale);
				endPoint.z = 0 * scale;
				
				minPoint.x = Math.min(minPoint.x,startPoint.x,endPoint.x);
				minPoint.y = Math.min(minPoint.y,startPoint.y,endPoint.y);
				
				var wallLine:L3DWallInfo = new L3DWallInfo(startPoint, endPoint, thickness);
				wallLines.push(wallLine);
			}
			
			recognizeWall = wallLines;
			
			var allFurniture:Vector.<L3DFurnitureInfo> = new Vector.<L3DFurnitureInfo>();
			
			
			if(json.windows!=null)
			{
				//窗体信息
				var windowWidth:Number;
				var windowHeight:Number;
				for (var j:int = 0; j < json.windows.length; j++) 
				{
					var windowInfo:L3DFurnitureInfo = new L3DFurnitureInfo();
					windowInfo.catalog = 4;
					windowWidth = Math.abs(json.windows[j].x1 -json.windows[j].x2 )*10*scale;
					windowHeight = Math.abs(json.windows[j].y1-json.windows[j].y2)*10*scale;
					//				trace("windowWidth="+windowWidth);
					//				trace("windowHeight="+windowHeight);
					//门窗的X轴定位就是加中间的一半
					windowInfo.position.x = json.windows[j].x1 * scale+windowWidth/2/10;
					windowInfo.position.y = json.windows[j].y1 * scale;
					if(windowWidth==0)
					{
						//垂直方向长度是y
						windowInfo.rotation = 90;
						windowInfo.size.x = windowHeight;
						windowInfo.size.y = 0;
					}else
					{
						//水平方向长度是x
						windowInfo.rotation = 0;
						windowInfo.size.x = windowWidth;
						windowInfo.size.y = 0;
						
					}
					
					windowInfo.size.z = 0;
					windowInfo.position.z = 0;
					
					windowInfo.type = 0;
					allFurniture.push(windowInfo);
				}
			}
			
			if(json.doors!=null)
			{
				//门信息
				var doorWidth:Number;
				var doorHeight:Number;
				for (var k:int = 0; k < json.doors.length; k++) 
				{
					var doorInfo:L3DFurnitureInfo = new L3DFurnitureInfo();
					doorInfo.catalog = 3;
					doorWidth = Math.abs(json.doors[k].x1 -json.doors[k].x2 )*10*scale;
					doorHeight = Math.abs(json.doors[k].y1 -json.doors[k].y2 )*10*scale;
					
					doorInfo.position.x = json.doors[k].x1 * scale+doorWidth/2/10;
					doorInfo.position.y = json.doors[k].y1 * scale;
					
					if(doorWidth==0)
					{
						//垂直方向长度是y
						doorInfo.rotation = 90;
						doorInfo.size.x = doorHeight;
						doorInfo.size.y = 0;
					}else
					{
						//水平方向长度是x
						doorInfo.rotation = 0;
						doorInfo.size.x = doorWidth;
						doorInfo.size.y = 0;
						
					}
					
					doorInfo.size.z = 0;
					doorInfo.position.z = 0;
					
					doorInfo.type = 0;
					allFurniture.push(doorInfo);
				}
			}
			
			recognizeFurniture = allFurniture;
		}
	}
}
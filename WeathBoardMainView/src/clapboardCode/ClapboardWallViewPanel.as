package clapboardCode
{
	import com.lejia.wallTile.planNew.WallData;
	import com.lejia.wallTile.planNew.WallDataXML;
	import com.lejia.wallTile.uiNew.TilePanel;
	import com.lejia.wallTile.uiNew.WallViewPanel;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	
	import spark.events.IndexChangeEvent;
	
	import utils.CMeshUtil;
	import utils.DatasEvent;
	import utils.Manager;
	
	import walltile.regionEditorNew.L3DRegionView;
	
	public class ClapboardWallViewPanel extends WallViewPanel
	{
		private var _invalidProperty:Boolean;
		private var _currentIndex:int;
		private var _currentWallLength:Number;
		private var _currentWallRegions:Array;
		private var _allRegionsInWall:Array;
		/**
		 * 初始化完成回调 
		 * @return 
		 * 
		 */		
		public var  initCompleteCallback:Function;
		/**
		 * 获取所有墙体上的区域围点集合 
		 * @return Array
		 * 
		 */		
		public function get allRegionsInWall():Array
		{
			if(_allRegionsInWall==null)
			{
				_allRegionsInWall=new Array(_wallBottomPoints.length);
				for(var i:int=0; i<_wallBottomPoints.length; i++)
				{
					_allRegionsInWall[i]=CMeshUtil.Instance.getWallAllRegionRoundPointsByholes(wdData[i],Point.distance(_wallBottomPoints[i].pointA,_wallBottomPoints[i].pointB),_height);
				}
			}
			return _allRegionsInWall;
		}
		/**
		 * 获取当前墙体的区域围点集合 
		 * @return Array
		 * 
		 */		
		public function get currentWallRegions():Array
		{
			currentIndex;
			return _currentWallRegions;
		}
		/**
		 * 获取当前墙体的区域视图 
		 * @return L3DRegionView
		 * 
		 */		
		public function get regionView():L3DRegionView
		{
			return wallPanel.tilePanels[currentIndex][1] as L3DRegionView;
		}
		/**
		 * 获取当前墙体所在集合的索引 
		 * @return int
		 * 
		 */		
		public function get currentIndex():int
		{
			if(_currentIndex != wallPanel._index)
			{
				_invalidProperty=true;
				_currentIndex=wallPanel._index;
				_currentWallRegions=CMeshUtil.Instance.getWallAllRegionRoundPointsByholes(wdData[_currentIndex],Point.distance(currentWallPointObject.pointA,currentWallPointObject.pointB),_height);
			}
			return _currentIndex;
		} 
		/**
		 * 获取当前墙体的长度 
		 * @return 
		 * 
		 */		
		public function get currentWallLength():Number
		{
			if(_invalidProperty)
				updateProperty();
			return _currentWallLength;
		}
		/**
		 * 获取当前墙体的高度 
		 * @return Number
		 * 
		 */		
		public function get wallHeight():Number
		{
			return _height;
		}
		/**
		 * 获取当前墙体的地面起始围点和终止围点 
		 * @return Object
		 * 
		 */		
		public function get currentWallPointObject():Object
		{
			return _wallBottomPoints[currentIndex];
		}
		
		public function get screenScale():Number
		{
			return (wallPanel.tilePanels[currentIndex][0] as TilePanel).scale;
		}
		
		public function ClapboardWallViewPanel()
		{
			_currentIndex=-1;
			super();
		}
		/**
		 *输入一组围点，把墙面划分区域	 
		 * @param points
		 * 
		 */		
		public function addFreeRegion(points:Array):void
		{
			if(points == null || points.length == 0)
			{
				_currentWallRegions=CMeshUtil.Instance.getWallAllRegionRoundPointsByholes(wdData[_currentIndex],Point.distance(currentWallPointObject.pointA,currentWallPointObject.pointB),_height);
				return;
			}
			var arr:Array = [];
			var scale:Number=screenScale;
			for(var i:int = 0 ;i < points.length ;i++)
			{
				var fpoints:Array = [];
				for(var j:int = 0 ;j < points[i].points.length;j++)
				{
					var point:Point=regionView.globalToLocal(new Point(points[i].points[j].x,points[i].points[j].y));
					point.x = point.x* scale;
					point.y = point.y * scale;
					fpoints.push(point);
				}
				var obj:Object = new Object();
				obj.points = fpoints;
				arr.push(obj);
			}
			_currentWallRegions=CMeshUtil.Instance.getWallAllRegionRoundPointsByholes(arr,Point.distance(currentWallPointObject.pointA,currentWallPointObject.pointB),_height,10,true);
		}
		private function updateProperty():void
		{
			_invalidProperty=false;
			_currentWallLength=Point.distance(currentWallPointObject.pointA,currentWallPointObject.pointB);
		}
		
		private function clearData():void
		{
			_wallBottomPoints.length=0;
			_wallIdx=0;
			wallPanel._index=0;
		}
		
		/**
		 * * 获取当前点击的区域围点坐标 
		 * @param mouseX	X坐标
		 * @param mouseY	Y坐标
		 * @param isGlobal	是否是全局坐标
		 * @param output	输出参数
		 * @return Array	返回区域围点坐标 
		 * 
		 */		
		public function getRegion(mouseX:Number,mouseY:Number,isGlobal:Boolean=true,output:Array=null):Array
		{
			var posX:Number;
			var posY:Number;
			var points:Array;
			var scale:Number=screenScale;
			if(isGlobal)
			{
				var point:Point=regionView.globalToLocal(new Point(mouseX,mouseY));
				posX=point.x*scale;
				posY=point.y*scale;
			}
			else
			{
				posX=mouseX*scale;
				posY=mouseY*scale;
			}
			for (var i:int =0;i<_currentWallRegions.length;i++)
			{
				if(posX>_currentWallRegions[i][0].x && posX<_currentWallRegions[i][1].x && posY<_currentWallRegions[i][0].y && posY>_currentWallRegions[i][2].y)
				{
					points=new Array(_currentWallRegions[i].length);
					for(var j:int=0; j<points.length; j++)
					{
						points[j]=_currentWallRegions[i][j].clone();
					}
					if(output!=null)
					{
						output[0]=i;
						output[1]=points;
					}
					break;
				}
			}
			return points;
		}
		/**
		 * 清空所有数据  
		 * 
		 */		
		public function clearAll():void
		{
			_currentWallRegions=null;
			_allRegionsInWall=null;
			this.removeAllElements();
			wallPanel.clearAllWall();
			wallPanel.removeAllElements();
			wallPanel=null;
		}
		override public function initData(points:Array, height:Number, data:WallData=null, wdData:Array=null, isFrom3DWall:Boolean=false, isMeshWallMode:Boolean=false):void
		{
			clearData();
			super.initData(points,height,data,wdData,isFrom3DWall,isMeshWallMode);
		}
		override protected function transferWallData(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,transferWallData);
			controlPanel.controlList.flusPreview = wallPanel.flusPreview;
			Manager.globalEventDispatcher.addEventListener("puzhuangclose",function(event:Event):void{closeView(false);});
			controlPanel.visible = !_isFrom3DWall;

			wallPanel.initPanelData(_lens,_height,_wallData,wdData);
			if(controlPanel.visible){
				controlPanel.setWallData(_points,_lens,_height,wallPanel,this);	
			}else{
				wallPanel.setWallIdx(_wallIdx);
			}
			controlPanel.controlList.list.addEventListener(IndexChangeEvent.CHANGING,onChang);
			controlPanel.controlList.removeElement(controlPanel.controlList.btnGroup);
			controlPanel.controlList.copyBtn.visible=false;
			controlPanel.controlList.closeBtn.visible=false;
			
			if(initCompleteCallback!=null)
			{
				initCompleteCallback();
			}
			this.addEventListener("setPreviewWall",handler);
		}
		
		protected function handler(event:DatasEvent):void
		{
			if(controlPanel.visible){
				controlPanel.setPreviewWallImage(event.data);	
			}
			if( WallDataXML.loadOnKey )
			{
				wallPanel.onKeySetWallData();
			}
		}
	}
}
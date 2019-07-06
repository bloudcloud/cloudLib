package extension.wl.utils
{
	import extension.wl.buttons.LabelButton;
	import extension.wl.buttons.SvgButton;
	import extension.wl.globalData.allStaticTypes.ColorType;
	import extension.wl.globalData.allStaticTypes.LivelyType;
	import extension.wl.globalData.allStaticTypes.SvgType;
	import extension.wl.models.SvgModel;
	import extension.wl.views.SaveView;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Spacer;
	import mx.core.UIComponent;
	
	import spark.components.Application;
	import spark.components.Group;
	import spark.components.VGroup;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	
	import utils.DatasEvent;

	public class SystemCutUtils extends EventDispatcher
	{
		public var stageMain:Application = null;
		private var backGround:UIComponent = null;
		private var cutRect:UIComponent = null;
		private var cutPoint:Point = null;
		private var cutData:BitmapData;//截图数据
		
		private var toolContainer:Group = null;
		private var toolBox:VGroup = null;
		private var saveView:SaveView = null;//保存弹出条组件
		
		public static const SYSTEM_CUT_EVENT:String = "systemCut_event";
		
		public function SystemCutUtils()
		{
		}
		
		/**
		 * 初始化截图组件,绘制矩形区域截图
		 * 鼠标按下开始绘制，鼠标抬起绘制完成
		 * 
		 */		
		public function initCut():void
		{
			if(!backGround)
			{
				backGround = new UIComponent();
				backGround.graphics.beginFill(0x000000, .1);
				backGround.graphics.drawRect(0, 0, stageMain.width, stageMain.height);
				backGround.graphics.endFill();
				backGround.addEventListener(MouseEvent.MOUSE_DOWN, screenshotStartHandler);
			}
			stageMain.addElement(backGround);
		}
		/**
		 * 初始化2D截屏,默认去掉底边条高度
		 * @param bottomHeight 底边条高度
		 * 
		 */			
		public function init2DScreenshot(bottomHeight:int):void
		{
			var cutX:Number = 0;
			var cutY:Number = 0;
			var cutW:Number = Math.floor(stageMain.width - 2);
			var cutH:Number = Math.floor(stageMain.height - bottomHeight - 2);
			
			var stageBmd:BitmapData = new BitmapData(stageMain.width,stageMain.height,false,0xFFFFFF);
			stageBmd.draw(stageMain);
			cutData = getCutData(stageBmd,new Rectangle(cutX,cutY,cutW,cutH));
			
			buildToolHandler();
		}
		/**
		 * 初始化3D截屏、单产品展示截图
		 * @param bmd 3D截屏数据
		 * 
		 */		
		public function init3DScreenshot(bmd:BitmapData):void
		{
			cutData = bmd;
			buildToolHandler();
		}
		
		private function screenshotStartHandler(evt:MouseEvent):void 
		{
			cutPoint = new Point(evt.stageX, evt.stageY);
			backGround.addEventListener(MouseEvent.MOUSE_MOVE, screenshotDrawHandler);
			backGround.addEventListener(MouseEvent.MOUSE_UP, screenshotEndHandler);
			backGround.addEventListener(MouseEvent.MOUSE_OUT, screenshotEndHandler);
			cleanTool();
		}
		
		private function screenshotDrawHandler(evt:MouseEvent):void 
		{
			if (!cutRect)
			{
				cutRect = new UIComponent();
				cutRect.mouseEnabled = false;
				cutRect.mouseChildren = false;
				stageMain.addElement(cutRect);
			}
			var w:Number = Math.abs(evt.stageX - cutPoint.x);
			var h:Number = Math.abs(evt.stageY - cutPoint.y);
			var originX:Number = cutPoint.x>evt.stageX?evt.stageX:cutPoint.x;
			var originY:Number = cutPoint.y>evt.stageY?evt.stageY:cutPoint.y;
			
			cutRect.width = w;
			cutRect.height = h;
			cutRect.graphics.clear();
			cutRect.graphics.beginFill(0x00000, 0);
			cutRect.graphics.lineStyle(1, 0xff0000, 1);
			cutRect.graphics.drawRect(originX, originY, w ,h);
			cutRect.graphics.endFill();
		}
		
		private function screenshotEndHandler(evt:MouseEvent):void 
		{
			backGround.removeEventListener(MouseEvent.MOUSE_MOVE, screenshotDrawHandler);
			backGround.removeEventListener(MouseEvent.MOUSE_UP, screenshotEndHandler);
			backGround.removeEventListener(MouseEvent.MOUSE_OUT, screenshotEndHandler);
			if (cutRect && cutRect.width > 2 && cutRect.height > 2)
			{
				var cutX:Number = cutPoint.x>evt.stageX?evt.stageX+1:cutPoint.x+1;
				var cutY:Number = cutPoint.y>evt.stageY?evt.stageY+1:cutPoint.y+1;
				var cutW:Number = Math.floor(cutRect.width - 2);
				var cutH:Number = Math.floor(cutRect.height - 2);
				
				var stageBmd:BitmapData = new BitmapData(stageMain.width,stageMain.height,false,0xFFFFFF);
				stageBmd.draw(stageMain);
				cutData = getCutData(stageBmd,new Rectangle(cutX,cutY,cutW,cutH));
				
				buildToolHandler();
			}
		}
		
		private function buildToolHandler():void
		{
			if(!toolContainer)
			{
				toolContainer = new Group();
				toolContainer.top = 0;
				toolContainer.right = 0;
				toolContainer.width = 50;
				toolContainer.height = stageMain.height;
				toolContainer.graphics.beginFill(ColorType.LightGreyBackGround);
				toolContainer.graphics.drawRect(0,0,toolContainer.width,toolContainer.height);
				toolContainer.graphics.endFill();
				stageMain.addElement(toolContainer);
			}
			if(!toolBox)
			{
				toolBox = new VGroup();
				toolBox.horizontalAlign = HorizontalAlign.CENTER;
				toolBox.verticalAlign = VerticalAlign.MIDDLE;
				toolBox.gap = 10;
				toolBox.top = 10;
				toolBox.left = 5;
				toolContainer.addElement(toolBox);
			}
			var len:int = toolList.length;
			for (var i:int = 0; i < len; i++) 
			{
				buildSvgButton(toolList[i]);
				if(i == 0)
				{
					var space:Spacer = new Spacer();
					space.width = 40;
					space.height = 5;
					toolBox.addElement(space);
				}
			}
		}
		
		private function buildSvgButton(svgEvent:String):void
		{
			var svg:SvgButton = SvgButton.buildSvgButton(svgEvent,40,40,LivelyType.currentStyle);
			if(svgEvent == SvgType.POPUP_SIZE_EVENT)
			{
				svg.svgTip = "标注";
			}
			svg.addEventListener(MouseEvent.CLICK,svgClickHandler);
			toolBox.addElement(svg);
		}
		
		private function get toolList():Array
		{
			var list:Array = [SvgType.CLOSE_EVENT];
//			list.push(SvgType.SCREENSHOOT_FRAME_EVENT,SvgType.POPUP_SIZE_EVENT,SvgType.SCREENSHOOT_TEXT_EVENT,SvgType.SCREENSHOOT_WATERMARK_EVENT);
			list.push(SvgType.SCREENSHOT_SAVE_EVENT);
//			list.push(SvgType.SCREENSHOOT_SHARE_EVENT);
			return list;
		}
		
		protected function svgClickHandler(event:MouseEvent):void
		{
			var svg:SvgButton = event.currentTarget as SvgButton;
			var svgModel:SvgModel = svg.model;
			switch(svgModel.SVG_EVENT)
			{
				case SvgType.CLOSE_EVENT:
					if(cutData)
					{
						cutData = null;
					}
					cleanCutView();
					break;
				case SvgType.SCREENSHOOT_FRAME_EVENT:
				case SvgType.POPUP_SIZE_EVENT:
				case SvgType.SCREENSHOOT_TEXT_EVENT:
				case SvgType.SCREENSHOOT_WATERMARK_EVENT:
					break;
				case SvgType.SCREENSHOT_SAVE_EVENT:
					if(!saveView)
					{
						saveView = new SaveView();
						saveView.width = 360;
						saveView.height = 50;
						saveView.addEventListener(LabelButton.LABEL_EVENT,screenshotSaveHandler);
						saveView.x = stageMain.width - saveView.width >> 1;
						saveView.y = stageMain.height - saveView.height >> 1;
						stageMain.addElement(saveView);
					}
					break;
				case SvgType.SCREENSHOOT_SHARE_EVENT:
					break;
			}
		}
		
		private function cleanSaveView():void
		{
			if(saveView)
			{
				saveView.removeEventListener(LabelButton.LABEL_EVENT,screenshotSaveHandler);
				stageMain.removeElement(saveView);
				saveView = null;
			}
		}
		
		protected function screenshotSaveHandler(event:DatasEvent):void
		{
			cleanSaveView();
			var saveName:String = event.data as String;
			var cutByte:ByteArray = L3DMaterial.BitmapDataToBuffer(cutData);
			var f:FileReference = new FileReference();
			try
			{
				f.save(cutByte, saveName+".jpg");
			}
			catch(error:Error)
			{
				
			}
			cleanCutView();
		}
		
		private function cleanCutView():void
		{
			if(backGround)
			{
				backGround.removeEventListener(MouseEvent.MOUSE_DOWN, screenshotStartHandler);
				stageMain.removeElement(backGround);
				backGround = null;
			}
			if(cutRect)
			{
				stageMain.removeElement(cutRect);
				cutRect = null;
			}
			if(cutPoint)
			{
				cutPoint = null;
			}
			cleanSaveView();
			cleanTool();
		}
		
		private function cleanTool():void
		{
			if(toolContainer)
			{
				if(toolBox)
				{
					var len:int = toolBox.numElements;
					for (var i:int = 0; i < len; i++) 
					{
						var child:DisplayObject = toolBox.getChildAt(i);
						if(child is SvgButton)
						{
							var svg:SvgButton = child as SvgButton;
							svg.removeEventListener(MouseEvent.CLICK,svgClickHandler);
							svg = null;
						}
					}
					toolBox = null;
				}
				toolContainer.removeAllElements();
				stageMain.removeElement(toolContainer);
				toolContainer = null;
			}
		}
		/**
		 * 获取所裁剪区域的数据。所有像素信息
		 * @param source 源图数据
		 * @param rect 所有裁剪的区域
		 * @return BitmapData 裁剪出新图的数据
		 * 
		 */		
		public function getCutData(source:BitmapData,rect:Rectangle):BitmapData
		{ 
			var cutbitmapdata:BitmapData = new BitmapData(Math.floor(rect.width),Math.ceil(rect.height));//存放裁剪出的新图片 
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -Math.floor(rect.x), -Math.floor(rect.y));//坐标转化，把坐标移到裁剪区域的位置，宽度和高度在cutbitmapdata里指定。 
			cutbitmapdata.draw(source, matrix);
			return cutbitmapdata;
		} 
		
	}
}
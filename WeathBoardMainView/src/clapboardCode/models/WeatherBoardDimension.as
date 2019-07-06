package clapboardCode.models
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	import spark.components.TextInput;
	
	import utils.DatasEvent;
	import utils.lx.managers.GlobalManager;
	

	public class WeatherBoardDimension
	{
		private var lidigao:Number=0;
		private var revlidigao:Number=0;
		private var rightwidth:Number=0;
		
		private var leftwidth:Number=0;
		private var _scale:Number = 1;
		private var tempObj:Object = new Object();
		public function WeatherBoardDimension(enforcer:SingleTone)
		{
		}
		private static var _Instance:WeatherBoardDimension;
		public static function get Instance():WeatherBoardDimension
		{
			return _Instance ||= new WeatherBoardDimension(new SingleTone());
		}
		public static var WeathBoard_change_AreaPos:String = "WeathBoardchangeAreaPos";
		public  function drawAreaDimension(parent:UIComponent,areaPoint:Array,scale:Number,panelW:Number,panelH:Number):void
		{
			var wid:Number = panelW;
			var hei:Number = panelH;
			_scale = scale;
			deleteAreaDimension(parent);
			var lefttext:TextInput=new TextInput();
			var toptext:TextInput=new TextInput();
			var righttext:TextInput=new TextInput();
			var bottomtext:TextInput=new TextInput();
			parent.addChild(lefttext);
			parent.addChild(righttext);
			parent.addChild(toptext);
			parent.addChild(bottomtext);
			var middlePoints:Array = getPointMiddle(areaPoint);
			var leftPoint:Point = parent.globalToLocal(middlePoints[0]);
			var rightPoint:Point = parent.globalToLocal(middlePoints[1]);
			var topPoint:Point = parent.globalToLocal(middlePoints[2]);
			var bottomPoint:Point = parent.globalToLocal(middlePoints[3]);
			var leftPointU:Point = new Point(0,leftPoint.y);
			var rightPointU:Point = new Point(wid/scale,rightPoint.y);
			var topPointU:Point = new Point(topPoint.x,hei/scale);
			var bottomPointU:Point = new Point(bottomPoint.x,0);
			if(tempObj.index == 0 && tempObj.value != null)
			{
				lefttext.text=String(tempObj.value);
			}
			else
			{
				lefttext.text=String(Math.abs(Math.round((leftPointU.x - leftPoint.x)*scale)));
			}
			lefttext.x=leftPoint.x - 10;
			lefttext.y=leftPoint.y ;
			lefttext.width=32;
			lefttext.height=20;
			if (Math.abs(int(leftPointU.x - leftPoint.x)) == 0)
				lefttext.visible=false;
			else
				lefttext.visible=true;
			lefttext.setStyle("fontSize", 10);
			lefttext.setStyle("fontFamily", "宋体");
			lefttext.name = "left";
			lefttext.addEventListener(FocusEvent.FOCUS_IN, onfocus);
			lefttext.addEventListener(KeyboardEvent.KEY_DOWN, onchange);
			if(tempObj.index == 1 && tempObj.value != null)
			{
				righttext.text=String(tempObj.value);
			}
			else
			{
				righttext.text=String(Math.abs(Math.round((rightPointU.x - rightPoint.x)*scale)));
			}
			righttext.x=rightPoint.x ;
			righttext.y=rightPoint.y ;
			righttext.width=32;
			righttext.height=20;
			righttext.name = "right";

			if (Math.abs(int(rightPointU.x - rightPoint.x)) == 0)
				righttext.visible=false;
			else
				righttext.visible=true;
			righttext.setStyle("fontSize", 10);
			righttext.setStyle("fontFamily", "宋体");
			righttext.addEventListener(KeyboardEvent.KEY_DOWN, onchange);
			righttext.addEventListener(FocusEvent.FOCUS_IN, onfocus);
			if(tempObj.index == 2 && tempObj.value != null)
			{
				toptext.text=String(tempObj.value);
				tempObj.value = null;
				tempObj.type == -1;
			}
			else
			{
			toptext.text=String(Math.abs(Math.round((topPointU.y - topPoint.y)*scale)));
			}
			toptext.x=topPoint.x ;
			toptext.y=topPoint.y ;
			toptext.name = "top";

			toptext.width=32;
			toptext.height=20;
			if (Math.abs(int(topPointU.y - topPoint.y)) == 0)
				toptext.visible=false;
			else
				toptext.visible=true;
			toptext.setStyle("fontSize", 10);
			toptext.setStyle("fontFamily", "宋体");
			toptext.addEventListener(KeyboardEvent.KEY_DOWN, onchange);
			toptext.addEventListener(FocusEvent.FOCUS_IN, onfocus);
			if(tempObj.index == 3 && tempObj.value != null)
			{
				bottomtext.text=String(tempObj.value);
			}
			else
			{
				bottomtext.text=String(Math.abs(Math.round((bottomPointU.y - bottomPoint.y)*scale)));
			}
			bottomtext.x=bottomPoint.x ;
			bottomtext.y=bottomPoint.y  - 10;
			bottomtext.width=32;
			bottomtext.name = "bottom";
			bottomtext.height=20;
			bottomtext.setStyle("fontSize", 10);
			bottomtext.setStyle("fontFamily", "宋体");
			if (Math.abs(int(bottomPointU.y - bottomPoint.y)) == 0)
				bottomtext.visible=false;
			else
				bottomtext.visible=true;
			bottomtext.addEventListener(KeyboardEvent.KEY_DOWN, onchange);
			bottomtext.addEventListener(FocusEvent.FOCUS_IN, onfocus);
			lidigao=int((topPointU.y - topPoint.y)*scale)/scale;
			revlidigao=int((bottomPoint.y - bottomPointU.y)*scale)/scale;
			rightwidth=int((rightPointU.x - rightPoint.x)*scale)/scale;
			leftwidth=int((leftPoint.x - leftPointU.x)*scale)/scale;
			tempObj.value = null;
			tempObj.index == -1;
		}
		public function deleteAreaDimension(parent:UIComponent):void
		{
			for(var i:int = 0 ;i < parent.numChildren;i++)
			{
				if(parent.getChildAt(i).name == "left" || parent.getChildAt(i).name == "right"
					||parent.getChildAt(i).name == "top" || parent.getChildAt(i).name == "bottom")
				{
					parent.getChildAt(i).removeEventListener(FocusEvent.FOCUS_IN, onfocus);
					parent.getChildAt(i).removeEventListener(KeyboardEvent.KEY_DOWN, onchange);
					parent.removeChildAt(i);
					i--;					
				}
			}

		}
		private function onfocus(evt:Event):void
		{
			evt.currentTarget.selectAll();
		}
		private function onchange(evt:KeyboardEvent):void
		{
			if(evt.keyCode != Keyboard.ENTER)
				return;
			var point:Point = new Point();
			var len:Number = Number(evt.currentTarget.text);
			tempObj["value"] = len;
//			len *= scale;
			switch(evt.currentTarget.name)
			{
				case "left":
					tempObj["index"] = 0;
					point.x = Math.round((len/_scale - leftwidth)*_scale)/_scale;
					break;
				case "right":
					tempObj["index"] = 1;
					point.x = Math.round((rightwidth - len/_scale)*_scale)/_scale;
					break;
				case "top":
					tempObj["index"] = 2;
					point.y = Math.round((lidigao - len/_scale)*_scale)/_scale;
					break;
				case "bottom":
					tempObj["index"] = 3;
					point.y = Math.round((len/_scale - revlidigao)*_scale)/_scale;
					break;
			}
			GlobalManager.Instance.dispatchEvent(new DatasEvent(WeatherBoardDimension.WeathBoard_change_AreaPos,point));
		}
		private　 function getPointMiddle(points:Array):Array
		{
			var leftP:Point;
			var rightP:Point;
			var downP:Point;
			var upP:Point;
			var minP:Point = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
			var maxP:Point = new Point(Number.MIN_VALUE,Number.MIN_VALUE);
			for each(var p:Point in points)
			{
				if(p.x > maxP.x)
				{
					maxP.x = p.x;
				}
				if(p.x　< minP.x)
				{
					minP.x = p.x;
				}
				if(p.y > maxP.y)
				{
					maxP.y = p.y;
				}
				if(p.y < minP.y)
				{
					minP.y = p.y;
				}
			}
			leftP = new Point(minP.x ,(minP.y + maxP.y)/2);
			rightP = new Point(maxP.x,(minP.y + maxP.y)/2);
			upP = new Point((minP.x + maxP.x)/2,maxP.y);
			downP = new Point((minP.x + maxP.x)/2,minP.y);
			var arr:Array = [];
			arr.push(leftP,rightP,upP,downP);
			return arr;
		}
	}
}
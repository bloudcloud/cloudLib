package clapboardCode.sdObject
{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class SdInput extends Sprite  
	{  
		private var _width:int=200;
		private var _height:int=50;
		private var _txt:TextField;
		private var _fontsize:int = 20;
		private var _border_w:int = 2;
		public function SdInput(width:int,height:int, fz:int=20)  
		{  
			_width = width;  
			_height = height;  
			_fontsize = fz;
			CreateChild();  
		}  
		
		public function CreateChild():void{  
			//添加3D边框  
			var border:Border2D = new Border2D(_width,_height,_border_w);  
			addChild(border);  
			
			//添加TextField  
			_txt = new TextField();  
			var fmt:TextFormat=new TextFormat("Microsoft YaHei",_fontsize,0x0);
			_txt.defaultTextFormat=fmt;
			_txt.type = TextFieldType.INPUT;  
			_txt.x = _border_w;  
			_txt.y = _border_w;  
			_txt.width = _width-2*_border_w;  
			_txt.height = _height-2*_border_w;  
			_txt.background = true;  
			_txt.backgroundColor = 0xffffff;  
			addChild(_txt);  
		}  
		
		public function set text(t:String):void{
			_txt.text = t;
		}
		public function get text():String{
			return _txt.text;
		}
		
		public function setFocus():void
		{
			if(_txt!=null)
			{
				this.stage.focus = _txt;
				_txt.setSelection(0, _txt.text.length);
			}
		}
		
		public function get txtField():TextField
		{
			return _txt;
		}
	}  
}

import flash.display.Graphics;
import flash.display.Sprite;

import mx.utils.ColorUtil;
class Border3D extends Sprite  
{  
	//定义高度和宽度  
	public var w:int;  
	public var h:int;  
	
	public function Border3D(width:int,height:int)  
	{  
		w = width;  
		h = height;  
		drawBorder();  
	}  
	
	public function drawBorder():void  
	{  
		//定义边框颜色  
		var borderColor:uint;  
		var borderColorDrk1:uint  
		var borderColorDrk2:uint  
		var borderColorLt1:uint   
		var borderInnerColor:uint;  
		
		//设定边框颜色  
		borderColor = 0xb7babc;       
		borderColorDrk1 =  
			ColorUtil.adjustBrightness2(borderColor, -40);  
		borderColorDrk2 =  
			ColorUtil.adjustBrightness2(borderColor, +25);  
		borderColorLt1 =   
			ColorUtil.adjustBrightness2(borderColor, +40);                
		borderInnerColor = 0xffffff;  
		
		//画出3D边框效果  
		draw3dBorder(borderColorDrk2, borderColorDrk1, borderColorLt1,  
			Number(borderInnerColor),   
			Number(borderInnerColor),   
			Number(borderInnerColor));  
		
	}  
	
	public function draw3dBorder(c1:Number, c2:Number, c3:Number,  
								 c4:Number, c5:Number, c6:Number):void  
	{  
		var g:Graphics = graphics;  
		g.clear();  
		
		// outside sides  
		g.beginFill(c1);  
		g.drawRect(10, 10, w, h);  
		g.drawRect(11, 10, w - 2, h);  
		g.endFill();  
		
		// outside top  
		g.beginFill(c2);  
		g.drawRect(11, 10, w - 2, 1);  
		g.endFill();  
		
		// outside bottom  
		g.beginFill(c3);  
		g.drawRect(11, 10 + h - 1, w - 2, 1);  
		g.endFill();  
		
		// inside top  
		g.beginFill(c4);  
		g.drawRect(11, 11, w - 2, 1);  
		g.endFill();  
		
		// inside bottom  
		g.beginFill(c5);  
		g.drawRect(11, 10 + h - 2, w - 2, 1);  
		g.endFill();  
		
		// inside sides  
		g.beginFill(c6);  
		g.drawRect(11, 12, w - 2, h - 4);  
		g.drawRect(12, 12, w - 4, h - 4);  
		g.endFill();  
	}  
}

class Border2D extends Sprite{
	public function Border2D(w:int,h:int,bw:int)
	{
		this.graphics.beginFill(0x0);
		this.graphics.drawRect(0,0,bw,h);
		this.graphics.endFill();
		
		this.graphics.beginFill(0x0);
		this.graphics.drawRect(0,0, w, bw);
		this.graphics.endFill();
		
		this.graphics.beginFill(0x0);
		this.graphics.drawRect(w-bw,0,bw,h);
		this.graphics.endFill();
		
		this.graphics.beginFill(0x00);
		this.graphics.drawRect(0,h-bw,w,bw);
		this.graphics.endFill();
	}
}
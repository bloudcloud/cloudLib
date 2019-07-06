package clapboardCode.sdObject
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SdLabel extends Sprite
	{
		private var _width:int=200;
		private var _height:int=50;
		private var _txt:TextField;
		private var _fontsize:int = 20;
		public function SdLabel(width:int,height:int,id:String, fz:int=20)
		{
			_width=width;
			_height=height;
			_fontsize = fz;
			this.mouseChildren=false;
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
			_txt=initText(id);
			this.addChild(_txt);
			_txt.x=(_width-_txt.width)/2;
			_txt.y=(_height-_txt.height)/2;
		}
		
		private function initText(value:String):TextField{
			var tf:TextField=new TextField();
			var fmt:TextFormat=new TextFormat("Microsoft YaHei",_fontsize,0xffffff);
			tf.defaultTextFormat=fmt;
			tf.text=value;
			tf.width=tf.textWidth+5;
			tf.height=tf.textHeight+5;
			return tf;
		}
	}
}
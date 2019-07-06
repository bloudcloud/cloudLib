package clapboardCode.sdObject
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SdBtn extends Sprite
	{
		private var _width:int=200;
		private var _height:int=50;
		private var _fontsize:Number = 20;
		private var _txt:TextField;
		public function SdBtn(width:int,height:int,fontsize:int, id:String)
		{
			_width=width;
			_height=height;
			_fontsize = fontsize;
			this.mouseChildren=false;
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
			_txt=initText(id);
			this.addChild(_txt);
			_txt.x=(_width-_txt.width)/2;
			_txt.y=(_height-_txt.height)/2;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		private function onOver(evt:MouseEvent):void{
			_txt.textColor=0xf9db4a;
		}
		private function onOut(evt:MouseEvent):void
		{
			if(_bClicked)
			{
				onClickState();
			}
			else
			{
				onLostState();
			}
		}
		private function initText(value:String):TextField
		{
			var tf:TextField=new TextField();
			var fmt:TextFormat=new TextFormat("Microsoft YaHei",_fontsize,0xffffff);
			tf.defaultTextFormat=fmt;
			tf.text=value;
			tf.width=tf.textWidth+5;
			tf.height=tf.textHeight+5;
			return tf;
		}
		
		private var _bClicked:Boolean = false;
		public function onClickState():void
		{
			_bClicked = true;
			_txt.textColor = 0xf9db4a;
		}
		
		public function onLostState():void
		{
			_txt.textColor=0xffffff;
			_bClicked = false;
		}
	}
}
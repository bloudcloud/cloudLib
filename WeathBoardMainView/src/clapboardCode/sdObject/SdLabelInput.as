package clapboardCode.sdObject
{
	import flash.display.Sprite;
	
	/*带标签的输入框*/
	public class SdLabelInput extends Sprite
	{
		/*组件宽度*/
		private var _width:Number = 20;
		/*组件高度*/
		private var _height:Number = 20;
		/*标签宽度*/
		private var _label_width:Number= 20;
		/*标签文字*/
		private var _label_text:String = "";
		/*标签文字大小*/
		private var _label_font_size:int = 20;
		/*输入框宽度*/
		private var _input_width:Number = 20;
		/*输入文本字体大小*/
		private var _input_font_size :int = 20;
		/*默认文字*/
		private var _input_default_text:String = "0";
		
		/*标签Sprite*/
		private var _sdLabel:SdLabel = null;
		/*输入框Sprite*/
		public var _sdInput:SdInput = null;
		
		public function SdLabelInput(w:Number, h:Number)
		{
			super();
			
			_width = w; _height = h;
			this.graphics.beginFill(0x00);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
		}
		
		/*设置文本参数*/
		public function setLabelSize(w:Number, text:String, font_size:int):void
		{
			_label_width = w;
			_label_text = text;
			_label_font_size = font_size;
		}
		
		/*设置输入文本大小*/
		public function setInputSize(font_size:int, default_text:String=""):void
		{
			_input_font_size = font_size;
			_input_default_text = default_text;
		}
		
		/*创建输入框*/
		public function createWindow():void{
			this._sdLabel = new SdLabel(_label_width, _height, _label_text, _label_font_size);
			this.addChild(this._sdLabel);
			
			this._sdInput = new SdInput(_width-_label_width,_height, _input_font_size);
			this.addChild(this._sdInput);
			this._sdInput.text = _input_default_text;
			this._sdInput.x = this._sdLabel.x + this._sdLabel.width;
		}
		
		/*设置文本*/
		public function get text():String{
			if(this._sdInput!=null)
				return this._sdInput.text;
			else
				return "";
		}
		
		/*设置文本*/
		public function set text(v:String):void{
			if(this._sdInput!=null)
			{
				this._sdInput.text = v;
			}
		}
	}
}
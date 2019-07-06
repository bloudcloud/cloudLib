package clapboardCode.sdObject
{
	import flash.display.Sprite;

	public class SdDBtn extends Sprite
	{
		private var _width:int=200;
		private var _height:int=200;
		public function SdDBtn(width:int,height:int,type:int)
		{
			_width=width;
			_height=height;
			this.mouseChildren=false;
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			createBtn(type);
		}
		private function createBtn(index:int):void{
			if(index==0)closeBtn();
			if(index==1)leftBtn();
			if(index==2)rightBtn();
		}
		private function closeBtn():void{
			var num:int=_width/4;
			this.graphics.lineStyle(2);
			this.graphics.moveTo(num,num);
			this.graphics.lineTo(_width-num,_height-num);
			this.graphics.moveTo(_width-num,num);
			this.graphics.lineTo(num,_height-num);
		}
		private function leftBtn():void{
			var num:int=_width/4;
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawCircle(_width/2,_width/2,_width/2);
			this.graphics.endFill();
			
			this.graphics.lineStyle(4);
			this.graphics.moveTo(num,_width/2);
			this.graphics.lineTo(_width-num,_width/2);
			this.graphics.moveTo(num*2,_width/2-num);
			this.graphics.lineTo(num,_width/2);
			this.graphics.lineTo(num*2,_width/2+num);
		}
		private function rightBtn():void{
			var num:int=_width/4;
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawCircle(_width/2,_width/2,_width/2);
			this.graphics.endFill();
			
			this.graphics.lineStyle(4);
			this.graphics.moveTo(num,_width/2);
			this.graphics.lineTo(_width-num,_width/2);
			this.graphics.moveTo(_width-num*2,_width/2-num);
			this.graphics.lineTo(_width-num,_width/2);
			this.graphics.lineTo(_width-num*2,_width/2+num);
		}
	}
}
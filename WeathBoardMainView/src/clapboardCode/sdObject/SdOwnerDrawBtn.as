package clapboardCode.sdObject
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import model.geom.MyMath;

	public class SdOwnerDrawBtn
	{
		public function SdOwnerDrawBtn()
		{
		}
		
		public static function createEnterButton(w:int,h:int):Sprite
		{
			var s:Sprite = new Sprite();
			s.mouseChildren = false;
			s.graphics.beginFill(0x00);
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();
			
			var f:Function = function(color:uint):void
			{
				s.graphics.lineStyle(2,color,1);
				s.graphics.moveTo(w-8,5);
				s.graphics.lineTo(w-8,h-8);
				s.graphics.lineTo(6,h-8);
				
				drawFillTriangle(new Point(6,h-8), new Vector3D(1,0,0), 
					45,8, s.graphics);
			};
			
			//鼠标事件处理
			var evt_f:Function=function(evt:MouseEvent):void
			{
				if(evt.type == MouseEvent.MOUSE_OVER)f(0xf9db4a);
				else f(0xffffff);
			}
			
			f(0xffffff);
			
			s.addEventListener(MouseEvent.MOUSE_OVER, evt_f);
			s.addEventListener(MouseEvent.MOUSE_OUT, evt_f);
			
			return s;
		}
		
		private static function drawFillTriangle(pt:Point, v:Vector3D, ang:Number,
										  h:Number,
										  gfx:Graphics):void
		{
			var mat1:Matrix3D = MyMath.createMatrixRotate(ang, pt);
			var mat2:Matrix3D = MyMath.createMatrixRotate(360-ang, pt);
			
			var vp:Vector3D = new Vector3D(pt.x+v.x*h, pt.y+v.y*h,0);
			var vp1:Vector3D = mat1.transformVector(vp);
			var vp2:Vector3D = mat2.transformVector(vp);
			
			gfx.moveTo(pt.x, pt.y);
			gfx.lineTo(vp1.x, vp1.y);
			gfx.moveTo(vp2.x, vp2.y);
			gfx.lineTo(pt.x, pt.y);
		}
	}
}
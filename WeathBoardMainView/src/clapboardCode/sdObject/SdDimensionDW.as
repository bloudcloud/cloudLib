package clapboardCode.sdObject
{
	import flash.display.Graphics;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	import model.geom.MyMath;
	
	public class SdDimensionDW 
	{
		protected var _pt1:Point=new Point();
		protected var _pt2:Point=new Point();
		protected var _pt3:Point=new Point();
		protected var _text:String = "";
		
		protected var _pt4:Point=new Point();
		protected var _tri_len:Number = 5;
		
		public function SdDimensionDW()
		{
			super();
		}
		
				
		private function drawFillTriangle(pt:Point, v:Vector3D, ang:Number,
										  h:Number,
										  gfx:Graphics):void
		{
			var mat1:Matrix3D = MyMath.createMatrixRotate(ang, pt);
			var mat2:Matrix3D = MyMath.createMatrixRotate(360-ang, pt);
			
			var vp:Vector3D = new Vector3D(pt.x+v.x*h, pt.y+v.y*h,0);
			var vp1:Vector3D = mat1.transformVector(vp);
			var vp2:Vector3D = mat2.transformVector(vp);
			
			gfx.lineStyle(1);
			gfx.beginFill(0x00);
			gfx.moveTo(pt.x, pt.y);
			gfx.lineTo(vp1.x, vp1.y);
			gfx.lineTo(vp2.x, vp2.y);
			gfx.lineTo(pt.x, pt.y);
			gfx.endFill();
		}
		
		protected function initText(value:String, fz:int, bw:int=4):TextField
		{
			var tf:TextField=new TextField();
			var fmt:TextFormat=new TextFormat("Microsoft YaHei",fz,0x00,"ture");
			tf.defaultTextFormat=fmt;
			if(value)
				tf.text=value;
			tf.width=tf.textWidth+bw;
			tf.height=tf.textHeight+bw;
			return tf;
		}
		
		protected function onDrawText(ui:UIComponent):void
		{
			var v:Vector3D = new Vector3D(_pt4.x-_pt3.x, _pt4.y-_pt3.y,0);
			var len : Number = v.length;
			v.normalize();
			
			var v1:Vector3D = new Vector3D(_pt2.x-_pt1.x, _pt2.y-_pt1.y,0);
			v1.normalize();
			
			var tf:TextField = initText(_text, 15);
			ui.addChild(tf);

			var cp:Vector3D = new Vector3D(_pt3.x + v.x * len / 2, _pt3.y + v.y * len / 2);
			tf.background=true;
			tf.backgroundColor = 0xffffff;
			//tf.type = TextFieldType.INPUT;
			
			var transMat:Matrix3D = new Matrix3D();
			transMat.appendTranslation(cp.x  - tf.width / 2,cp.y - tf.height / 2,0);
			
		/*	if(!v.nearEquals(Vector3D.X_AXIS,1e-6))
			{
				var mat:Matrix3D = new Matrix3D();
				
				var vt :Vector3D = new Vector3D(_pt3.x-_pt1.x, _pt3.y-_pt1.y);
				vt.normalize();
				
				var vd:Vector3D = MyMath.projectToXAxis(vt);
				
				var ang:Number = MyMath.angleTo(vd,v)*180/Math.PI;
				
				mat.appendRotation(ang, Vector3D.Z_AXIS, cp);
				
				transMat.append(mat);
			}*/
			
			tf.transform.matrix3D = transMat;
		}
		
		public function drawDimension(ui:UIComponent):void
		{
			onDraw(ui.graphics);
			onDrawText(ui);
		}
		
		public function onDraw(gfx:Graphics):void
		{
			var v:Vector3D = new Vector3D(_pt3.x-_pt1.x, _pt3.y-_pt1.y);
			_pt4.x = _pt2.x + v.x; _pt4.y = _pt2.y + v.y;
			
			if(Math.abs(v.x)){
				if(v.x < 0){
					gfx.lineStyle(1);
					//			gfx.moveTo(_pt1.x,_pt1.y);
					gfx.moveTo(_pt3.x + 10,_pt3.y);
					gfx.lineTo(_pt3.x,_pt3.y);
					gfx.lineTo(_pt4.x,_pt4.y);
					//			gfx.lineTo(_pt2.x,_pt2.y);
					gfx.lineTo(_pt4.x + 10,_pt4.y);
				}
				else if(v.x > 0){
					gfx.lineStyle(1);
					//			gfx.moveTo(_pt1.x,_pt1.y);
					gfx.moveTo(_pt3.x - 10,_pt3.y);
					gfx.lineTo(_pt3.x,_pt3.y);
					gfx.lineTo(_pt4.x,_pt4.y);
					//			gfx.lineTo(_pt2.x,_pt2.y);
					gfx.lineTo(_pt4.x - 10,_pt4.y);
				}

			}
			else if(Math.abs(v.y)){
				if(v.y < 0){
					gfx.lineStyle(1);
					gfx.moveTo(_pt3.x,_pt3.y + 10);
					gfx.lineTo(_pt3.x,_pt3.y);
					gfx.lineTo(_pt4.x,_pt4.y);
					gfx.lineTo(_pt4.x,_pt4.y + 10);				
				}
				else if(v.y > 0){
					gfx.lineStyle(1);
					gfx.moveTo(_pt3.x,_pt3.y - 10);
					gfx.lineTo(_pt3.x,_pt3.y);
					gfx.lineTo(_pt4.x,_pt4.y);
					gfx.lineTo(_pt4.x,_pt4.y - 10);	
				}


			}

			
			var tri_len:Number = 1;
			var vd:Vector3D = new Vector3D(_pt4.x-_pt3.x,_pt4.y-_pt3.y);
			vd.normalize();
			
			drawFillTriangle(_pt3, vd, 15, 8,gfx);
			
			vd.negate();
			drawFillTriangle(_pt4, vd, 15, 8,gfx);
			
		}

		public function get pt1():Point
		{
			return _pt1;
		}

		public function set pt1(value:Point):void
		{
			_pt1 = value;
		}

		public function get pt2():Point
		{
			return _pt2;
		}

		public function set pt2(value:Point):void
		{
			_pt2 = value;
		}

		public function get pt3():Point
		{
			return _pt3;
		}

		public function set pt3(value:Point):void
		{
			_pt3 = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}


	}
}
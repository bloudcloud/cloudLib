package utils.extend
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import mx.states.OverrideBase;

	use namespace alternativa3d;
	public class FreeCameraCtrl extends Plane
	{
		
		[Bindable] 
		[Embed(source="assets/images/camera.png")]     
		public var imageClass:Class;
		
		private var _bitmap:Bitmap;
		private var _camera:Camera3D = null;
		private static var _fov:Number = Math.PI/2;
		public  var _control:Object;
		public  var m_bMoveOrRotate:int = 0;
		
		public  var m_vPoint3D:Vector3D = new Vector3D(0,0,100);
		public var m_sphere:GeoSphere = new GeoSphere(8, 6, false, new FillMaterial(0xFF0000, 1));	
		
		public function FreeCameraCtrl(root:Object)
		{	
			this.z = 500;
			_bitmap = new imageClass() as Bitmap;
			var texture:BitmapTextureResource = new BitmapTextureResource(_bitmap.bitmapData);
			var material:TextureMaterial = new TextureMaterial(texture);
			material.alphaThreshold = 1;
			super(_bitmap.width, _bitmap.height, 1, 1, false, false, null, material);
			
			this.mouseChildren = false;
			
			m_vPoint3D.x = -_bitmap.width/2+20;
			// 添加三角区
			var triangle:IsoscelesTriangle = new IsoscelesTriangle(_fov, 150, new FillMaterial(0x111111, 0.3));
			triangle.x = -76;
			this.addChild(triangle);
			
			this.useHandCursor = true;
			
			_control = root;
			
			m_sphere.mouseEnabled = false;			//2D 绘制参考点
			m_sphere.name = "1";
			m_sphere.visible= false;
		//	_control.m_A3D.m_RenderScene.addChild(m_sphere);			
		}
		
		public function OnMouseDown( iMouseX:int, iMouseY:int ):void
		{
			m_bMoveOrRotate = 0;
			var localOrigin:Vector3D = new Vector3D();
			var localDirection:Vector3D = new Vector3D();
			
			_control.m_A3D.m_Camera.calculateRay(localOrigin, localDirection, iMouseX, iMouseY);
			
			var obj:Object3D  = this.clone();
			obj.composeTransforms();
			//append parents matrices
			var root:Object3D = obj;
			while (root.parent != null) {
				root = root.parent;
				root.composeTransforms();
				obj.transform.append(root.transform);
			}
			//do invert matrix, to translate ray in object local space
			obj.transform.invert();
			var ox:Number = localOrigin.x;
			var oy:Number = localOrigin.y;
			var oz:Number = localOrigin.z;
			var dx:Number = localDirection.x;
			var dy:Number = localDirection.y;
			var dz:Number = localDirection.z;
			//translate center of ray in local space
			localOrigin.x = obj.transform.a * ox + obj.transform.b * oy + obj.transform.c * oz + obj.transform.d;
			localOrigin.y = obj.transform.e * ox + obj.transform.f * oy + obj.transform.g * oz + obj.transform.h;
			localOrigin.z = obj.transform.i * ox + obj.transform.j * oy + obj.transform.k * oz + obj.transform.l;
			//translate direction of ray in local space
			localDirection.x = obj.transform.a * dx + obj.transform.b * dy + obj.transform.c * dz;
			localDirection.y = obj.transform.e * dx + obj.transform.f * dy + obj.transform.g * dz;
			localDirection.z = obj.transform.i * dx + obj.transform.j * dy + obj.transform.k * dz;
			
			var data:RayIntersectionData = this.intersectRay(localOrigin, localDirection);
			if (data) {
				
				if( data.point.x < 74 )
					m_bMoveOrRotate	 = 1;
				else
					m_bMoveOrRotate  = 2;	// 旋转
			}					
		}
		
		public function OnMouseMove( posX:int, posY:int, iMouseX:int, iMouseY:int ):void
		{
			if( m_bMoveOrRotate == 1 )
			{
				this.x   += posX;
				this.y   -= posY;			
			}
			else if( m_bMoveOrRotate == 2 )
			{
				var edge1:Vector3D = new Vector3D;
				edge1.x = iMouseX - this.x;				// 旋转弧度
				edge1.y = iMouseY - this.y;	
								
				this.rotationZ = -Math.atan2(edge1.x, edge1.y)+ 90*Math.PI/180;
			}
			var vPoint:Vector3D = this.matrix.transformVector(m_vPoint3D);
			m_sphere.x = vPoint.x;
			m_sphere.y = vPoint.y;
			m_sphere.z = 100;
		}
		
		public function OnMouseUP():void
		{
			this.m_bMoveOrRotate = 0;
		}
	
	}
}
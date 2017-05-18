package com.engine
{
	import com.greensock.TweenLite;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.textures.PlanarReflectionTexture;

	public class AwayEngine
	{
		private static var reflect:PlanarReflectionTexture;
		public static var moveVec:Vector3D;
		public static var moveSpd:int = 10;
		public static var isPlaySelf:Boolean;
		public static var cameraData:Object;
		
		private static var _camera:Camera3D;
		private static var _loopFuncs:Vector.<Object> = new Vector.<Object>(100);
		private static var _loopNums:int;
		
		public static function addReflect(r:PlanarReflectionTexture):void{
			reflect = r;
		}
		
		public static function get senceHeight():int
		{
			return nativeStage.stageHeight;
		}
		public static function get senceWidth():int
		{
			return nativeStage.stageWidth;
		}
		
		private static var _view3D:View3D;

		public static function get view3D():View3D
		{
			return _view3D;
		}
		/**
		 * 返回初始摄像机 
		 * @return Camera3D
		 * 
		 */		
		public static function get camera():Camera3D{
			return _camera;
		}
		/**
		 * 返回当前应用的摄像机 
		 * @return Camera3D
		 * 
		 */		
		public static function get curCamera():Camera3D
		{
			return _view3D.camera;
		}
		public static function addMesh(obj:ObjectContainer3D):void{
			_view3D.scene.addChild(obj);
		}
		
		public static function removeMesh(obj:ObjectContainer3D):void{
			if(obj.parent != null){
				obj.parent.removeChild(obj);
			}
		}
		
		private static var _lightPicker:StaticLightPicker;
		public static function get lightPicker():StaticLightPicker
		{
			if(_lightPicker == null)createPicker();
			return _lightPicker;
		}

		private static var lightList:Array;
		public static function addLight(light:LightBase):void{
			if(_lightPicker == null)createPicker();
			lightList.push(light);
			addMesh(light);
			_lightPicker.lights = lightList;
		}
		
		public static function removeLight(light:LightBase):void{
			if(lightList == null)return;
			var index:int = lightList.indexOf(light);
			if(index >= 0){
				lightList.splice(index,1);
				_lightPicker.lights = lightList;
				removeMesh(light);
			}
		}
		
		private static function createPicker():void{
			lightList = [];
			_lightPicker = new StaticLightPicker(lightList);
		}
		
		private static var _cameraController:*;//360全景展示相机控制器
		public static var nativeStage:flash.display.Stage;
//		private static var starlingStage:starling.display.Stage;
		
		private static var lastPanAngle:Number;
		private static var lastTiltAngle:Number;
		private static var lastMouseX:Number;
		private static var lastMouseY:Number;
		private static var move:Boolean;
		
		public static function createViews(s:flash.display.Stage,/*ss:starling.display.Stage,*/
										  anti:int = 4,canUpdate:Boolean = true):View3D
		{
			nativeStage = s;
//			starlingStage = ss;
			initView(anti);
//			_view3D.camera = new StereoCamera3D(new PerspectiveLens(45));
			_camera = _view3D.camera;
			//广角镜头
			_camera.lens = new PerspectiveLens(45);
			cameraEnabled = true;
			if(canUpdate)
				s.addEventListener(Event.ENTER_FRAME, onUpdate);
			nativeStage.scaleMode = StageScaleMode.NO_SCALE;
			nativeStage.align = StageAlign.TOP_LEFT;
			return _view3D;
		}
		
		private static var _cameraEnabled:Boolean;
		public static function set cameraEnabled(value:Boolean):void{
			_cameraEnabled = value;
			if(value){
//				starlingStage.addEventListener(TouchEvent.TOUCH,stageTouch);
				_view3D.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				_view3D.addEventListener(MouseEvent.MOUSE_DOWN,stageTouch);
				_view3D.addEventListener(MouseEvent.MOUSE_UP,stageTouch);
				_view3D.addEventListener(Event.MOUSE_LEAVE,stageTouch);
				_view3D.addEventListener(Event.RESIZE, onResize);
			}else{
//				starlingStage.removeEventListener(TouchEvent.TOUCH,stageTouch);
				_view3D.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				_view3D.removeEventListener(MouseEvent.MOUSE_DOWN,stageTouch);
				_view3D.removeEventListener(MouseEvent.MOUSE_UP,stageTouch);
				_view3D.removeEventListener(Event.MOUSE_LEAVE,stageTouch);
				_view3D.removeEventListener(Event.RESIZE, onResize);
				onMouseUp();
			}
		}
		
		public static function stageTouch(e:Event):void
		{
//			var touch:Touch = e.getTouch(starlingStage);
//			if(touch)
//			{
				switch(e.type/*touch.phase*/)
				{
					case MouseEvent.MOUSE_DOWN:
						if(!(e as MouseEvent).ctrlKey && !(e as MouseEvent).altKey && !(e as MouseEvent).shiftKey)
							onMouseDown();
						break;
					case Event.MOUSE_LEAVE:
					case MouseEvent.MOUSE_UP:
						onMouseUp();
						break;
				}
//			}
		}
		
		public static function addResize(func:Function):void{
			nativeStage.addEventListener(Event.RESIZE, func);
		}
		public static function removeResize(func:Function):void{
			nativeStage.removeEventListener(Event.RESIZE, func);
		}
		
		/**
		 * 侦听舞台尺寸改变事件
		 */
		private static function onResize(event:Event = null):void
		{
			_view3D.width = nativeStage.stageWidth;
			_view3D.height = nativeStage.stageHeight;
			if(_stats != null)_stats.x = _stats.y = 0;
		}
		
		private static var _stats:AwayStats;//调试窗口
		public static function set showStats(value:Boolean):void{
			if(value){
				if(_stats == null)_stats = new AwayStats(_view3D);
				_stats.x = _view3D.parent.x;
				_stats.y = _view3D.parent.y;
				_stats.z = _view3D.parent.z;
				nativeStage.addChild(_stats);
			}else{
				if(_stats != null)nativeStage.removeChild(_stats);
			}
		}
		
		/**
		 * 鼠标按下事件
		 */
		private static function onMouseDown():void
		{
			if(_cameraController == null || !_cameraEnabled)return;//不能交互
//			trace('触发触摸舞台');
			lastPanAngle = _cameraController.panAngle;
			lastTiltAngle = _cameraController.tiltAngle;
			lastMouseX = nativeStage.mouseX;
			lastMouseY = nativeStage.mouseY;
			move = true;
		}
		
		/**
		 * 鼠标弹起事件
		 */
		private static function onMouseUp():void
		{
			move = false;
		}
		
		private static var _perDistance:Number = 50;//放大镜移动的距离
		public static function get perDistance():Number
		{
			return _perDistance;
		}
		public static function set perDistance(value:Number):void
		{
			_perDistance = value;
		}
		
		private static function onWheel(e:MouseEvent):void
		{
			if(e.delta > 0){
				zoomCamera(false);
			}else{
				zoomCamera(true);
			}
		}
		/**
		 * 让相机临时停止旋转
		 */		
		public static function stopCamera():void{
			move = false;
		}
		
		public static function zoomCamera(isLarge:Boolean = false):void{
//			if(cameraController is FirstPersonController)
//			{
//				if(isLarge)
//				{
//					(cameraController as FirstPersonController).fly = true;
//					(cameraController as FirstPersonController).incrementWalk(_perDistance);
////					(cameraController as FirstPersonController).fly = false;
//				}
//				else
//				{
//					(cameraController as FirstPersonController).fly = true;
//					(cameraController as FirstPersonController).incrementWalk(-_perDistance);
////					(cameraController as FirstPersonController).fly = false;
//				}
//			}
			if(cameraController is HoverController)
			{
				var zoomDis:Number;
				if(isLarge)
				{
					zoomDis = _cameraController.distance + _perDistance > maxDistance ? maxDistance : _cameraController.distance+_perDistance;
					
					if(_cameraController.distance < maxDistance-0.01)
						TweenLite.to(_cameraController,.5,
							{distance:zoomDis});
				}
				else
				{
					zoomDis = _cameraController.distance-_perDistance < minDistance ? minDistance : _cameraController.distance-_perDistance;
					if(_cameraController.distance > minDistance+0.01)
						TweenLite.to(_cameraController,.5,
							{distance:zoomDis});
				}
				trace("distance:",_cameraController.distance+_perDistance);
			}
		}
		
		private static function initView(anti:int):void
		{
			if(_view3D == null) _view3D = new View3D();
			_view3D.antiAlias = anti;
			_view3D.backgroundColor = 0;
			_view3D.backgroundAlpha = 0;
		}
		
		private static function initCamera(freedom:Boolean,camera:Camera3D):void
		{
			if(_cameraController) return;
			if(freedom)
			{
				_cameraController = new FirstPersonController(camera);
				_cameraController.fly = true;
			}
			else
			{
				_cameraController = new HoverController(camera);
			}
		}
		
		private static var minDistance:Number;
		private static var maxDistance:Number;
		public static function setCamera(freedom:Boolean,minDis:Number,maxDis:Number,
				minTiltAngle:Number = -90,maxTiltAngle:Number = 90,
				panAngle:Number = 0,tiltAngle:Number = 0):void{
			minDistance = minDis;
			maxDistance = maxDis;
//			trace(_view3D.camera.position);
			_view3D.camera.x = 36;
			_view3D.camera.y = 526;
			_view3D.camera.z = 668;
			initCamera(freedom,_view3D.camera);
			_cameraController.steps = 6;
			if(_cameraController is HoverController)
				_cameraController.distance = (maxDis + minDis) / 2;//摄像机和目标点距离
			_cameraController.minTiltAngle = minTiltAngle;//摄像机以Y轴旋转最小角度
			_cameraController.maxTiltAngle = maxTiltAngle;//摄像机以Y轴旋转最大角度
			_cameraController.panAngle = panAngle;//摄像机以Y轴旋转角度
			_cameraController.tiltAngle = tiltAngle;//摄像机以X轴旋转角度
			_cameraController.autoUpdate = false;
//			_view3D.camera.bounds./
		}
		
		public static function onUpdate(event:Event = null):void
		{
			// 渲染3D世界
//			var start:Number = getTimer();
			for (var i:int=0; i < _loopNums; i++) 
			{
				(_loopFuncs[i].handle as Function).apply(null,_loopFuncs[i].param);
			}
			if (move) {
				_cameraController.panAngle = 0.3 * (nativeStage.mouseX - lastMouseX) + lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (nativeStage.mouseY - lastMouseY) + lastTiltAngle;
			}
//			if(_camera.y < 0)
//				_camera.y = 0;
			if(reflect != null){
				if(_cameraController != null)_cameraController.update();
				reflect.render(_view3D);
			}
			_cameraController.update();
			_view3D.render();
			
//			trace("3drender:",getTimer() - start);
		}
		
		public static function addLoop(handler:Function,...params):void{
			var obj:Object = new Object();
			obj.handle = handler;
			obj.param = params;
			if(_loopNums == _loopFuncs.length)
			{
				_loopFuncs.length = _loopNums+100;
			}
			_loopFuncs[_loopNums++] = obj;
//			nativeStage.addEventListener(Event.ENTER_FRAME,loopHandler);
		}
		public static function removeLoop(handler:Function):void{
			for(var i:String in _loopFuncs)
			{
				if(_loopFuncs[i].handle == handler)
				{
					_loopFuncs.splice(int(i),1);
					_loopNums--;
					break;
				}
			}
//			nativeStage.removeEventListener(Event.ENTER_FRAME,handler);
		}
		public static function control(handler:Function):void{
			nativeStage.addEventListener(MouseEvent.CLICK,handler);
		}

		public static function get cameraController():*
		{
			return _cameraController;
		}
		
		public static function set filters3D(value:Array):void
		{
			_view3D.filters3d = value;
		}
	}
}
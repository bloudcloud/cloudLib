package com.cloud.c3d.entityEngine.entities
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import com.cloud.c3d.utils.EventManager;

	/**
	 * ClassName: package entity::GameCamera
	 *
	 * Intro: 游戏摄像机
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	
	
	public final class GameCamera extends GameEntity
	{
		private const _AddZSpdVec:Vector3D = new Vector3D(0,0,10);
		private const _MinZSpdVec:Vector3D = new Vector3D(0,0,-10);
		private const _AddXSpdVec:Vector3D = new Vector3D(10,0,0);
		private const _MinXSpdVec:Vector3D = new Vector3D(-10,0,0);
		
		private var _view3d:View3D;
		private var _camera:Camera3D;
		private var _cameraController:HoverController;
		private var _cameraEnabled:Boolean;
		private var _move:Boolean;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _maxDistance:Number;
		private var _minDistance:Number;
		private var _keyDic:Dictionary;
		
		public function get cameraEnabled():Boolean
		{
			return _cameraEnabled;
		}
		public function set cameraEnabled(value:Boolean):void
		{
			_cameraEnabled = value;
			if(value)
			{
				EventManager.instance.addListener(_view3d,MouseEvent.MOUSE_DOWN,stageTouch);
				EventManager.instance.addListener(_view3d,MouseEvent.MOUSE_UP,stageTouch);
				EventManager.instance.addListener(_view3d,Event.MOUSE_LEAVE,stageTouch);
				EventManager.instance.addListener(_view3d,MouseEvent.MOUSE_WHEEL,onMouseWheel);
				EventManager.instance.addListener(_view3d.stage,KeyboardEvent.KEY_DOWN,keyBoardHandler);
				EventManager.instance.addListener(_view3d.stage,KeyboardEvent.KEY_UP,keyBoardHandler);
			}
			else
			{
				EventManager.instance.removeListener(_view3d,MouseEvent.MOUSE_DOWN,stageTouch);
				EventManager.instance.removeListener(_view3d,MouseEvent.MOUSE_UP,stageTouch);
				EventManager.instance.removeListener(_view3d,Event.MOUSE_LEAVE,stageTouch);
				EventManager.instance.removeListener(_view3d,MouseEvent.MOUSE_WHEEL,onMouseWheel);
				EventManager.instance.removeListener(_view3d.stage,KeyboardEvent.KEY_DOWN,keyBoardHandler);
				EventManager.instance.removeListener(_view3d.stage,KeyboardEvent.KEY_UP,keyBoardHandler);
			}
		}
		
		private var _perDistance:Number = 100;//放大镜移动的距离
		public function get perDistance():Number
		{
			return _perDistance;
		}

		public function GameCamera(view3d:View3D)
		{
			super();
			_view3d = view3d;
			_camera = _view3d.camera;
			(_camera.lens as PerspectiveLens).fieldOfView = 45;
			_keyDic = new Dictionary();
			
			cameraEnabled = true;
			setCamera(100,2000);
			
		}
		
		private function onMouseWheel(evt:MouseEvent):void
		{
			var zoomDis:Number;
			if(evt.delta > 0)
			{
				zoomDis = _cameraController.distance-_perDistance < _minDistance ? _minDistance : _cameraController.distance-_perDistance;
				if(_cameraController.distance > _minDistance+0.01)
					TweenLite.to(_cameraController,.5,
						{distance:zoomDis});
				trace("distance:",_cameraController.distance+_perDistance);
			}
			else
			{
				zoomDis = _cameraController.distance + _perDistance > _maxDistance ? _maxDistance : _cameraController.distance+_perDistance;
				
				if(_cameraController.distance < _maxDistance-0.01)
					TweenLite.to(_cameraController,.5,
						{distance:zoomDis});
				trace("distance:",_cameraController.distance+_perDistance);
			}
		}
		private function stageTouch(evt:Event):void
		{
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if(!(evt as MouseEvent).ctrlKey && !(evt as MouseEvent).altKey && 
						!(evt as MouseEvent).shiftKey && _cameraController && _cameraEnabled)
					{
						_lastPanAngle = _cameraController.panAngle;
						_lastTiltAngle = _cameraController.tiltAngle;
						_lastMouseX = _view3d.mouseX;
						_lastMouseY = _view3d.mouseY;
						_move = true;
					}
					break;
				case Event.MOUSE_LEAVE:
				case MouseEvent.MOUSE_UP:
					_move = false;
					break;
			}
		}
		private function keyBoardHandler(evt:KeyboardEvent):void
		{
			switch(evt.type)
			{
				case KeyboardEvent.KEY_DOWN:
					_keyDic[evt.keyCode] = true;
					break;
				case KeyboardEvent.KEY_UP:
					_keyDic[evt.keyCode] = false;
					break;
			}
		}
		
		public function setCamera(minDis:Number,maxDis:Number
								  ,minTiltAngle:Number = -90,maxTiltAngle:Number = 90
								   ,panAngle:Number = 180,tiltAngle:Number = 20):void
		{
			_minDistance = minDis;
			_maxDistance = maxDis;
//			_view3d.camera.x = 36;
//			_view3d.camera.y = 526;
//			_view3d.camera.z = 668;
			_cameraController = new HoverController(_camera);
			_cameraController.steps = 8;
			_cameraController.distance = (maxDis + minDis) / 2;//摄像机和目标点距离
			_cameraController.minTiltAngle = minTiltAngle;//摄像机以Y轴旋转最小角度
			_cameraController.maxTiltAngle = maxTiltAngle;//摄像机以Y轴旋转最大角度
			_cameraController.panAngle = panAngle;//摄像机以Y轴旋转角度
			_cameraController.tiltAngle = tiltAngle;//摄像机以X轴旋转角度
			_cameraController.autoUpdate = true;
		}

		override public function update():void
		{
			if (_move) {
				_cameraController.panAngle = 0.3 * (_view3d.stage.mouseX - _lastMouseX) + _lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (_view3d.stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
			
			if(_keyDic[Keyboard.W])
			{
				_cameraController.lookAtPosition = _cameraController.lookAtPosition.subtract(_AddZSpdVec);
			}
			else if(_keyDic[Keyboard.S])
			{
				_cameraController.lookAtPosition = _cameraController.lookAtPosition.subtract(_MinZSpdVec);
			}
			if(_keyDic[Keyboard.A])
			{
				_cameraController.lookAtPosition = _cameraController.lookAtPosition.subtract(_AddXSpdVec);
			}
			else if(_keyDic[Keyboard.D])
			{
				_cameraController.lookAtPosition = _cameraController.lookAtPosition.subtract(_MinXSpdVec);
			}
			
			_cameraController.update();

		}
	}
}
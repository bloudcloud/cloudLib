package com.cloud.c3d.entityEngine.entities
{
	/**
	 * ClassName: package entity::GameEntity
	 *
	 * Intro:
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	import com.cloud.c3d.entityEngine.core.Entity;
	
	import flash.geom.Vector3D;
	
	public class GameEntity extends Entity
	{
		protected var _position:Vector3D;
		protected var _rotation:Vector3D;
		
		public function get x():Number
		{
			return _position.x;
		}
		public function set x(value:Number):void
		{
			_position.x = value;
		}
		public function get y():Number
		{
			return _position.y;
		}
		public function set y(value:Number):void
		{
			_position.y = value;
		}
		public function get z():Number
		{
			return _position.z;
		}
		public function set z(value:Number):void
		{
			_position.z = value;
		}
		public function get rotationX():Number
		{
			return _rotation.x;
		}
		public function set rotationX(value:Number):void
		{
			_rotation.x = value;
		}
		public function get rotationY():Number
		{
			return _rotation.y;
		}
		public function set rotationY(value:Number):void
		{
			_rotation.y = value;
		}
		public function get rotationZ():Number
		{
			return _rotation.z;
		}
		public function set rotationZ(value:Number):void
		{
			_rotation.z = value;
		}
		
		
		public function GameEntity()
		{
			super();
		}
	}
}
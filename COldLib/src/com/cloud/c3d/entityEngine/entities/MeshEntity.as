package com.cloud.c3d.entityEngine.entities
{
	import away3d.entities.Mesh;

	/**
	 * ClassName: package entity::MeshEntity
	 *
	 * Intro:
	 *
	 * @date: 2014-8-7
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class MeshEntity extends GameEntity
	{
		protected var _meshID:uint;

		public function get meshID():uint
		{
			return _meshID;
		}

		
		protected var _mesh:Mesh;
		
		public function MeshEntity(mesh:Mesh)
		{
			super();
			_mesh = mesh;
			_meshID = 0;
			trace(this.toString());
		}

	}
}
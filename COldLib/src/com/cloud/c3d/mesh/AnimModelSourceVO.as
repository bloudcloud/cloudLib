package com.cloud.c3d.mesh
{
	import flash.utils.Dictionary;
	
	import away3d.entities.Mesh;

	/**
	 * ClassName: package com.cloud.c3d.mesh::AnimModelSourceVO
	 *
	 * Intro:	动作模型资源数据结构
	 *
	 * @date: 2014-4-4
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer13
	 * @sdkVersion: AIR13.0
	 */
	public final class AnimModelSourceVO
	{
		public var model:Mesh;
		public var partDics:Dictionary
		
		public function AnimModelSourceVO()
		{
			partDics = new Dictionary();
		}
	}
}
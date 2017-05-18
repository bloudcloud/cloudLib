package com.cloud.c2d.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;

	/**
	 * Classname : public class CButtonUtils
	 * 
	 * Date : 2013-9-11
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 
	 * 
	 */
	public class CButtonUtils
	{
		public function CButtonUtils()
		{
		}
		public static function forbiddenOrResume(target:InteractiveObject,bool:Boolean):void
		{
			if(bool)
			{
				target.filters = [];
				target.mouseEnabled = true;
				if(target is DisplayObjectContainer)
					(target as DisplayObjectContainer).mouseChildren = true;
			}
			else
			{
				target.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
				target.mouseEnabled = false;
				if(target is DisplayObjectContainer)
					(target as DisplayObjectContainer).mouseChildren = false;
			}
		}
	}
}
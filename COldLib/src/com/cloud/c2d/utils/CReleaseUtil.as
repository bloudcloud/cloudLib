package com.cloud.c2d.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * Classname : public class CReleaseUtil
	 * 
	 * Date : 2013-9-24
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 释放资源
	 * 
	 */
	public class CReleaseUtil
	{
		public function CReleaseUtil()
		{
		}
		/**
		 * 释放显示对象容器中的基本数据类型资源 
		 * @param container
		 * 
		 */		
		public static function disposeAllInContainer(container:DisplayObjectContainer):void
		{
			var num:int = container.numChildren;
			var target:DisplayObject;
			while(num--)
			{
				target = container.removeChildAt(0);
				if(target is MovieClip)
				{
					(target as MovieClip).stop();
					disposeAllInContainer(target as MovieClip);
				}
				else if(target is DisplayObjectContainer)
					disposeAllInContainer(target as DisplayObjectContainer);
				else if(target is Bitmap)
				{
					(target as Bitmap).bitmapData.dispose();
					(target as Bitmap).bitmapData = null;
				}
			}
		}
		/**
		 * 设置全部对象的鼠标监听状态 
		 * @param bool	是否响应鼠标监听
		 * @param container	容器
		 * 
		 */		
		public static function setBtnForbidden(bool:Boolean, container:DisplayObjectContainer):void
		{
			var num:int = container.numChildren;
			if(!num) return;
			var target:DisplayObject;
			while(num--)
			{
				target = container.getChildAt(num);
				if(target is InteractiveObject && !(target is TextField))
					(target as InteractiveObject).mouseEnabled = bool;
				if(target is DisplayObjectContainer)
				{
					setBtnForbidden(bool,target as DisplayObjectContainer);
				}
			}
		}
	}
}
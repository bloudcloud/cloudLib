package com.cloud.c2d.cBitmapEngine.elements
{
	/**
	 * Classname : public class CDisplayContainer implements IDisplay
	 * 
	 * Date : 2013-8-23
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	import com.cloud.c2d.cBitmapEngine.interfaces.IDisplay;
	
	import flash.events.IEventDispatcher;
	
	import org.superkaka.kakalib.struct.BitmapFrameInfo;
	
	/**
	 * 实现功能: 
	 * 
	 */
	public class CDisplayContainer extends CDisplay
	{
		/**
		 * 显示对象数组 
		 */		
		private var _viewArray:Array;
		protected var _numberChildren:int;
		protected var _mouseChildren:Boolean;
		
		public function CDisplayContainer($bitmapInfo:BitmapFrameInfo,$width:int,$height:int,$target:IEventDispatcher = null)
		{
			super($bitmapInfo,$width,$height,$target);
		}
		
		override public function render():void
		{
			
		}
		
		override public function dispose():void
		{
		}
	}
}
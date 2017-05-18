package com.cloud.c2d.utils.text.richText
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *  @author:Gaara
	 *  2012-10-30
	 *  表情加载器
	 **/
	public class FaceLoader extends Sprite
	{
		public function FaceLoader(width:int,height:int)
		{
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		/**
		 *  功能:加载
		 *  参数:
		 **/
		public function load(url:String,name:String = null):void
		{
			
			var iconSprite:Loader = new Loader;
			iconSprite.y = -5;
			iconSprite.load(new URLRequest(url));
			addChild(iconSprite);
			//add
//			iconSprite.loaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		private function onLoadComplete(evt:Event):void
		{
			evt.target.removeEventListener(Event.COMPLETE,onLoadComplete);
//			getQualifiedClassName(evt.target);
		}
		
	}
}
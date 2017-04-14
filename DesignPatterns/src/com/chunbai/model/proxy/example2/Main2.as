package com.chunbai.model.proxy.example2
{
	import flash.events.DataEvent;
	import flash.events.Event;
	
	/**
	 * 远程代理
	 * */
	public class Main2
	{
		public function Main2()
		{
			var flickr:PhotoSearchProxy = new PhotoSearchProxy();
			flickr.addEventListener(Event.COMPLETE, onComplete);
			flickr.search("", "yellow");
		}
		
		private function onComplete(event:DataEvent):void
		{
			trace(event.data);
		}
		
	}
}
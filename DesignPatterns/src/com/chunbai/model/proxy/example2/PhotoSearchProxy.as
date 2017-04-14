package com.chunbai.model.proxy.example2
{ 
	import flash.events.DataEvent; 
	import flash.events.Event; 
	import flash.events.EventDispatcher; 
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	
	public class PhotoSearchProxy extends EventDispatcher
	{ 
		private static const API_KEY:String="c4643072bfc38caa0257f4c039624cb5";    //这是我的Flickr Api_key 
		private static const FLICKR_URL:String="http://api.flickr.com/services/rest/";    //Flickr的api地址 
		
		public function PhotoSearchProxy()
		{
		    
		}
		
		private function onComplete(_evt:Event):void
		{ 
			dispatchEvent(new DataEvent(Event.COMPLETE, false, false, XML(_evt.target.data))); 
		}
		
		public function search(userId:String, tags:String):void
		{ 
			var loader:URLLoader = new URLLoader(); 
			var request:URLRequest = new URLRequest(PhotoSearchProxy.FLICKR_URL + "?method=flickr.photos.search&user_id=" + userId + "&tags=" + tags + "&api_key=" + PhotoSearchProxy.API_KEY); 
			loader.addEventListener(Event.COMPLETE, onComplete); 
			loader.load(request); 
		}
		
	} 
}
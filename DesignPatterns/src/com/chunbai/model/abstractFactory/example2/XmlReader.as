package com.chunbai.model.abstractFactory.example2
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * XML文件读取类
	 * */
	public class XmlReader
	{
		private var _xmlData:XML;
		private var _success:Boolean = false;
		
		public function XmlReader($url:String)
		{
			var urlLoader:URLLoader = new URLLoader(new URLRequest($url));
			urlLoader.addEventListener(Event.COMPLETE, xmlDataCompleteHandler);
		}
		
		private function xmlDataCompleteHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
		    _xmlData = XML(urlLoader.data);
			_success = true;
		}
		
		public function get xmlData():XML
		{
		    return _xmlData;
		}
		
		public function get success():Boolean
		{
		    return _success;
		}
		
	}
}
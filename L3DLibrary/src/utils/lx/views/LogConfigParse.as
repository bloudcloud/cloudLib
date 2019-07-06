package utils.lx.views
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import logs.Log;
	
	import utils.lx.consts.LogFlagCustom;
	import utils.lx.managers.GlobalManager;

	public class LogConfigParse
	{
		private var loader:URLLoader=new URLLoader();
		private var switchState:Boolean;
		private var preLogFlags:Array;
		private var logLevels:Array;
		private var logFlags:Array;
		private var debugTrackView:DebugTrackView;

		public function LogConfigParse(debugTrackView:DebugTrackView)
		{
			this.debugTrackView=debugTrackView;
		}

		private function load(url:String):void
		{
			if(url==null||url.length==0)
				return;
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,loadSecurityErrorHandler);
			loader.load(new URLRequest(url));
		}
		
		public function parse():void
		{
			var json:Object=LogFlagCustom.getLogConfig();
			switchState=json.switchState;
			preLogFlags=json.preLogFlags;
			logLevels=json.logLevels;
			logFlags=json.logFlags;
			
			var total:uint;
			for (var i:int=0; i < logLevels.length; i++)
			{
				total+=logLevels[i];
			}
			
			Log.presetLogFlags(preLogFlags);
			GlobalManager.log.setLogLevels(total);
			GlobalManager.log.setLogFlags(logFlags);
			if (switchState)
			{
				GlobalManager.log.on();
			}
			else
			{
				GlobalManager.log.off();
			}
			debugTrackView.resetBeforeInitModifyConfig();
			debugTrackView.initModifyConfig();
		}
		
		public function getLogLevels():Array
		{
			return logLevels.concat();
		}
		
		public function getLogFlags():Array
		{
			return logFlags.concat();
		}
		
		public function getPreLogFlags():Array
		{
			return preLogFlags.concat();
		}
		
		public function getSwitchState():Boolean
		{
			return switchState;
		}

		private function loadCompleteHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);

			var data:String=event.target.data;
			var json:Object=JSON.parse(data);
			switchState=json.switchState;
			preLogFlags=json.preLogFlags;
			logLevels=json.logLevels;
			logFlags=json.logFlags;

			var total:uint;
			for (var i:int=0; i < logLevels.length; i++)
			{
				total+=logLevels[i];
			}

			Log.presetLogFlags(preLogFlags);
			GlobalManager.log.setLogLevels(total);
			GlobalManager.log.setLogFlags(logFlags);
			if (switchState)
			{
				GlobalManager.log.on();
			}
			else
			{
				GlobalManager.log.off();
			}
			debugTrackView.resetBeforeInitModifyConfig();
			debugTrackView.initModifyConfig();
		}

		private function loadErrorHandler(event:IOErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
		}
		
		private function loadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
		}
	}
}
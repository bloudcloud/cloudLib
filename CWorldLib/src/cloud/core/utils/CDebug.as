package cloud.core.utils
{
	import flash.utils.getTimer;

	public class CDebug
	{
		private static var _instance:CDebug;
		
		private var _strs:Vector.<String>;
		
		public function CDebug()
		{
			_strs=new Vector.<String>();
		}
		
		public static function get instance():CDebug
		{
			_instance ||= new CDebug();
			return _instance;
		}
		
		public function traceStr(...param):void
		{
			var returnStr:String="";
			for (var i:int; i<param.length; i++)
			{
				if(param[i] is String || param[i] is Number)
					returnStr+=param[i]+" ";
				else
					returnStr+=param[i].toString()+" ";
			}
//			_strs.push(returnStr+=getTimer());
			trace(returnStr+=getTimer());
		}
		
		public function outPut():void
		{
			for each(var str:String in _strs)
			{
				trace(str);
			}
			_strs.length=0;
		}
	}
}
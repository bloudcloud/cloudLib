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
		/**
		 * 输出到控制台 
		 * @param param
		 * 
		 */		
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
		/**
		 * 抛出错误 
		 * @param className	错误发生的类名
		 * @param functionName	错误发生的方法名
		 * @param varName	错误发生的变量名
		 * @param message	错误内容
		 * 
		 */		
		public function throwError(className:String,functionName:String,varName:String,message:String):void
		{
			throw new Error(String(className+"->"+functionName+" "+varName+": "+varName+message+"\n"));
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
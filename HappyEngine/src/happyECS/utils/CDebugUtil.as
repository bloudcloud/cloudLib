package happyECS.utils
{
	import flash.utils.getTimer;
	
	import happyECS.ns.happy_ecs;
	
	use namespace happy_ecs;
	
	public class CDebugUtil
	{
		private static var _Instance:CDebugUtil;
		
		private var _strs:Vector.<String>;
		
		public function CDebugUtil()
		{
			_strs=new Vector.<String>();
		}
		
		happy_ecs static function get Instance():CDebugUtil
		{
			_Instance ||= new CDebugUtil();
			return _Instance;
		}
		/**
		 * 输出到控制台 
		 * @param param
		 * 
		 */		
		public function traceStr(...param):void
		{
			CONFIG::debug
			{
				var returnStr:String="";
				var len:int=param.length;
				for (var i:int; i<len; i++)
				{
					if(param[i] is String || param[i] is Number)
						returnStr+=param[i]+" ";
					else
						returnStr+=param[i].toString()+" ";
				}
				trace(returnStr+=getTimer());
			}
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
			CONFIG::debug
			{
				throw new Error(String(className+"->"+functionName+" "+varName+": "+message+"\n"));
			}
		}
	}
}
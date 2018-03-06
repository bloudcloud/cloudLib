package cloud.core.utils
{
	
	public class CDebugUtil
	{
		private static var _Instance:CDebugUtil;
		
		private var _strs:Vector.<String>;
		
		public function CDebugUtil(enforcer:SingletonEnforce)
		{
			_strs=new Vector.<String>();
		}
		
		public static function get Instance():CDebugUtil
		{
			_Instance ||= new CDebugUtil(new SingletonEnforce());
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
				for (var i:int; i<param.length; i++)
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
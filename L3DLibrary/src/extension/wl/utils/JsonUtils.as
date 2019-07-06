package extension.wl.utils
{
	import com.adobe.serialization.json.JSON;

	public class JsonUtils
	{
		public function JsonUtils()
		{
			
		}
		
		public static function getJsonObject(arg:String):Object
		{
			return com.adobe.serialization.json.JSON.decode(arg);
		}
		/**
		 * 数组转为json字符串
		 * @param arg
		 * @return 
		 * 
		 */		
		public static function getJsonString(arg:Array):String
		{
			return com.adobe.serialization.json.JSON.encode(arg);
		}
		
		/**
		 * 对象转为json字符串
		 * @param arg
		 * @return 
		 * 
		 */		
		public static function getObjectJsonString(arg:Object):String
		{
			return com.adobe.serialization.json.JSON.encode(arg);
		}
	}
}
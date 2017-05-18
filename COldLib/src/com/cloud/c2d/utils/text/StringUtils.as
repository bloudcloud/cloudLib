package com.cloud.c2d.utils.text
{
	/**
	 * Classname : public class StringUtils
	 * 
	 * Date : 2013-9-21
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 字符串工具类
	 * 
	 */
	public class StringUtils
	{
		public function StringUtils(){}
		/**
		 * 获取带参数文本 
		 * @param content		文本内容
		 * @param params		文本参数
		 * @return String
		 * 
		 */		
		public static function paramContent(content:String, ...args):String
		{
			var str:String;
			var arr:Array = content.split(/{\d}/);
			var length:int = args.length;
			var num:int = 0;
			for(var i:int = 0; i < length; i++)
			{
				arr[i] = arr[i].concat(args[num++]) ;
			}
			return arr.join("");
		}
		/**
		 * 消除字符串中的前后空格 
		 * @param str
		 * 
		 */		
		public static function trim(str:String):String
		{
			return str.replace(/^\s*|\s*$/g, "");
		}
	}
}
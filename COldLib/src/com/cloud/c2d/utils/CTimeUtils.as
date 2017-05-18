package com.cloud.c2d.utils
{
	/**
	 * Classname : public class CTimeUtils
	 * 
	 * Date : 2013-9-26
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 时间工具
	 * 
	 */
	public class CTimeUtils
	{
		private static var _instance:CTimeUtils;
		private var _timeFormat:String;							//间隔字符
		private var se:int;
		private var mi:int;
		private var ho:int;
		private var day:int;
		private var mo:int;
		private var yea:int;
		
		public function CTimeUtils(enforcer:SingletonEnforce)
		{
		}

		public static function get instance():CTimeUtils
		{
			if(!_instance)
				_instance = new CTimeUtils(new SingletonEnforce());
			return _instance;
		}

		/**
		 * 小时分钟秒 
		 * @param time
		 * @param timeFormat
		 * @return String
		 * 
		 */		
		public function hourMinuteSecondByStamp(time:int, $timeFormat:String):String
		{
			_timeFormat = $timeFormat;
			var remainNum:int;
			var str:String;
			var returnStr:String;
			ho = time / (1000*60*60) >> 0;
			remainNum = time % (1000 * 60 * 60);
			mi = remainNum / (1000 * 60) >> 0;
			remainNum = remainNum % (1000 * 60);
			se = remainNum / 1000 >> 0;
			return coverZero(2,ho,mi,se);
		}
		/**
		 * 年月日小时 
		 * @param date 日期
		 * @param $timeFormat	连接字符或数组
		 * @return String
		 * 
		 */		
		public function yearMonthDayHourByDate(date:Date, $timeFormat:*):String
		{
			_timeFormat = $timeFormat is Array ? "-":$timeFormat as String;
			var str:String;
			if($timeFormat is Array)
			{
				_timeFormat = "-";
				str = coverZero(2,date.fullYear,date.month+1,date.date,date.hours)+_timeFormat;
				var num:int = 0;
				var arr:Array = $timeFormat as Array;
				var reg:RegExp = new RegExp(_timeFormat,"g");
				str = str.replace(reg,function():String{return arr[num++];});
			}
			else 
			{
				_timeFormat = $timeFormat;
				str = coverZero(2,date.fullYear,date.month+1,date.date,date.hours);
			}
			return str;
		}
		/**
		 * 补位 
		 * @param digit 位数
		 * @param args 数值数组
		 * @return String
		 * 
		 */		
		private function coverZero(digit:int,...args):String
		{
			var arr:Array = new Array(args.length);
			for(var i:* in args)
			{
				var str:String = "";
				var length:int = args[i].toString().length;
				if(length < digit)
				{
					var num:int = digit - length;
					while(num--)
						str += "0";
				}
				str += args[i];
				arr[i] = str;
			}
			return arr.join(_timeFormat);
		}
	}
}
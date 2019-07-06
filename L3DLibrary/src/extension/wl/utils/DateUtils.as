package extension.wl.utils
{
	import mx.formatters.DateFormatter;

	public class DateUtils
	{
		public function DateUtils()
		{
		}
		
		/**
		 * 按照YYYY-MM-DD的形式返回当前时间
		 * @return String
		 * 
		 */		
		public static function getNowDate():String
		{
			var format:DateFormatter = new DateFormatter();
			format.formatString = "YYYY-MM-DD";
			return format.format(new Date());
		}
		
	}
}
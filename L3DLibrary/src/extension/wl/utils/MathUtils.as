package extension.wl.utils
{
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		/**
		 * 浮点数保留小数位数处理
		 * @param a 浮点数
		 * @param b 保留几位小数，默认值2
		 * @return a
		 * 
		 */		
		public static function fixed(a:Number,b:int=2):Number
		{
			return Number(a.toFixed(b));
		}
		
	}
}
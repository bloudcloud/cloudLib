package com.cloud.utils
{
	/**
	 * ClassName: package com.cloud.utils::NumberUtil
	 *
	 * Intro:
	 *
	 * @date: 2014-8-6
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public final class NumberUtil
	{
		/**
		 * 求二进制中1的个数 
		 * @param num	
		 * @return 
		 * 
		 */		
		public static function bitCount(num:uint):uint
		{
			num=(num&0x55555555)+((num>>1) & 0x555555555);
			num=(num&0x33333333)+((num>>2) & 0x333333333);
			num=(num&0x0f0f0f0f)+((num>>4) & 0x0f0f0f0f);
			num=(num&0x00ff00ff)+((num>>8) & 0x00ff00ff);
			num=(num&0x0000ffff)+((num>>16) & 0x0000ffff);
			return num;
		}
		/**
		 *  二进制数逆序
		 * @param num
		 * @return 
		 * 
		 */		
		public static function bitReverse(num:uint):uint
		{
			num=(num&0x55555555) << 1 | ((num&0xaaaaaaaa) >> 1);
			num=(num&0x33333333) << 2 | ((num&0xcccccccc) >> 2);
			num=(num&0x0f0f0f0f) << 4 | ((num&0xf0f0f0f0) >> 4);
			num=(num&0x00ff00ff) << 8 | ((num&0xff00ff00) >> 8);
			num=(num&0x0000ffff) << 16 | ((num&0xffff0000) >> 16);
			return num;
		}
		
		public static function getBitOne(num:uint):int
		{
			
			return ;
		}
	}
}
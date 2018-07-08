package cloud.core.interfaces
{
	/**
	 * 比较接口
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public interface ICCompare
	{
		/**
		 * 比较大小 
		 * @param source
		 * @return Number 如果大于0，当前对象比source对象大，如果小于0，当前对象比source对象小，如果相等就等于0
		 * 
		 */		
		function compare(source:ICData):Number;
	}
}
package cloud.core.collections
{
	/**
	 *  
	 * @author cloud
	 */
	public interface ICompareAble
	{
		function equal(obj:ICompareAble):Boolean;
		function moreThan(obj:ICompareAble):Boolean;
		function lessThan(obj:ICompareAble):Boolean;
	}
}
package cloud.core.collections
{
	public interface IDoubleIterator
	{
		function get prev():Object;
		function get next():Object;
		function get hasNext():Boolean;
	}
}
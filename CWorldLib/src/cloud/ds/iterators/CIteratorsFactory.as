package cloud.ds.iterators
{
	/**
	 * 迭代器工厂类
	 * @author cloud
	 */
	public class CIteratorsFactory
	{
		private static var _Instance:CIteratorsFactory;
		
		public static function get Instance():CIteratorsFactory
		{
			return _Instance||=new CIteratorsFactory();
		}
		
		public function CIteratorsFactory()
		{
		}
	}
}
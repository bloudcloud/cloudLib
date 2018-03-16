package happyECS.world
{
	/**
	 * 世界接口
	 * @author cloud
	 * @2018-3-9
	 */
	public interface IHWorld
	{
		/**
		 * 创建世界 
		 * 
		 */		
		function create():void;
		/**
		 * 销毁世界 
		 * 
		 */		
		function dispose():void;
	}
}
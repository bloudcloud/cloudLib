package extension.cloud.mvcs.base.interfaces
{
	/**
	 * 业务框架的服务接口
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public interface ICMVCSService
	{
		/**
		 * 启动 
		 * 
		 */		
		function start():void;
		/**
		 *  停止
		 * 
		 */		
		function stop():void;
	}
}
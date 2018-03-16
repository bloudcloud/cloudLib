package resources.loader
{
	import flash.events.IEventDispatcher;
	
	import resources.task.ILoaderTaskData;

	/**
	 * 下载器接口
	 * @author cloud
	 */
	public interface IL3DLoader extends IEventDispatcher
	{
		/**
		 * 下载器是否正在运行 
		 * @return Boolean
		 * 
		 */		
		function get isRunning():Boolean;
		/**
		 * 是否需要广播当前下载结果
		 * @return Boolean
		 * 
		 */		
		function get isNeedBroadcast():Boolean;
		/**
		 * 	执行下载 
		 * @param loadTaskData	下载任务数据对象
		 * @return Boolean
		 * 
		 */		
		function excuteLoad(loadTaskData:ILoaderTaskData):Boolean
	}
}
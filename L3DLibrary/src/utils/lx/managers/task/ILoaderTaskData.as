package utils.lx.managers.task
{
	/**
	 * 下载任务数据接口
	 * @author cloud
	 */
	public interface ILoaderTaskData
	{
		/**
		 * 获取唯一ID 
		 * @return String
		 * 
		 */		
		function get uniqueID():String;
		/**
		 * 下载任务数据类型 
		 * @return int
		 * 
		 */		
		function get type():int;
		/**
		 * 获取下载路径 
		 * @return String
		 * 
		 */		
		function get path():String;
		/**
		 * 下载成功的回调处理 
		 * @return Function
		 * 
		 */		
		function get successCallback():Function;
		/**
		 * 下载失败的回调处理 
		 * @return Function
		 * 
		 */		
		function get faultCallback():Function;
		/**
		 * 获取任务是否完成 
		 * @return Boolean
		 * 
		 */		
		function get isFinished():Boolean;
		/**
		 * 是否已使用
		 * @return Boolean
		 * 
		 */		
		function get isUsed():Boolean;
		/**
		 * 清理下载数据 
		 * @return Boolean
		 * 
		 */		
		function clear():Boolean;
	}
}
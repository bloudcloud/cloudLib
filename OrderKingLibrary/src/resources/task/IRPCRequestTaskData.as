package resources.task
{
	/**
	 * RPC任务数据接口
	 * @author cloud
	 * 
	 */	
	public interface IRPCRequestTaskData
	{
		/**
		 * RPC请求名称 
		 * @return String
		 * 
		 */		
		function get requestName():String;
		/**
		 * RPC请求参数数组 
		 * @return Array
		 * 
		 */		
		function get requestParams():Array;

		/**
		 * 请求成功的回调处理 
		 * @return Function
		 * 
		 */		
		function get successCallback():Function;
		/**
		 * 请求失败的回调处理 
		 * @return Function
		 * 
		 */		
		function get faultCallback():Function;
		/**
		 * 清理下载数据 
		 * @return Boolean
		 * 
		 */		
		function clear():Boolean;
	}
}
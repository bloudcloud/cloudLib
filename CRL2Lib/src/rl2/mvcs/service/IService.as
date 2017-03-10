package rl2.mvcs.service
{
	public interface IService
	{
		/**
		 * 开启服务
		 */		
		function start():void;
		/**
		 * 停止服务 
		 */		
		function stop():void;
	}
}
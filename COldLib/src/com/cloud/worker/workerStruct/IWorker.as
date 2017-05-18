package com.cloud.worker.workerStruct
{
	/**
	 * 线程接口，方便管理线程 
	 * @author cloud
	 * 
	 */	
	public interface IWorker
	{
		/**
		 * 添加线程执行任务
		 * @param WorkerTaskVO	线程执行任务数据
		 * 
		 */		
		function addTask(taskVO:WorkerTaskVO):void;
		
		/**
		 * 终止这个Worker
		 * 
		 */		
		function terminateWorker():void;

	}
}
package com.cloud.worker
{
	public final class WorkerTaskVO
	{
		public var sourceName:String;
		public var conditionName:String;
		public var mutexName:String;
		public var data:*;
		
		public function WorkerTaskVO()
		{
		}
	}
}
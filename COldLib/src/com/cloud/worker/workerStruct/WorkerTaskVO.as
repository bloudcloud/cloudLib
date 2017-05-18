package com.cloud.worker.workerStruct
{
	/**
	 * Classname : public final class WorkerTaskVO
	 * 
	 * Date : 2014-3-3 下午3:19:27
	 * 
	 * author :cloud
	 * 
	 * company :青岛高歌网络有限公司
	 */
	/**
	 * 实现功能: worker执行任务数据
	 * 
	 */
	public final class WorkerTaskVO
	{
		/**
		 * 任务类型
		 */		
		public var taskType:String;
		/**
		 * 任务
		 */		
		public var task:Object;
		
		private var _specialKey:String = "";

		public function get specialKey():String
		{
			return _specialKey;
		}
		/**
		 * 设置这个任务的特殊键值<br/>
		 * 当设置了这个值后，子线程执行完此任务的返回会对应到设置这个值的函数。<br/>
		 * 当有些任务需要特殊处理的时候，很有效。
		 */
		public function set specialKey(value:String):void
		{
			_specialKey = value;
		}
		/**
		 * 当前任务是否设置了特殊对应
		 */
		public function get hasSpecialKey():Boolean
		{
			return _specialKey != "";
		}

		public function WorkerTaskVO()
		{
		}
		/**
		 * 设置数据 
		 * @param type	任务类型
		 * @param task		任务数据对象
		 * 
		 */		
		[Inline]
		public function setVO(type:String, task:Object):void
		{
			this.taskType = type;
			this.task = task;
		}
	}
}
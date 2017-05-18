package com.cloud.worker
{
	import flash.concurrent.Condition;
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	public class BasicWorker extends Sprite
	{
		/**
		 * 主线程到子线程的通道
		 */		
		protected var _maintToWorker:MessageChannel;
		/**
		 * 子线程到主线程的通道
		 */	
		protected var _workerToMain:MessageChannel;
		/**
		 * 共享数据 
		 */		
		protected var _source:ByteArray;
		/**
		 *  互斥条件类
		 */		
		protected var _condition:Condition;
		/**
		 * 互斥类 
		 */		
		protected var _mutex:Mutex;
		
		public function BasicWorker(channleName:String)
		{
			super();
			if(this["constructor"] == BasicWorker) throw new Error("The BasicWorker class is an abstract class,need to be extended");
			registerClassAlias("WorkerTaskVO",WorkerTaskVO);
			_maintToWorker = Worker.current.getSharedProperty(channleName+WorkerCommand.M2W);
			_workerToMain = Worker.current.getSharedProperty(channleName+WorkerCommand.W2M);
			_maintToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
		}
		
		protected function onMainToWorker(event:Event):void
		{
			// TODO Auto-generated method stub
			var msg:* =_maintToWorker.receive();
			if(msg is WorkerTaskVO)
			{
				_source = Worker.current.getSharedProperty((msg as WorkerTaskVO).sourceName);
				_condition = Worker.current.getSharedProperty((msg as WorkerTaskVO).conditionName);
				_mutex = Worker.current.getSharedProperty((msg as WorkerTaskVO).mutexName);
				excute((msg as WorkerTaskVO).data);
			}
			else if(msg == WorkerCommand.STOP_WORKER)
			{
				terminateWorker();
			}
		}
		/**
		 * 执行worker（子类需实现）
		 * @param data	需要的数据
		 * 
		 */		
		protected function excute(data:*):void
		{
			
		}
		/**
		 * 释放当前worker的一些缓存资源（子类需实现） 
		 * 
		 */		
		protected function releaseWorker():void
		{
			
		}
		/**
		 * 停止worker 
		 * 
		 */		
		public function terminateWorker():void
		{
			releaseWorker();
			Worker.current.terminate();
		}
		
	}
}
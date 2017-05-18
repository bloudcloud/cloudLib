package com.cloud.worker.workerStruct
{
	/**
	 * Classname : public class BaseWorker extends Sprite implements IWorker
	 * 
	 * Date : 2014-3-3 下午3:24:27
	 * 
	 * author :cloud
	 * 
	 * company :青岛高歌网络有限公司
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	/**
	 * 实现功能: 自定义线程处理抽象类
	 * 
	 */
	public class BaseWorker extends Sprite implements IWorker
	{
		/**
		 * 收到此指令，将启动worker
		 */		
		public static const ORDER_START:String = "start_ABS";
		/**
		 * 收到此指令将停止worker
		 */		
		public static const ORDER_TERMINATE:String = "terminate_ABS";
		/**
		 * 主线程到子线程的通道
		 */		
		protected var _m2w:String;
		/**
		 * 子线程到主线程的通道
		 */		
		protected var _w2m:String;
		/**
		 * 子线程
		 */		
		protected var _worker:Worker;
		protected var maintToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		/**
		 * 任务队列
		 */		
		protected var _taskQueue:Vector.<WorkerTaskVO>;
		
		public function BaseWorker()
		{
			super();
			specialization();
			registerClassAlias("WorkerTaskVO",WorkerTaskVO);
			_taskQueue = new Vector.<WorkerTaskVO>();
			workInitialize();
			initCommunicate();
		}
		/**
		 * 主函数发送来的消息处理 
		 * @param e
		 * 
		 */		
		private function onMainToWorker(e:Event):void
		{
			var msg:* = maintToWorker.receive();
			if(msg is WorkerTaskVO)
			{
				addTask(msg as WorkerTaskVO);
			}
			else if(msg == ORDER_TERMINATE)
			{
				terminateWorker();
			}
		}
		/**
		 * 检查任务队列
		 * 
		 */		
		private function checkQueue():void
		{
			//如果当前任务队列里面还有任务
			if(_taskQueue.length) 										
			{
				//执行队列尾部的任务
				excuteTask(_taskQueue[_taskQueue.length - 1]);            
			}
		}
		/**
		 * 获得主类共享的消息通道<br/>
		 * 并侦听从主线程发来的消息<br/>
		 * 这个方法必须在主线程执行完初始化后执行，
		 */	
		private function initCommunicate():void
		{
			_worker = Worker.current;
			workerToMain = _worker.getSharedProperty(_w2m);
			maintToWorker = _worker.getSharedProperty(_m2w);
			maintToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
		}
		/**
		 * 具体类应该把一些初始化设置放置在这个函数里面。<br/>
		 * 这些初始化设置将伴随着release方法而消失<br/>
		 * 这些设置应该在worker启动之前完成。
		 */
		protected function workInitialize():void
		{
			
		}
		/**
		 * 子类应该重写这个函数来特殊化自己<br/>
		 * 设置包括<br/>
		 * _m2w, _w2m <br/>
		 * _m2w的值应为String(ExcuteCls) + 'mtw' <br/>
		 * _w2m的值应为String(ExcuteCls) + 'wtm'
		 */		
		protected function specialization():void
		{
			
		}
		
		/**
		 * 根据任务ID开始一个任务。
		 * @param task
		 * 
		 */		
		protected function excuteTask(taskVO:WorkerTaskVO):void
		{
			
		}
		/**
		 * 当线程被终止的时候，调用此方法。<br/>
		 * 应该将一些侦听方法移除或者取消不必要的关联。
		 */	
		protected function releaseWorker():void
		{
			
		}
		/**
		 * 子类应该在任务执行结束后调用这个函数。<br/>
		 * 这个函数应该被添加到setCompleteHandler方法的参数函数的最后
		 * @param task
		 * 
		 */		
		protected final function excuteComplete(taskVO:WorkerTaskVO):void
		{
			//将任务再发回主线程。(此时子线程WOrker类应该已经将task的内容转换为主线程想要的数据)
			workerToMain.send(taskVO);
			taskVO = null;
			//将已经完成的任务从任务队列中去除.
			_taskQueue.pop();
			checkQueue();
		}
		public function addTask(taskVO:WorkerTaskVO):void
		{
			_taskQueue.unshift(taskVO);                                   //将任务添加到队列的头部
			//如果任务队列里面只有一个任务。就执行该任务
			if(_taskQueue.length == 1)
			{
				excuteTask(_taskQueue[0]);
			}
		}
		
		public function terminateWorker():void
		{
			releaseWorker();
			_worker.terminate();
		}
	}
}
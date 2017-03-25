package com.chunbai.model.observer.example1
{
	/**
	 * 发布者(被观察者)类，此类来存储和增删及管理和操作订阅者(观察者)对象
	 * */
	public class Sender
	{
		private var _arr:Array = [];    //订阅者对象列表
		private var _notification:String;    //发送的事件信息
		
		public function Sender()
		{
			
		}
		
		/**
		 * 注册订阅者(观察者)对象，就是把订阅者(观察者)对象放都到集合中
		 * @param r 注册的订阅者对象
		 * */
		public function registerReceiver($r:Receiver):void
		{
			_arr.push($r);    //添加订阅者(观察者)
		}
		
		/**
		 * 移除一个订阅者(观察者)对象
		 * */
		public function removeReceiver($r:Receiver):void
		{
			var r:Receiver;
			for each(r in _arr)
			{
				if(r == $r)
				{
					break;
				}
			}
			_arr.splice(r, 1);    //从数组中删除这个订阅者
		}
		
		/**
		 * 发送者的消息字符串
		 * */
		public function sendNotification($notifi:String):void
		{
			_notification = $notifi;    //信息传递
			this.notify();    //通知方法，从而改变订阅者(观察者)
		}
		
		/**
		 * 更新订阅者(观察者)
		 * */
		private function notify():void
		{
			var r:Receiver;
			for each(r in _arr)
			{
				r.update(_notification);    //订阅者(注册者)的更新方法
			}
		}
		
	}
}

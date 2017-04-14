package com.chunbai.model.observer.example1
{
	/**
	 * 订阅者(观察者)类，可以为订阅者(观察者)写一个上层公共结构IReceiver呵呵
	 * */
	public class Receiver
	{
		public var name:String;
		
		public function Receiver($value:String)
		{
			this.name = $value;
		}
		
		/**
		 * @return 返回订阅者(观察者)类的名字
		 * */
		public function toString():String
		{	
			return this.name;
		}
		
		/**
		 * @param message 订阅者(观察者)收到的消息
		 * */
		public function update($message:String):void
		{
			trace(name + "收到" + $message);
		}
		
	}
}

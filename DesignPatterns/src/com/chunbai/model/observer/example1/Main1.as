package com.chunbai.model.observer.example1
{
	import flash.display.Sprite;
	
	public class Main1 extends Sprite
	{
		public function Main1()
		{
			/*创建发布者(被观察者)*/
			var sender:Sender = new Sender();    //创建发布者对象
			
			/*创建和注册多个订阅者(观察者)*/
			var r1:Receiver = new Receiver("a");    //创建订阅者(观察者)对象r1
			var r2:Receiver = new Receiver("b");    //创建订阅者(观察者)对象r2
			var r3:Receiver = new Receiver("c");    //创建订阅者(观察者)对象r3
			sender.registerReceiver(r1);    //注册订阅者对象r1，就是把订阅者对象放都到集合中
			sender.registerReceiver(r2);    //注册订阅者对象r2，就是把订阅者对象放都到集合中
			sender.registerReceiver(r3);    //注册订阅者对象r3，就是把订阅者对象放都到集合中
			
			sender.sendNotification("消息AAA");    //发送消息
			sender.removeReceiver(r1);    //移除第一个订阅者(观察者)对象
			sender.sendNotification("邮件");    //发送"邮件"
		}
		
	}
}

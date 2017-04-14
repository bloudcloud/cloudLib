package com.chunbai.model.observer.example2
{
	/**
	 * 具体观察者角色
	 * */
	public class ConcreteObserver implements IObserver
	{
		public function ConcreteObserver()
		{
			
		}
		
		/**
		 * 实现接到通知进行更新的接口
		 * @Override
		 * */
		public function update():void
		{
		    trace("接到通知");
		}
		
	}
}
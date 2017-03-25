package com.chunbai.model.observer.example2
{
	/**
	 * 具体被观察者角色
	 * */
	public class ConcreteObservable implements IObservable
	{
		//存放观察者
		private var _observerVector:Vector.<IObserver> = new Vector.<IObserver>();
		
		public function ConcreteObservable()
		{
			
		}
		
		/**
		 * 实现可以动态添加观察者的接口
		 * @override
		 * */
		public function addObserver($observer:IObserver):void
		{
			_observerVector.push($observer);
		}
		
		/**
		 * 实现可以动态删除观察者的接口
		 * @Override
		 * */
		public function removeObserver($observer:IObserver):void
		{
			var i:int = 0;
			var observer:IObserver;
			for each(observer in _observerVector)
			{
				if(observer == $observer)
				{
				    break;
				}
				i++;
			}
			_observerVector.splice(i, 1);
		}
		
		/**
		 * 实现通知所有观察者的接口
		 * @Override
		 * */
		public function notifyToAllObservers():void
		{
		    var observer:IObserver;
			for each(observer in _observerVector)
			{
				observer.update();
			}
		}
		
		/**
		 * 被观察者自己的逻辑，并定义了对该操作需要进行通知
		 * */
		public function logicMethod():void
		{
		    //逻辑处理并通知所有观察者
			this.notifyToAllObservers();
		}
		
	}
}
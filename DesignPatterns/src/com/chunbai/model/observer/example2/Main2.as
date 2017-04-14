package com.chunbai.model.observer.example2
{
	public class Main2
	{
		public function Main2()
		{
			//创建被观察者对象
			var observable:ConcreteObservable = new ConcreteObservable();
			
			//创建观察者对象
			var observer1:IObserver = new ConcreteObserver();
			var observer2:IObserver = new ConcreteObserver();
			var observer3:IObserver = new ConcreteObserver();
			
			observable.addObserver(observer1);
			observable.addObserver(observer2);
			observable.addObserver(observer3);
			
			observable.removeObserver(observer2);
			
			observable.logicMethod();
		}
		
	}
}
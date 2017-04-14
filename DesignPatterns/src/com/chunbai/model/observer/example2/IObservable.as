package com.chunbai.model.observer.example2
{
	/**
	 * 抽象被观察角色
	 * */
	public interface IObservable
	{
		//定义可以动态添加观察者的接口
		function addObserver($observer:IObserver):void;
		
		//定义可以动态删除观察者的接口
		function removeObserver($observer:IObserver):void;
		
		//定义通知所有观察者的接口
		function notifyToAllObservers():void;
		
	}
}
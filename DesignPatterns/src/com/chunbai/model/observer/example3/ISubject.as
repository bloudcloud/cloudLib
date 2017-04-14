package com.chunbai.model.observer.example3
{
	
	/**
	 * 建立一个ISubject(主题接口），建立三个接口方法注册、注销、通知
	 * */
	public interface ISubject
	{
		function registerObserver(ob:IObserver):void;
		function removeObserver(ob:IObserver):void;
		function notifyObservers():void;
		
	}
}
package com.chunbai.model.observer.example3
{
	
	/**
	 * 建立一个IObserver(观察者接口)，建立一个update方法，更新数据
	 * */
	public interface IObserver
	{
		function update(qiYa:int,wenDu:int,shiDu:int):void;
		
	}
}
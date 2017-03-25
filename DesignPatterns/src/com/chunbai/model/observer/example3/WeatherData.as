package com.chunbai.model.observer.example3
{
	
	/**
	 * 建立一个WeatherData类实现ISubject类的方法，并添加具体的应用
	 * */
	public class WeatherData implements ISubject
	{
		private var observers:Array;    //观察者数组
		private var _qiYa:int;
		private var _weuDu:int;
		private var _shiDu:int;
		
		public function WeatherData()
		{
			observers = new Array();    //建立观察者数组
		}
		
		public function registerObserver(ob:IObserver):void
		{
			observers.push(ob);
		}
		
		public function removeObserver(ob:IObserver):void
		{
			var i:int = observers.indexOf(ob);
			if(i > 0){
				observers.splice(i, 1);
			}
		}
		
		public function measurementsChanged():void
		{
			notifyObservers();    //通知观察者
		}
		
		public function notifyObservers():void
		{
			trace("主题更新了……");
			var n:int = observers.length;
			for(var i:int = 0; i < n; i++){
				observers[i].update(_qiYa, _weuDu, _shiDu);
			}
		}
		
		//create a method change the WeatherData's Data
		public function setMeasurements(qiYa:int, weuDu:int, shiDu:int):void
		{
			_qiYa = qiYa;
			_weuDu = weuDu;
			_shiDu = shiDu;
			measurementsChanged();
		}
		
	}
}
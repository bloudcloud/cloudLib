package com.chunbai.model.observer.example3
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 创建主题类WeatherData，更新数据后，通知observers
	 * */
	public class Main3 extends Sprite
	{
		private var myGriphics:AsGriphics;
		private  var weatherD:WeatherData;
		
		public function Main3()
		{
		    initApp();
			dataApp();
		}
		
		private function initApp():void
		{			myGriphics = new AsGriphics();
		}
		
		private function dataApp():void
		{
			weatherD = new WeatherData();
			var forecastP:ForecastPanel = new ForecastPanel(weatherD);
			forecastP.x = 265;
			forecastP.y = 180;
			this.addChild(forecastP);
			
			var currentP:CurrentPanel = new CurrentPanel(weatherD);
			currentP.x = 16;
			currentP.y = 129;
			this.addChild(currentP);
			
			var dayP:DayPanel = new DayPanel(weatherD);
			dayP.x = 332;
			dayP.y = 19;
			this.addChild(dayP);
			
			this.addChild(AsGriphics.instance.sprite);
			AsGriphics.instance.sprite.addEventListener(MouseEvent.CLICK, update);    //添回随机更新按钮事件
		}
		
		private function update(e:MouseEvent):void
		{
			var _qy:int = Math.floor(Math.random() * 100);
			var _wd:int = Math.floor(Math.random() * 100);
			var _sd:int = Math.floor(Math.random() * 100);
			weatherD.setMeasurements(_qy, _wd, _sd);
		}
		
	}
}
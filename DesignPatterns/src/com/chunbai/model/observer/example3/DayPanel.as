package com.chunbai.model.observer.example3
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class DayPanel extends MovieClip implements IDisplay,IObserver
	{
		private var _qiYa:int;    //气压
		private var _wenDu:int;    //温度
		private var _shiDu:int;    //湿度
		private var weatherData:ISubject;    //此引用方便注销observer，故保留在内
		
		public function DayPanel($weatherData:ISubject)
		{
			//构造函数中调用WeateherData实例注册自己
			this.weatherData = $weatherData;
			this.weatherData.registerObserver(this);
		}
		
		public function update($qiYa:int, $wenDu:int, $shiDu:int):void
		{
			_qiYa = $qiYa;
			_wenDu = $wenDu;
			_shiDu = $shiDu;    //显示//更新完毕
			
			AsGriphics.instance.qiya.y = 100;
			AsGriphics.instance.shidu.y = 150;
			AsGriphics.instance.wendu.y = 200;
			this.addChild(AsGriphics.instance.qiya);
			this.addChild(AsGriphics.instance.shidu);
			this.addChild(AsGriphics.instance.wendu);
			
			display();    //显示
		}
		
		public function display():void
		{
			trace("DayPanel 气压：" + _qiYa + "; 温度：" + _wenDu + "; 湿度" + _shiDu);
			AsGriphics.instance.qiya.text = _qiYa + "";
			AsGriphics.instance.shidu.text = _shiDu + "";
			AsGriphics.instance.wendu.text = _wenDu + "";		
		}
		
	}
}
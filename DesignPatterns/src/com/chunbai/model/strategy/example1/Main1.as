package com.chunbai.model.strategy.example1
{
	
	/**
	 * 策略模式
	 * */
	public class Main1
	{
		public function Main1()
		{
			var cc:CashContext = new CashContext("打8折");
			trace(cc.getResult(500) + "元");
			
			var cc0:CashContext = new CashContext("满300返150");
			trace(cc0.getResult(500) + "元");
			
			var cc1:CashContext = new CashContext("正常收费");
			trace(cc1.getResult(500) + "元");
		}
		
	}
}
package com.chunbai.model.strategy.example1
{
	
	/**
	 * 这个类是工厂类，简单工厂模式和策略模式结合。能够更好的减少客户端的职责！
	 */
	public class CashContext
	{
		private var _cs:CashSuper
		
		public function CashContext(type:String)
		{
			switch(type)
			{
				case "正常收费":
					_cs = new CashNormal();
					break;
				case "满300返150":
					_cs = new CashReturn(300, 150);
					break;
				case "打8折":
					_cs = new CashRebate(0.8);
					break;
			}
		}
		
		public function getResult(money:Number):Number
		{
			return _cs.acceptCash(money);
		}
		
	}
}
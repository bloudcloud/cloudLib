package com.chunbai.model.strategy.example1
{
	
	public class CashRebate extends CashSuper
	{
		private var _moneyRebate:Number;
		
		public function CashRebate($moneyRebate:Number)
		{
			_moneyRebate = $moneyRebate;
		}
		
		override public function acceptCash(money:Number):Number
		{
			return money * _moneyRebate;
		}
		
	}
}
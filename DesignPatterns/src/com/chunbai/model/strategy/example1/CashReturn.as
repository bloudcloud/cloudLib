package com.chunbai.model.strategy.example1
{
	
	public class CashReturn extends CashSuper
	{
		private var _moneyCondition:Number;
		private var _moneyReturn:Number;
		
		/**
		 * @param moneyCondition:条件，
		 * @param moneyReturn:返还值
		 * */
		public function CashReturn($moneyCondition:Number, $moneyReturn:Number)
		{
			_moneyCondition = $moneyCondition;
			_moneyReturn = $moneyReturn;
		}
		
		override public function acceptCash(money:Number):Number
		{
			var result:Number = money;
			if(money >= _moneyCondition)
			{
				result = money - Math.floor(money / _moneyCondition) * _moneyReturn;
			}
			return result;
		}
		
	}
}
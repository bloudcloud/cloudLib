package com.chunbai.model.strategy.example1
{
	
	public class CashNormal extends CashSuper
	{
		public function CashNormal()
		{
			super();
		}
		
		override public function acceptCash($money:Number):Number
		{
			return $money;
		}
		
	}
}
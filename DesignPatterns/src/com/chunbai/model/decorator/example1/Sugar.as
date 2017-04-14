package com.chunbai.model.decorator.example1
{
	
	public class Sugar extends Seasoning
	{
		private var _coff:Coff;
		
		public function Suger($coff:Coff)
		{
			_coff = $coff;
		}
		
		override public function getDesc():String
		{
			return "seasoning's Sugar";
		}
		
		override public function cost():int
		{
			return _coff.cost() + 10;
		}
		
	}
}
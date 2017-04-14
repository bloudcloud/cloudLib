package com.chunbai.model.decorator.example1
{
	
	public class Ice extends Seasoning
	{
		private var _coff:Coff;
		
		public function Ice($coff:Coff)
		{                        
			_coff = $coff;
		}
		
		override public function getDesc():String
		{
			return "seasoning's Ice";
		}
		
		override public function cost():int
		{
			return _coff.cost() + 8;
		}
		
	}
}
package com.chunbai.model.facade.example2
{
	
	public class TiKao
	{
		private var _name:String;
		
		public function TiKao()
		{
			_name = "TiKao";
		}
		
		public function write():void
		{
			trace(_name + " writePapers \n");
		}
		
	}
}
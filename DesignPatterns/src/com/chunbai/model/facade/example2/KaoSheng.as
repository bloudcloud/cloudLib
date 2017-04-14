package com.chunbai.model.facade.example2
{
	
	public class KaoSheng implements IKaoSheng
	{
		private var _name:String;
		
		public function KaoSheng()
		{
			_name = "KaoSheng";
		}
		
		public function write():void
		{
			trace(_name + " writePapers \n");
		}
		
	}
}
package com.chunbai.model.adapter.example2
{
	
	public class KaoSheng implements IKaoSheng
	{
		private var _name:String;
		
		public function KaoSheng()
		{
			_name = "kaoSheng";
		}
		
		public function getName():String
		{
			return _name;
		}
		
		public function writePapers():void
		{
			trace(_name +  "writepapers");
		}
		
	}
}
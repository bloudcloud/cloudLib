package com.chunbai.model.facade.example2
{
	
	/**
	 * 实现细节功能的准考证类
	 * */
	public class ZunKaoZheng
	{
		private var _zunKaoZhengHao:String;
		
		public function ZunKaoZheng()
		{
			_zunKaoZhengHao = "伪造的准考证";
		}
		
		public function getZKZ():String
		{                        
			return _zunKaoZhengHao;
		}
		
	}
}
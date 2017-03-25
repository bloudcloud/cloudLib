package com.chunbai.model.adapter.example2
{
	
	/**
	 * TiKao类有自己的写卷子方法和名字
	 * */
	public class TiKao
	{
		private var _name:String;
		
		public function TiKao()
		{
			_name = "假name，我可是_替_考的";
		}
		
		public function writePapers():void
		{
			trace(getName() +  " 标准答案我早有了");
		}
		
		public function getName():String
		{
			return _name;
		}
		
	}
}
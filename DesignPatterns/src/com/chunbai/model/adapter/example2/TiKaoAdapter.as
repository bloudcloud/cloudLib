package com.chunbai.model.adapter.example2
{
	
	public class TiKaoAdapter implements IKaoSheng
	{
		private var _tikao:TiKao;
		
		public function TiKaoAdapter($tikao:TiKao)
		{
			_tikao = $tikao;
		}
		
		public function writePapers():void
		{
			_tikao.writePapers();
		}
		
	}
}
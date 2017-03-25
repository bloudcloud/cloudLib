package com.chunbai.model.adapter.example2
{
	
	public class Main2{
		public function Main2()
		{
			var kaoSheng:KaoSheng = new KaoSheng();
			var tiKao:TiKao = new TiKao();
			var tiKaoAdapter:TiKaoAdapter = new TiKaoAdapter(tiKao);
			testKaoSheng(kaoSheng);
			testKaoSheng(tiKaoAdapter);
		}
		
		private function testKaoSheng($kaoSheng:IKaoSheng):void
		{
			$kaoSheng.writePapers();
		}
		
	}
}
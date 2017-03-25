package com.chunbai.model.facade.example2
{
	
	public class Main2
	{
		public function Main2()
		{
			var kaoS:KaoSheng = new KaoSheng();
			var tiKaoFacade:TiKaoFacade = new TiKaoFacade();
			kaoS.write();
			tiKaoFacade.write();
			testKaoS(kaoS);    //检察考生
			testKaoS(tiKaoFacade);    //如果tiKaoFacade不是实现了IkaoSheng接口那这里就检察出来了，呵呵
		}
		
		private function testKaoS(_kaosheng:IKaoSheng):void
		{
			_kaosheng.write();
		}
		
	}
}
package com.chunbai.model.facade.example2
{
	
	/**
	 * 外观者TiKaoFacade，用组合方式，当然也可以做为适配器，注意他的双重身份，你不定要这样做，这里只是配合上个例子
	 * */
	public class TiKaoFacade implements IKaoSheng
	{
		private var zkz:ZunKaoZheng;
		private var tikao:TiKao;
		
		public function TiKaoFacade()
		{
			zkz = new ZunKaoZheng();
			tikao = new TiKao();
		}
		
		public function write():void
		{
			trace("先准备" + zkz.getZKZ());
			tikao.write();
		}
		
	}
}
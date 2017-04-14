package com.chunbai.model.decorator.example1
{
	
	public class Main1
	{
		public function Main1()
		{
			var blackCoff:BlackCoff = new BlackCoff();                        
			trace(blackCoff.getDescription() + "应付" + blackCoff.cost() + "元");    //BlackCoff应付8元
			var ice:Ice = new Ice(blackCoff);    //BlackCoff加seasoning's Ice之后，就付16
			trace(blackCoff.getDescription() + "加" + ice.getDesc() + "之后，就付" + ice.cost());
		}
		
	}
}
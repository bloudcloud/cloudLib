package com.chunbai.model.adapter.example1
{
	
	/**
	 * 客户端
	 * */
	public class Main1{
		public function Main1()
		{
			var target:ITarget = new AdapterA();////切换到类适配器模式
			//var target:ITarget = new AdapterB();//切换到对象适配器模式
			target.renamedRequestA();
			target.requestA();
			target.requestB();
			target.requestC();
			target.requestD();
		}
		
	}
}
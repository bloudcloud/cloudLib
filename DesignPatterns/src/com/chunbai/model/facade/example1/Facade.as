package com.chunbai.model.facade.example1
{
	public class Facade
	{
		private var one:SubSystemOne;
		private var two:SubSystemTwo;
		private var three:SubSystemThree;
		private var four:SubSystemFour;
		
		public function Facade()
		{
			one = new SubSystemOne();
			two = new SubSystemTwo();
			three = new SubSystemThree();
			four = new SubSystemFour();
		}
		
		public function MethodA():void
		{
			trace("/n方法组A() ---- ");
			one.test1();
			two.test2();
			four.test4();
		}
		
		public function MethodB():void
		{
			trace("/n方法组B() ---- ");
			two.test2();
			three.test3();
		}
	}
}
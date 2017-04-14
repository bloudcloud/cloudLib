package com.chunbai.model.singleton
{
	import com.chunbai.model.singleton.example1.Singleton1;
	import com.chunbai.model.singleton.example2.Singleton2;
	import com.chunbai.model.singleton.example3.Singleton3;
	import com.chunbai.model.singleton.example4.Singleton4;
	import com.chunbai.model.singleton.example5.Singleton5;
	
	/**
	 * 单例模式总测试类
	 * */
	public class SingletonTest
	{
		public function SingletonTest()
		{
			Singleton1.getInstance();
			Singleton2.getInstance();
			Singleton3.getInstance();
			Singleton4.getInstance();
			Singleton5.getInstance();
		}
		
	}
}
/*************************************************************************************
　* 名称:as3oop设计模式之龟兔赛跑Animals类
　* 功能:建立一个Animals(动物）类，
         此run:可以被实例化，并由父类实现，那么所有继承此父类的子类可以通过局部接口修改
		 达到修改所有类的目的，但是策略者模式的本意是可以解决多对多的运行中改变问题，故这里
		 留有一招，不进行实例化，只在具体运行时才使用。
　* 版本:学习版0.1
　* 日期:2010-10-14
　* 作者:coolwind
　* 版权:Copyright(C) coolwind, qq38082227, 20010-2012. All rights reserved
**************************************************************************************/
package oop.race
{
	import flash.display.MovieClip;	
	
	public class Animals extends MovieClip
	{
		public var _name:String;
		
		public function Animals(nS:String)
		{
			_name=nS
		}
		
	}
}
		
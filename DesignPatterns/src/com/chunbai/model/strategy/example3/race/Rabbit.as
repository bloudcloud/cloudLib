/*
　* 名称:as3oop设计模式之龟兔赛跑Rabbit类
　* 功能:建立Rabbit（兔子）类继承Animals的run:Irun实现多态Irun,并在运行中改变
　* 版本:学习版0.1
　* 日期:2010-10-14
　* 作者:coolwind
　* 版权:Copyright(C) coolwind, qq38082227, 20010-2012. All rights reserved
*/
package oop.race{
	public class Rabbit extends Animals{				
		import flash.text.TextField;
		public var sp:int=0;
		public var runStatus:IRun;//Irun接口
		public function Rabbit(nS:String){
			super(nS);
			runStatus=new RunWithStop();//初始化兔子的奔跑状态
		}
		public function run(an:Animals,runS:IRun):void{
			trace("This's Rabbit:"+_name);
			runStatus=runS;
			runStatus.run(an);
		}
	}
}
/*************************************************************************************
　* 名称:as3oop设计模式之龟兔赛跑RunSpeedUp类实现Irun接口
　* 功能:建立一个RunSpeedUp(加速）类，实现Irun接口
　* 版本:学习版0.1
　* 日期:2010-10-14
　* 作者:coolwind
　* 版权:Copyright(C) coolwind, qq38082227, 20010-2012. All rights reserved
**************************************************************************************/
package oop.race{
	public class RunSpeedUp implements IRun {
		import flash.utils.getQualifiedClassName;
		public function run(an:Animals):void {
			var target=an as Animals;
			target.statusText.text="run with speedUp!";			
			target.sp+=1;
			//通过参数Animals获取使用此状态的对像，并调用对像自身的方法停止。
		}
	}
}
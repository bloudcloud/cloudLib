/*************************************************************************************
　* 名称:as3oop设计模式之龟兔赛跑Race文档类
　* 功能:UI控件以MC方式直接放在舞台上，本例不涉及动画编程，只验证接口处理多对多的以及运行中
        改变的特点
　* 版本:学习版0.1
　* 日期:2010-10-14
　* 作者:coolwind
　* 版权:Copyright(C) coolwind, qq38082227, 20010-2012. All rights reserved
**************************************************************************************/
package oop.race{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	public class Race extends MovieClip {
		private var rabbit:Rabbit;//创建一个"引用"为Rabbit类型
		private var tortoise:Tortoise;//创建一个"引用"为Tortoise类型
		private var runS:IRun;//创建一个"引用"为IRun
		private var tmpX:Number;//记录临时被拖动对象的X坐标
		private var tmpY:Number;//记录临时被拖动对象的Y坐标
		public function Race() {
			init();//初始化
		}
		private function init():void {
			//初始化说明文字内容为龟兔赛跑
			infoText.text="这里是龟兔赛跑";
			mapMotion.stop();//地图停止卷动
			upBtn.visible=downBtn.visible=false;
			//建立Rabbit实例,初始化时其跑动状态为停止，对应舞台上小兔子也停止
			rabbit=new Rabbit("小兔子");
			rabbit.x=0;
			rabbit.y=150;
			rabbit.mouseEnabled=false;
			addChild(rabbit);
			rabbit.stop();
			//建立Tortoise实例，初始化时其跑动状态为停止
			tortoise=new Tortoise("小乌龟");
			tortoise.x=0;
			tortoise.y=250;
			tortoise.mouseEnabled=false;
			addChild(tortoise);
			tortoise.stop();
			//建立startBtn
			startBtn.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			startBtn.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			startBtn.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			startBtn.addEventListener(MouseEvent.MOUSE_UP,onUp);
			//取消startBtn的下子剪辑的mouse响应事件
			startBtn.mouseChildren=false;
			//upBtn,downBtn事件
			upBtn.desText.text="加速";
			upBtn.addEventListener(MouseEvent.MOUSE_OVER,onOver,false);
			upBtn.addEventListener(MouseEvent.MOUSE_OUT,onOut,false);
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN,upOnDown,false);
			upBtn.addEventListener(MouseEvent.MOUSE_UP,upOnUp,false);
			upBtn.mouseChildren=false;
			downBtn.desText.text="减速";
			downBtn.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			downBtn.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN,downOnDown);
			downBtn.addEventListener(MouseEvent.MOUSE_UP,downOnUp);
			downBtn.mouseChildren=false;
		}
		//建立响应事件的处理函数
		private function upOnDown(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.scaleX=targetObj.scaleY=1;
			tmpX=targetObj.x;
			tmpY=targetObj.y;
			targetObj.startDrag();
			addChild(targetObj);			
		}
		//加速按钮弹起事件要处理判断对像再加状态
		private function upOnUp(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.scaleX=targetObj.scaleY=1.05;
			targetObj.stopDrag();
			//判断给相交的对像附加速状态
			runS=new RunSpeedUp();
			if(targetObj.hitTestObject(rabbit)){
				rabbit.run(rabbit,runS);
			}else if(targetObj.hitTestObject(tortoise)){
				tortoise.run(tortoise,runS);
			}
			//恢复原位置
			targetObj.x=tmpX;
			targetObj.y=tmpY;
		}
		private function downOnDown(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.scaleX=targetObj.scaleY=0.98;
			tmpX=targetObj.x;
			tmpY=targetObj.y;
			targetObj.startDrag();
			addChild(targetObj);//手动时，目标对象位于顶层，防止被其它遮挡导致事件失效
		}
		//减速按钮弹起事件要处理判断对像再加状态
		private function downOnUp(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.stopDrag();
			//判断给相交的对像附加减速状态
			runS=new RunSpeedDown();
			if(targetObj.hitTestObject(rabbit)){
				rabbit.run(rabbit,runS);
			}else if(targetObj.hitTestObject(tortoise)){
				tortoise.run(tortoise,runS);
			}
			//恢复原位置
			targetObj.x=tmpX;
			targetObj.y=tmpY;
		}
		private function onOver(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.alpha=0.5;
			targetObj.desText.textColor = 0xFF0000;
			infoText.text="开始游戏";
			tmpX=targetObj.x;
			tmpY=targetObj.y;
		}
		private function onOut(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.alpha=1;
			targetObj.desText.textColor = 0x000000;
			infoText.text="这里是龟兔赛跑";
			targetObj.stopDrag();
			//恢复原位置
			targetObj.x=tmpX;
			targetObj.y=tmpY;
		}
		private function onDown(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.scaleX=targetObj.scaleY=0.98;
			tmpX=targetObj.x;
			tmpY=targetObj.y;			
		}
		//开始事件触发后，开始比赛
		private function onUp(e:MouseEvent):void {
			var targetObj=e.target as Object;
			targetObj.scaleX=targetObj.scaleY=1;
			//开始比赛
			startRace();
		}
		private function startRace():void {
			upBtn.visible=downBtn.visible=true;
			infoText.text="开始比赛";
			rabbit.play();
			tortoise.play();
			mapMotion.play();
			tortoise.addEventListener(Event.ENTER_FRAME,onTortoiseRun);
			rabbit.addEventListener(Event.ENTER_FRAME,onRabbitRun);
			//tortoise.run(tortoise,new RunSpeedUp());
		}
		//乌龟奔跑，起始单位时间移动距离为0
		private function onTortoiseRun(e:Event) {
			//给乌龟随机的状态，来更改他跑的速度,百分之一的机率更换
			tortoise.x+=tortoise.sp;//乌龟移动sp距离，sp为单位时间距离			
			//到达终点结束游戏
			if(tortoise.x>=500){
				gameEnd(tortoise);
			}
		}
		//兔子奔跑，起始单位时间移动距离为0
		private function onRabbitRun(e:Event) {
			rabbit.x+=rabbit.sp;//兔子移动sp距离，sp为单位时间距离
			if(rabbit.x>=500){
				gameEnd(rabbit);
			}
		}
		//游戏结束，状态清零
		private function gameEnd(an:Animals):void{
			//所有状态归零
			upBtn.visible=downBtn.visible=false;
			rabbit.x=0;
			rabbit.sp=0;
			rabbit.statusText.text="Ready";			
			rabbit.gotoAndStop(1);
			rabbit.removeEventListener(Event.ENTER_FRAME,onRabbitRun);
			tortoise.x=0;
			tortoise.sp=0;
			tortoise.statusText.text="Ready";			
			tortoise.gotoAndStop(1);
			tortoise.removeEventListener(Event.ENTER_FRAME,onTortoiseRun);
			mapMotion.stop();
			//决出胜负
			infoText.text="胜利者是:"+an._name;
			
		}
	}
}
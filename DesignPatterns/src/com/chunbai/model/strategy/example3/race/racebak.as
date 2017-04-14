/*
　* 名称:as3oop设计模式之龟兔赛跑Race文档类
　* 功能:UI控件以MC方式直接放在舞台上，本例不涉及动画编程，只验证接口处理多对多的以及运行中
        改变的特点
　* 版本:学习版0.1
　* 日期:2010-10-08
　* 作者:coolwind
　* 版权:Copyright(C) coolwind, qq38082227, 20010-2012. All rights reserved
*/
package oop.race{
        import flash.display.MovieClip;
        import flash.text.TextField;
        import flash.events.MouseEvent;        
        import flash.display.Sprite;
        public class Race extends MovieClip{                
                private var tmpX:Number;//记录临时被拖动对象的X坐标
                private var tmpY:Number;//记录临时被拖动对象的Y坐标
                private var rabbit:Rabbit;
                private var tortoise:Tortoise;
                public function Race(){
                        init();
                }
                private function init():void{
                        //初始化说明文字内容为龟兔赛跑
                        infoText.text="这里是龟兔赛跑";
                        //建立Rabbit实例,初始化时其跑动状态为停止，对应舞台上小兔子也停止
                        rabbit=new Rabbit("小兔子");
                        rabbitMC.gotoAndStop(1)
                        //建立Tortoise实例，初始化时其跑动状态为停止
                        tortoise=new Tortoise("小乌龟");
                        tortoiseMC.gotoAndStop(1)
                        //建立speedUp和speedDown事件监听                        
                        upBtn.addEventListener(MouseEvent.MOUSE_OVER,onOver);
                        upBtn.addEventListener(MouseEvent.MOUSE_OUT,onOut);
                        upBtn.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
                        upBtn.addEventListener(MouseEvent.MOUSE_UP,onUp);
                        downBtn.addEventListener(MouseEvent.MOUSE_OVER,onOver);
                        downBtn.addEventListener(MouseEvent.MOUSE_OUT,onOut);
                        downBtn.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
                        downBtn.addEventListener(MouseEvent.MOUSE_UP,onUp);        
                        //取消upBtn、downBtn中desText的mouse响应事件
                        upBtn.desText.mouseEnabled=false;
                        downBtn.desText.mouseEnabled=false;
                }
                private function onOver(e:MouseEvent):void{
                        var targetObj=e.target as Object;                        
                        targetObj.alpha=0.5;
                        targetObj.desText.textColor = 0xFF0000; 
                        infoText.text="想给乌龟或者兔子"+targetObj.desText.text+"就把"+targetObj.desText.text+"拖到它身上";
                }
                private function onOut(e:MouseEvent):void{
                        var targetObj=e.target as Object;
                        targetObj.alpha=1;
                        targetObj.desText.textColor = 0x000000;                 }
                private function onDown(e:MouseEvent):void{
                        var targetObj=e.target as Object;
                        targetObj.scaleX=targetObj.scaleY=1;
                        tmpX=targetObj.x
                        tmpY=targetObj.y;
                        targetObj.startDrag();
                }
                private function onUp(e:MouseEvent):void{
                        var targetObj=e.target as Object;
                        targetObj.scaleX=targetObj.scaleY=1.05;                        
                        targetObj.stopDrag();
                        //开始判断是否相交
                        if(targetObj.hitTestObject(rabbitMC) && targetObj.hitTestObject(tortoiseMC)){
                                infoText.text=targetObj.desText.text+"同时放在兔子和小龟身上了";
                                /*获取targetObj对像，判断是加速还是减速，并将状态同时加给兔子和乌龟这里因为不使用动画编程，
                                所以并未以接口方式实现兔子和乌龟(舞台上的MovieClip实例)，否则不需要判断，直接将类Rabbit绑
                                定到舞台剪辑实例即可。as3不支持多继承，Rabbit已经继承了Animals。
                                */
                                if(targetObj.desText.text=="加速"){                                        
                                        rabbit.runStatus=new RunSpeedUp();
                                        rabbit.run();//输出runWithSpeedUp;
                                        rabbitMC.play();
                                        tortoise.runStatus=new RunSpeedUp();
                                        tortoise.run();//输出runWithSpeedUp;
                                        tortoiseMC.play();
                                }else if(targetObj.desText.text=="停止"){
                                        rabbit.runStatus=new RunSpeedDown();
                                        rabbit.run();//输出runWithSpeedUp;
                                        rabbitMC.stop();
                                        tortoise.runStatus=new RunSpeedDown();
                                        tortoise.run();//输出runWithSpeedUp;
                                        tortoiseMC.stop();
                                }
                                
                        }else if (targetObj.hitTestObject(tortoiseMC)){
                                trace(targetObj.desText.text+"放在小龟身上了");
                                infoText.text=targetObj.desText.text+"放在小龟身上了";                                
                                if(targetObj.desText.text=="加速"){                                        
                                        tortoise.runStatus=new RunSpeedUp();
                                        tortoise.run();//输出runWithSpeedUp;
                                        tortoiseMC.play();
                                }else if(targetObj.desText.text=="停止"){
                                        tortoise.runStatus=new RunSpeedDown();
                                        tortoise.run();//输出runWithSpeedUp;
                                        tortoiseMC.stop();
                                }
                        }else if (targetObj.hitTestObject(rabbitMC)){
                                infoText.text=targetObj.desText.text+"放在兔子身上了";                                
                                if(targetObj.desText.text=="加速"){                                        
                                        rabbit.runStatus=new RunSpeedUp();
                                        rabbit.run();//输出runWithSpeedUp;
                                        rabbitMC.play();                                        
                                }else if(targetObj.desText.text=="停止"){
                                        rabbit.runStatus=new RunSpeedDown();
                                        rabbit.run();//输出runWithSpeedUp;
                                        rabbitMC.stop();
                                }
                        }else{
                                infoText.text=targetObj.desText.text+"谁都没碰着";
                        }
                        //恢复原位置
                        targetObj.x=tmpX;
                        targetObj.y=tmpY;                        
                }
        }
}
                
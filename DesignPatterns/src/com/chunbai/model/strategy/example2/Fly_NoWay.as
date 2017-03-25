package com.chunbai.model.strategy.example2
{
	
	public class Fly_NoWay implements IFlyBehavior
	{
	    public function fly():void
		{
			trace("我不会飞哦，请不要让我飞！");
		}
		
	}
}
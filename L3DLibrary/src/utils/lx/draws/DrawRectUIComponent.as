package utils.lx.draws
{
	import mx.core.UIComponent;

	public function DrawRectUIComponent(uicomponent:UIComponent,rectColor:uint=0,lineColor:uint=0,thickness:Number=0,width:Number=0,height:Number=0,rectX:Number=0,rectY:Number=0, lineAlpha:Number=1.0, bgAlpha:Number=1.0,pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null, miterLimit:Number=3):void
	{
		if(!uicomponent)
		{
			return;
		}
		if(width<=0)
		{
			width=uicomponent.width;
		}
		if(height<=0)
		{
			height=uicomponent.height;
		}
		if(thickness<0)
		{
			thickness=0;
		}
		uicomponent.graphics.clear();
		if(thickness>0)
		{
			uicomponent.graphics.lineStyle(thickness,lineColor,lineAlpha,pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		uicomponent.graphics.beginFill(rectColor,bgAlpha);
		uicomponent.graphics.drawRect(rectX,rectY,width,height);
		uicomponent.graphics.endFill();
	}
}
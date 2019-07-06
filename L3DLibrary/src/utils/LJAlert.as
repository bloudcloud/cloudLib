package utils
{
	import flash.display.DisplayObject;
	
	
	public class LJAlert
	{
		
		
		
		
		/**
		 * 
		 * @param messages 消息
		 * @param type 类型 1、 2表示单个确定按钮，3表示确定取消按钮
		 * @param callback 回调函数
		 * 
		 */
		static public function show(messages:String,type:int = 1,callback:Function = null):void
		{
			var message:MessageBox = new MessageBox();
				message.popOpen(messages,type,callback);
		
		}
	
	
	}
}
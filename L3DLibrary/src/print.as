package
{
	import utils.lx.managers.GlobalManager;

	/**
	 * 公共打印输出
	 * @param value 输出内容
	 * @param pre 前置自定义内容
	 * @param showTime 是否输出时间
	 */
	public function print(...args):void
	{
		if(!GlobalManager.enablePrint)
		{
			return;
		}
		var tracemsg:String='';  
		for each (var obj:Object in args){  
			tracemsg=tracemsg.concat(obj+", ");  
		}  
		tracemsg=tracemsg.substr(0,tracemsg.length-2);  
		trace(tracemsg);
	}
}
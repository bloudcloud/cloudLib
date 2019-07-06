package interfaces
{
	/**
	 * 乐家任务通用接口
	 * @author cloud
	 */
	public interface IL3DTestTaskData extends IL3DBaseData
	{
		/**
		 * 获取执行回调方法的参数数组 
		 * @return Array
		 * 
		 */		
		function get excuteParam():Array;
		/**
		 * 设置执行回调方法的参数数组 
		 * @param value
		 * 
		 */		
		function set excuteParam(value:Array):void;
		/**
		 * 获取失败回调方法的参数数组 
		 * @return Array
		 * 
		 */		
		function get faultParam():Array;
		/**
		 * 设置失败回调方法的参数数组 
		 * @param value
		 * 
		 */		
		function set faultParam(value:Array):void;
		/**
		 * 获取执行回调方法  
		 * @return Function
		 * 
		 */		
		function get excuteCallback():Function;
		/**
		 * 设置执行回调方法 
		 * @param func
		 * 
		 */		
		function set excuteCallback(func:Function):void;
		/**
		 * 获取失败回调方法 
		 * @return 
		 * 
		 */		
		function get faultCallback():Function;
		/**
		 * 设置失败回调方法 
		 * @param func
		 * 
		 */		
		function set faultCallback(func:Function):void;
	}
}
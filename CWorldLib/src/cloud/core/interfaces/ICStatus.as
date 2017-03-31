package cloud.core.interfaces
{
	/**
	 *  状态接口
	 * @author cloud
	 */
	public interface ICStatus
	{
		/**
		 * 是否在执行 
		 * @return Boolean
		 * 
		 */		
		function get isRunning():Boolean;
		/**
		 * 启动
		 * 
		 */		
		function start():void;
		/**
		 * 停止
		 * 
		 */		
		function stop():void;
		/**
		 * 每帧更新
		 * @param time
		 * 
		 */				
		function updateByFrame(time:Number=0):void;
	}
}
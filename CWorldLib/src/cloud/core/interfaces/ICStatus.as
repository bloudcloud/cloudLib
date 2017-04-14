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
		 * @param startTime		帧起始时间
		 * @param frameTime	帧运行时间
		 * 
		 */					
		function updateByFrame(startTime:Number=0,frameTime:Number=0):void;
	}
}
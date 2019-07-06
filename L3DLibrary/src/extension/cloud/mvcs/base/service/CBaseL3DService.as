package extension.cloud.mvcs.base.service
{
	import flash.events.Event;
	
	import extension.cloud.mvcs.base.interfaces.ICMVCSService;
	
	import robotlegs.bender.framework.api.IContext;

	/**
	 * 基础业务服务类
	 * @author	cloud
	 * @date	2018-6-27
	 */
	public class CBaseL3DService implements ICMVCSService
	{
		[Inject]
		public var context:IContext;
		
		public function CBaseL3DService()
		{
		}
		/**
		 * 执行启动服务(需子类重新实现)
		 * 
		 */		
		protected function doStart():void
		{
		}
		/**
		 * 执行关闭服务(需子类重新实现)
		 * 
		 */		
		protected function doStop():void
		{
		}
		/**
		 * 通过服务类为业务代理类派发通知事件 
		 * @param evt
		 * 
		 */		
		protected function dispatchEventForProxy(evt:Event):void
		{
			context.dispatchEvent(evt);
		}
		
		public function start():void
		{
			doStart();
		}
		
		public function stop():void
		{
			doStop();
			context=null;
		}
		
	}
}
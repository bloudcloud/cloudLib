package extension.cloud.mvcs.base.view
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;
	import robotlegs.bender.framework.api.IContext;
	
	/**
	 * 基础业务界面中介类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CBaseL3DViewMediator implements IMediator
	{
		[Inject] 
		public var context:IContext;
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		protected var _view:CBaseL3DViewSprite;
		protected var _className:String;
		
		public function set viewComponent(viewObj:Object):void
		{
			_view=viewObj as CBaseL3DViewSprite;
		}
		
		public function CBaseL3DViewMediator(clsName:String)
		{
			_className=clsName;
		}
		/**
		 * 添加视图层界面对象监听 
		 * 
		 */		
		protected function doAddListener():void
		{
		}
		/**
		 * 移除视图层界面对象监听 
		 * 
		 */		
		protected function doRemoveListener():void
		{
		}
		/**
		 * 框架内唯一事件派发器的事件派发
		 * @param type	事件类型
		 * 
		 */		
		protected function dispatchDatasEvent(type:String):void
		{
			if (dispatcher.hasEventListener(type))
				dispatcher.dispatchEvent(new Event(type));
		}
		/**
		 * 添加框架内的广播事件监听 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		public function addContextEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			context.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		/**
		 * 移除框架内的广播事件监听 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public function removeContextEventListener(type:String,listener:Function,useCapture:Boolean=false):void
		{
			context.removeEventListener(type,listener,useCapture);
		}
		/**
		 * 初始化
		 * 
		 */
		public function initialize():void
		{
			doAddListener();
//			logger.info((_className+"->initialize()"));
		}
		/**
		 * 销毁 
		 * 
		 */		
		public function destroy():void
		{
			doRemoveListener();
			_view.dispose();
			_view=null;
//			logger.info((_className+"->destroy()"));
		}

	}
}
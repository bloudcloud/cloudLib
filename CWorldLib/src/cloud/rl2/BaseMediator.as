package cloud.rl2
{
	/**
	 *	基础视图中介类
	 * @author cloud
	 */
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	
	public class BaseMediator implements IMediator
	{
		[Inject]
		public var context:IContext;
		[Inject]
		public var eventMap:IEventMap;
		[Inject]
		public var logger:ILogger;
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		protected var _view:Object;
		protected var _type:String;

		public function get type():String
		{
			return _type;
		}

		
		public function BaseMediator(type:String="")
		{
			_type=type;
		}
		
		protected function addListener():void
		{
			
		}
		
		protected function removeListener():void
		{
			
		}
		
		public function addContextEventListener(type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void
		{
			context.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeContextEventListener(type:String,listener:Function,useCapture:Boolean=false):void
		{
			context.removeEventListener(type,listener,useCapture);
		}
		
		public function set viewComponent(object:Object):void
		{
			_view=object;
		}

		public function initialize():void
		{
			addListener();
			logger.info((_type+"->initialize()"));
		}
		
		public function destroy():void
		{
			removeListener();
			logger.info((_type+"->destroy()"));
		}
		
		protected function dispatch(event:Event):void
		{
			if (dispatcher.hasEventListener(event.type))
				dispatcher.dispatchEvent(event);
		}
	}
}
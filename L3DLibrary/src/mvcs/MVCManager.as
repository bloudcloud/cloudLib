package mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class MVCManager
	{
		private var _context:IContext;

		public function MVCManager(application:Sprite)
		{
			//注册MVCS
			_context = new Context()
				.install(MVCSExtensionsBundle)
				.configure(AppConfig)
				.configure(new ContextView(DisplayObjectContainer(application)));
			
//			_dispatcher = _context.injector.getInstance(IEventDispatcher) as IEventDispatcher;
			//			_context.logLevel = LogLevel.DEBUG;
		}
	}
}
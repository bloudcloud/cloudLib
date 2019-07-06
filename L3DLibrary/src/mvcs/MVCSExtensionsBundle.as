package mvcs
{
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.contextView.ContextViewListenerConfig;
	import robotlegs.bender.extensions.contextView.StageSyncExtension;
	import robotlegs.bender.extensions.directCommandMap.DirectCommandMapExtension;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.modularity.ModularityExtension;
	import robotlegs.bender.extensions.viewManager.StageCrawlerExtension;
	import robotlegs.bender.extensions.viewManager.StageObserverExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.extensions.viewProcessorMap.ViewProcessorMapExtension;
	import robotlegs.bender.framework.api.IBundle;
	import robotlegs.bender.framework.api.IContext;

	public class MVCSExtensionsBundle implements IBundle
	{
		public function MVCSExtensionsBundle()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
//			context.logLevel = LogLevel.DEBUG;
			
			context.install(
//				TraceLoggingExtension,
//				VigilanceExtension,
//				InjectableLoggerExtension,
				ContextViewExtension,
				EventDispatcherExtension,
				ModularityExtension,
				DirectCommandMapExtension,
				EventCommandMapExtension,
				LocalEventMapExtension,
				ViewManagerExtension,
				StageObserverExtension,
				MediatorMapExtension,
				ViewProcessorMapExtension,
				StageCrawlerExtension,
				StageSyncExtension);
			
			context.configure(ContextViewListenerConfig);
		}
	}
}
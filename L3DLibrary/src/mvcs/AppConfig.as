package mvcs
{
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class AppConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		
		public function AppConfig()
		{
			
		}
		
		public function configure():void
		{
			models();
			mediators();
			commands();
		}
		
		private function models():void
		{
//			injector.map(ViewModel).asSingleton();
//			injector.m
		}
		
		private function mediators():void
		{
//			mediatorMap.map(MainApp).toMediator(MainAppMediator);
		}
		
		private function commands():void
		{
//			commandMap.map(CommandEvent.Initialize,CommandEvent).toCommand(InitializeCommand);
		}
	}
}
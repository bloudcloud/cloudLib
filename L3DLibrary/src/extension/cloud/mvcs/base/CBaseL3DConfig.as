package extension.cloud.mvcs.base
{
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * 基础业务配置类
	 * @author	cloud
	 * @date	2018-6-29
	 */
	public class CBaseL3DConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;
		[Inject]
		public var mediatorMap:IMediatorMap;
		[Inject]
		public var commandMap:IEventCommandMap;
		[Inject]
		public var dispatcher:IEventDispatcher;
		[Inject]
		public var context:IContext;
		
		public function CBaseL3DConfig()
		{
		}
		
		public function configure():void
		{
			doConfigCommands();
			doConfigModels();
			doConfigServices();
			doConfigMediators();
			doAfterConfig();
		}
		
		protected function doConfigModels():void
		{
		}
		protected function doConfigMediators():void
		{
		}
		protected function doConfigCommands():void
		{
		}
		protected function doConfigServices():void
		{
		}
		protected function doAfterConfig():void
		{
		}
		protected function doDestroyServices():void
		{
		}
		
		public function destroyServices():void
		{
			doDestroyServices();
			injector=null;
			mediatorMap=null;
			commandMap=null;
			dispatcher=null;
		}
	}
}
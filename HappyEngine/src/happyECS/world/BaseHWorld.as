package happyECS.world
{
	import happyECS.module.IHModule;

	/**
	 * 基础世界类
	 * @author cloud
	 * @2018-3-9
	 */
	public class BaseHWorld implements IHWorld
	{
		private var _clsRefName:String;
		private var _modules:Vector.<IHModule>;
		
		public function BaseHWorld(refName:String="BaseHWorld")
		{
			_clsRefName=refName;
			_modules=new Vector.<IHModule>();
		}
		protected function doCreated():void
		{
		}
		protected function doDisposed():void
		{
		}
		public function addModule(module:IHModule):void
		{
			_modules.push(module);
		}
		public function removeModule(module:IHModule):void
		{
			var idx:int=_modules.indexOf(module);
			if(idx>=0)
			{
				_modules.removeAt(idx);
			}
		}
		public function create():void
		{
			doCreated();
		}
		
		public function dispose():void
		{
			for(var i:int=_modules.length-1; i>=0; i--)
			{
				_modules[i].uninstall();
				_modules.removeAt(i);
			}
			_modules=null;
			doDisposed();
		}
	}
}
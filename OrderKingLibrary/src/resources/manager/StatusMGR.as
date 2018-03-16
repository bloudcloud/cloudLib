package resources.manager
{
	import core.HashMap;
	import resources.status.IStatus;

	public class StatusMGR
	{
		public var currentRender:String;

		private var stateMap:HashMap=new HashMap();
		private var stateSetup:Array=[];

		public function StatusMGR()
		{
		}

		public function register(key:String, status:IStatus):StatusMGR
		{
			stateMap.add(key, status);
			return this;
		}

		public function getStatus(key:String):IStatus
		{
			return stateMap.getValue(key) as IStatus;
		}

		/**
		 * 统计当前有状态开启的
		 */		
		public function calc():void
		{
			stateSetup.length=0;
			var arg:Array = stateMap.getAllValue();
			var iStatus:IStatus;
			for (var i:int = 0; i < arg.length; i++) 
			{
				iStatus = arg[i] as IStatus;
				if(iStatus.isRunning)
				{
					stateSetup.push(iStatus);
				}
			}
		}

		public function currentStatusGroup():Array
		{
			return stateSetup;
		}
	}
}

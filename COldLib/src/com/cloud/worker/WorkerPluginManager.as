package com.cloud.worker
{
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	final public class WorkerPluginManager
	{
		private static var _instance:WorkerPluginManager;
		
		private var _workerDic:Dictionary;
		private var _mainWorker:Worker;
		
		public static function get instance():WorkerPluginManager
		{
			return _instance ||= new WorkerPluginManager(new SingletonEnforce());
		}
		
		public function WorkerPluginManager(enforcer:SingletonEnforce)
		{
			_workerDic = new Dictionary();
		}
		
		public function setUp(vector:Array):void
		{
			_mainWorker = Worker.current;
			var byte:ByteArray;
			if(vector && vector.length)
			{
				for(var i:int = 0; i < vector.length; i++)
				{
					byte = vector[i] as ByteArray;
					byte.position = 0;
					var str:String = byte.readUTFBytes(byte.readByte());
					if(_workerDic[str] == null)
					{
						_workerDic[str] = WorkerDomain.current.createWorker(byte,true);
					}
				}
			}
		}
	}
}
class SingletonEnforce{}
package utils.lx.managers.task
{

	/**
	 * 乐家3D专用RPC请求任务数据类 
	 * @author cloud
	 * 
	 */	
	public class L3DRPCRequestTaskData implements IRPCRequestTaskData
	{
		private var _requestName:String;
		private var _requestParams:Array;
		private var _successCallback:Function;
		private var _faultCallback:Function;
		
		public var count:int;
		
		public function L3DRPCRequestTaskData(name:String,successCallback:Function,faultCallback:Function,params:Array)
		{
			_requestName=name;
			_requestParams=params;
			_successCallback=successCallback;
			_faultCallback=faultCallback;
		}

		public function get requestName():String
		{
			return _requestName;
		}
		public function get requestParams():Array
		{
			return _requestParams;
		}
		public function get successCallback():Function
		{
			return _successCallback;
		}
		public function get faultCallback():Function
		{
			return _faultCallback;
		}
		
		public function clear():Boolean
		{
			_requestParams.length=0;
			_requestParams=null;
			_successCallback=null;
			_faultCallback=null;
			count=0;
			return false;
		}
		public function toString():String
		{
			return "_requestName: "+_requestName+" _requestParams: "+_requestParams;
		}
	}
}
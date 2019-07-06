package task
{
	import L3DLibrary.L3DModelDataFactory;
	
	import interfaces.IL3DBaseData;
	import interfaces.IL3DTestTaskData;
	
	import ns.cloud_lejia;
	
	use namespace cloud_lejia;
	/**
	 * 基础任务数据类
	 * @author cloud
	 */
	public class L3DBaseTaskData implements IL3DTestTaskData
	{
		private var _id:String;
		private var _type:uint;
		private var _name:String;
		private var _excuteParam:Array;
		private var _faultParam:Array;
		private var _excuteCallback:Function;
		private var _faultCallback:Function;
		
		cloud_lejia var _classRefName:String;
		
		public function get excuteParam():Array
		{
			return _excuteParam;
		}
		
		public function set excuteParam(value:Array):void
		{
			if(_excuteParam)
			{
				doClearParam(_excuteParam);
			}
			_excuteParam=value;
		}
		
		public function get faultParam():Array
		{
			return _faultParam;
		}
		
		public function set faultParam(value:Array):void
		{
			_faultParam=value;
		}
		
		public function get excuteCallback():Function
		{
			return _excuteCallback;
		}
		
		public function set excuteCallback(func:Function):void
		{
			_excuteCallback=func;
		}
		
		public function get faultCallback():Function
		{
			return _faultCallback;
		}
		
		public function set faultCallback(func:Function):void
		{
			_faultCallback=func;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id=value;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(value:uint):void
		{
			_type=value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name=value;
		}
		
		public function get classRefName():String
		{
			return _classRefName;
		}
		
		public function L3DBaseTaskData(refName:String="L3DBaseTaskData")
		{
			_classRefName=refName;
		}
		
		protected function doClearParam(params:Array):void
		{
			for(var i:int=params.length-1; i>=0; i--)
			{
				if(params[i] is IL3DBaseData)
				{
					(params[i] as IL3DBaseData).dispose();
				}
			}
			params.length=0;
		}
		
		public function dispose(isRealDispose:Boolean=false):Boolean
		{
			_id=null;
			_type=0;
			_name=null;
			_classRefName=null;
			_excuteCallback=null;
			_faultCallback=null;
			if(isRealDispose)
			{
				if(_excuteParam)
				{
					doClearParam(_excuteParam);
				}
				_excuteParam=null;
				if(_faultParam)
				{
					doClearParam(_faultParam);
				}
				_faultParam=null;
			}
			return true;
		}
		public function clone():IL3DBaseData
		{
			var data:L3DBaseTaskData=new (L3DModelDataFactory.Instance.getClass(_classRefName))();
			data.id=id;
			data.type=type;
			data.name=name;
			data._classRefName=classRefName;
			data.excuteParam=excuteParam;
			data.excuteCallback=excuteCallback;
			data.faultParam=faultParam;
			data.faultCallback=faultCallback;
			return data;
		}
	}
}
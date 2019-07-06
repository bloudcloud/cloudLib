package extension.cloud.mvcs.base.model
{
	
	import mx.utils.UIDUtil;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.interfaces.ICSerialization;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.mvcs.dict.CMVCSClassDic;
	import extension.cloud.singles.CL3DClassFactory;
	
	/**
	 * 基础业务数据类
	 * @author	cloud
	 * @date	2018-6-28
	 */
	public class CBaseL3DData implements ICNodeData,ICSerialization
	{
		private var _ownerID:String;
		private var _className:String;
		private var _uniqueID:String;
		private var _type:uint;
		private var _isLife:Boolean;
		private var _name:String;
		private var _refCount:uint;
		
		public function get ownerID():String
		{
			return _ownerID;
		}
		
		public function set ownerID(value:String):void
		{
			_ownerID=value;
		}
		
		public function get uniqueID():String
		{
			return _uniqueID;
		}
		
		public function set uniqueID(value:String):void
		{
			_uniqueID=value;
		}
//		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(value:uint):void
		{
			_type=value;
		}
		
		public function get isLife():Boolean
		{
			return _isLife;
		}
		
		public function set isLife(value:Boolean):void
		{
			_isLife=value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name=value;
		}
		
		public function get refCount():uint
		{
			return _refCount;
		}
		
		public function set refCount(value:uint):void
		{
			_refCount=value;
		}
		
		public function get className():String
		{
			return _className;
		}
		
		public function CBaseL3DData(clsName:String,uniqueID:String)
		{
			_className=clsName?clsName:CMVCSClassDic.CLASSNAME_BASEL3D_DATA;
			_uniqueID=uniqueID?uniqueID:CUtil.Instance.createUID();
		}
		
		public function updateByData(data:CBaseL3DData):void
		{
			this.ownerID=data.ownerID;
			_className=data.className;
			this.type=data.type;
			this.isLife=data.isLife;
			this.name=data.name;
			this.refCount=data.refCount;
		}
		public function toString():String
		{
			return "className: "+className+"uniqueID: "+uniqueID+"type: "+type+"isLife: "+isLife+"name: "+name+"refCount: "+refCount+"\n";
		}
		
		public function clone():ICData
		{
			var clsRef:Class=CL3DClassFactory.Instance.getClassRefByName(className);
			var clone:CBaseL3DData=new clsRef(className,UIDUtil.createUID()) as CBaseL3DData;
			clone.type=type;
			clone.isLife=isLife;
			clone.name=name;
			clone.refCount=refCount;
			clone.ownerID=ownerID;
			return clone;
		}
		
		public function compare(source:ICData):Number
		{
			return 0;
		}
		
		public function clear():void
		{
			_isLife=false;
			_ownerID=null;
			_uniqueID=null;
		}

		public function deserialize(source:*):void
		{
		}
		
		public function serialize(formate:String):*
		{
			return null;
		}
	}
}
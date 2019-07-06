package extension.cloud.singles
{
	import cores.HashMap;

	/**
	 *	业务类工厂
	 * @author	cloud
	 * @date	2018-6-25
	 */
	public class CL3DClassFactory
	{
		private static var _Instance:CL3DClassFactory;
		
		public static function get Instance():CL3DClassFactory
		{
			return _Instance||=new CL3DClassFactory(new SingletonEnforce());
		}
		private var _classRefMap:HashMap;
		
		public function CL3DClassFactory(enforcer:SingletonEnforce)
		{
			_classRefMap=new HashMap();
		}
		/**
		 * 添加注册类 
		 * @param clsName
		 * @param clsRef
		 * 
		 */		
		public function registClassRef(clsName:String,clsRef:Class):void
		{
			_classRefMap.add(clsName,clsRef);
		}
		/**
		 * 移除注册类 
		 * @param clsName
		 * @param clsRef
		 * 
		 */		
		public function unRegistClassRef(clsName:String,clsRef:Class):void
		{
			_classRefMap.removeKey(clsName);
		}
		/**
		 * 通过类名获取类定义 
		 * @param clsName	类名
		 * @return Class 类定义
		 * 
		 */		
		public function getClassRefByName(clsName:String):Class
		{
			return _classRefMap.getValue(clsName);
		}
		/**
		 *  通过类定义获取
		 * @param cls
		 * @return String
		 * 
		 */		
		public function getClassNameByRef(cls:Class):String
		{
			var keys:Array=_classRefMap.getAllKey();
			var result:String;
			for(var i:int=keys.length-1; i>=0; i--)
			{
				if(cls==_classRefMap.getValue(keys[i]))
				{
					result=keys[i];
					break;
				}
			}
			return result; 
		}
	}
}
package L3DLibrary
{
	import cores.HashMap;
	
	import interfaces.IL3DBaseData;
	
	import ns.cloud_lejia;

	/**
	 * 3D模型数据工厂类
	 * @author cloud
	 */
	public class L3DModelDataFactory
	{
		private var _classDict:HashMap;
		
		private static var _Instance:L3DModelDataFactory;
		
		cloud_lejia static function get Instance():L3DModelDataFactory
		{
			return _Instance||=new L3DModelDataFactory(new Single());
		}
		
		public function L3DModelDataFactory(enforcer:Single)
		{
			_classDict=new HashMap();
		}
		/**
		 * 注册模型数据类
		 * @param clsDict
		 * @return Boolean
		 * 
		 */		
		public function registClass(className:String,clsDict:Class):Boolean
		{
			if(clsDict==null || className==null)
			{
				return false;
			}
			_classDict.add(className,clsDict);
			return true; 
		}
		/**
		 * 根据类名获取类
		 * @param className
		 * @return Class
		 * 
		 */		
		public function getClass(className:String):Class
		{
			return _classDict.getValue(className) as Class;
		}
		/**
		 * 创建基础业务层数据模型对象
		 * @param refName	数据对象类定义名称
		 * @param id	数据对象唯一ID
		 * @param type	数据对象类型
		 * @param name	数据对象名称
		 * @return IL3DBaseData	数据对象接口类型
		 * 
		 */		
		public function createModelData(refName:String,id:String,type:uint,name:String):IL3DBaseData
		{
			var mData:IL3DBaseData=new (getClass(refName))();
			mData.id=id;
			mData.type=type;
			mData.name=name;
			return mData; 
		}
	}
}
class Single{}
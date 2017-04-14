package cloud.pool
{
	import flash.utils.Dictionary;
	
	import mx.core.Singleton;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICObject3DData;
	import cloud.core.utils.CDebug;

	/**
	 * 3D对象数据池
	 * @author cloud
	 */
	public class CObject3DVOPool
	{
		private static var _instance:CObject3DVOPool;
		public static function get instance():CObject3DVOPool
		{
			return _instance ||= new CObject3DVOPool(new Singleton());
		}
		private var _classDic:Dictionary;
		private var _vosDic:Dictionary;
		private var _num:uint;
		
		public function CObject3DVOPool(enforcer:Singleton)
		{
			_classDic=new Dictionary();
			_vosDic=new Dictionary();
		}
		
		public function registPool(classDic:Class,classType:uint):void
		{
			_classDic[classType]=classDic;
			if(_vosDic.hasOwnProperty(classDic))
			_vosDic[classDic]=new Array();
		}
		/**
		 * 出栈
		 * @param classType	数据类型
		 * @return ICObject3DData
		 * 
		 */		
		public function popObject3DVo(classType:uint):ICObject3DData
		{
			var vo:ICObject3DData;
			var arr:Array=_vosDic[_classDic[classType]];
			if(!arr) CDebug.instance.throwError("CObject3DVOPool","getVo","arr","需要先执行regist方法注册池的关联类!");
			if(arr.length>0)
			{
				vo=arr.pop();
				_num--;
			}
			else
			{
				vo=new _classDic[classType]();
			}
			return vo;
		}
		/**
		 * 入栈 
		 * @param value	数据对象
		 * 
		 */		
		public function pushObject3DVo(value:ICObject3DData):void
		{
			_vosDic[_classDic[value.type]].push(value);
			_num++;
		}
	}
}
class Singleton{}
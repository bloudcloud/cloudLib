package  cloud.core.datas.maps
{
	import flash.utils.Dictionary;
	
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICMap;

	/**
	 * Classname : public class HashMap implements IMap
	 * 
	 * Date : 2014-3-1 上午11:43:28
	 * 
	 * author :cloud
	 * 
	 * company :青岛高歌网络有限公司
	 */
	/**
	 * 实现功能: 哈希Map
	 * 
	 */
	public class CHashMap implements ICMap
	{
		/**
		 * 键名数组，储存键名 
		 */		
		private var _keys:Array;
		/**
		 * 键值字典 
		 */		
		private var _props:Dictionary;
		
		public function get size():int{ return _keys.length; }
		/**
		 * 构造哈希map 
		 * 
		 */		
		public function CHashMap()
		{
			_props = new Dictionary();
			_keys = new Array();
		}
		/**
		 * 判断有没有该键
		 * @param k	键
		 * @return Boolean
		 * 
		 */	
		[Inline]
		public function containsKey(k:*):Boolean
		{
			return _props[k] != null;
		}
		/**
		 * 判断有没有该键值 
		 * @param v	键值
		 * @return 
		 * 
		 */		
		[Inline]
		public function containsValue(v:*):Boolean
		{
			var bool:Boolean;
			var len:int = _keys.length;
			for(var i:int = 0; i < len; i++)
			{
				
			}
			return bool;
		}
		/**
		 * 判断有没有该键值 
		 * @param k
		 * @return 
		 * 
		 */		
		[Inline]
		public function get(key:*):Object
		{
			return _props[key];
		}
		/**
		 *  添加一个新键到末端
		 * @param k	键名
		 * @param v	键值
		 * @return int	位置
		 * 
		 */	
		[Inline]
		public function put(key:*, value:*):Object
		{
			var result:Object=null;
			if (containsKey(key)) {
				result=this.get(key);
			} else {
				_keys.push(key);
			}
			_props[key]=value;
			return result;
		}
		/**
		 *  删除一个键
		 * @param k
		 * @return 
		 * 
		 */	
		[Inline]
		public function remove(key:*):Object
		{
			var result:Object;
			if(containsKey(key))
			{
				result = _props[key];
				delete _props[key];
				var index:int = _keys.indexOf(key);
				_keys.splice(index,1);
			}
			return result;
		}
		/**
		 * 清除数据 
		 * 
		 */	
		[Inline]
		public function clear():void
		{
			var len:int=_keys.length;
			for(var i:int=0; i<len; i++)
			{
				if(_props[_keys[i]] is ICData)
					(_props[_keys[i]] as ICData).clear();
				delete _props[_keys[i]];
				_keys[i]=null;
			}
			_keys.length=0;
		}
		////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 填充HashMap数据
		 * */
		public function putAll(map:ICMap):void {
			this.clear();
			var len:int=map.size;
			if (len>0) {
				var arr:Array=map.keys;
				for (var i:uint=0; i<len; i++) {
					this.put(arr[i],map.get(arr[i]));
				}
			}
		}

		/**
		 *返回是否包含数据
		 * */
		public function get isEmpty():Boolean {
			return _keys.length <1;
		}
		/**
		 * 返回HashMap数据
		 * */
		public function get values():Array {
			var result:Array=new Array() ;
			var len:int= _keys.length;
			if (len>0) {
				for (var i:int=0; i<len; i++) {
					result.push(_props[_keys[i]]);
				}
			}
			return result;
		}
		/**
		 * 返回键名数组
		 * */
		public function get keys():Array {
			return _keys;
		}
	}
}
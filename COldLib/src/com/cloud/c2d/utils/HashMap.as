package com.cloud.c2d.utils
{
	import flash.utils.Dictionary;

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
	final public class HashMap implements IMap
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
		public function HashMap()
		{
			clear();
		}
		/**
		 * 判断有没有该键
		 * @param k	键
		 * @return Boolean
		 * 
		 */	
		[Inline]
		public function hasKey(k:*):Boolean
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
		public function hasValue(v:*):Boolean
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
		public function getValue(k:*):Object
		{
			return _props[k];
		}
		/**
		 *  添加一个新键到末端
		 * @param k	键名
		 * @param v	键值
		 * @return int	位置
		 * 
		 */	
		[Inline]
		public function put(k:*, v:*):Object
		{
			var result:Object=null;
			if (hasKey(k)) {
				result=this.getValue(k);
				_props[k]=v;
			} else {
				_props[k]=v;
				_keys.push(k);
			}
			return result;
		}
		/**
		 *  删除一个键
		 * @param k
		 * @return 
		 * 
		 */	
		[Inline]
		public function remove(k:*):Object
		{
			var result:Object;
			if(hasKey(k))
			{
				result = _props[k];
				delete _props[k];
				var index:int = _keys.indexOf(k);
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
			_props = new Dictionary();
			_keys = new Array();
		}
		////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 填充HashMap数据
		 * */
		public function putAll(map:HashMap):void {
			this.clear();
			var len:int=map.size();
			if (len>0) {
				var arr:Array=map.keys;
				for (var i:uint=0; i<len; i++) {
					this.put(arr[i],map.getValue(arr[i]));
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
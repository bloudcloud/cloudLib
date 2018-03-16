package core {
	import flash.utils.Dictionary;

	/**
	 * 哈希数组
	 * @author Liuxin
	 *
	 */
	final public class HashMap {
		private var _dictionary:Dictionary;
		private var _count:uint=0;

		public function HashMap() {
			_dictionary=new Dictionary();
		}

		/**
		 * 是否存在这个key
		 * @param key 要查找的key
		 * @return true存在/false不存在
		 *
		 */
		public function hasKey(key:*):Boolean {
			return key in _dictionary;
		}

		/**
		 * 添加key和value
		 * @param key 要添加的key
		 * @param value 要添加的value
		 */
		public function add(key:*, value:*):void {
			if (!hasKey(key))
				_count++;
			_dictionary[key]=value;
		}

		/**
		 * 移除key和value
		 * @param key 要移除的key
		 * @return true移除成功/false移除失败
		 */
		public function remove(key:*):Boolean {
			if (hasKey(key)) {
				_count--;
				_dictionary[key]=null;
				delete _dictionary[key];
				return true;
			} else {
				return false;
			}
		}

		/**
		 * 根据key得到value
		 * @param key 要查找的key
		 * @return value 得到的value
		 */
		public function getValue(key:*):* {
			return _dictionary[key];
		}

		/**
		 * 返回所有key
		 * @return
		 */
		public function getAllKey():Array {
			var arg:Array=[];
			for (var key:* in _dictionary) {
				arg.push(key);
			}
			return arg;
		}

		/**
		 * 得到所有的value
		 * @return
		 */
		public function getAllValue():Array {
			var arg:Array=[];
			for (var key:* in _dictionary) {
				arg.push(_dictionary[key]);
			}
			return arg;
		}

		/**
		 * 清空哈希数组
		 */
		public function clear():void {
			for (var key:* in _dictionary) {
				_count--;
				_dictionary[key]=null;
				delete _dictionary[key];
			}
		}

		/**
		 * 字典的长度
		 * @return uint 长度
		 */
		public function get length():uint {
			return _count;
		}

		public function print():String {
			var string:String="";
			for (var key:* in _dictionary) {
				string+="key:" + key + ",value:" + _dictionary[key] + "\n";
			}
			return string;
		}
	}
}
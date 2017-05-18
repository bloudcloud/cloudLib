package cloud.core.dataStruct.container
{
	import cloud.core.interfaces.ICPoolObject;

	/**
	 * 抽象数据缓存容器类
	 * @author cloud
	 */
	public class AbstractDataContainer implements ICPoolObject
	{
		protected var _container:Array;
		protected var _abstractClass:Class
		protected var _invalidSize:Boolean;
		protected var _size:uint;
		protected var _length:uint;
		protected var _dataAttributeLength:uint;
		
		public function get size():uint
		{
			if(_invalidSize)
				updateContainer();
			return _size;
		}
		public function get length():uint
		{
			if(_invalidSize)
				updateContainer();
			return _length;
		}
		
		public function AbstractDataContainer(abstractClass:Class)
		{
			initObject(abstractClass);
		}
		
		protected function updateContainer():void
		{
			_invalidSize=false;
			_length=_container.length;
			_size=_length/_dataAttributeLength;
		}
		/**
		 * 添加数据缓存 
		 * @param obj
		 * 
		 */		
		public function add(obj:*):void
		{
		}
		/**
		 * 根据索引获取数据缓存 
		 * @param index	起始索引
		 * @param output	输出对象
		 * 
		 */				
		public function getByIndex(index:uint,output:*):void
		{
		}
		/**
		 * 根据索引更新数据缓存 
		 * @param obj
		 * @param index
		 * 
		 */		
		public function updateByIndex(obj:*,index:int):void
		{
		}
		/**
		 * 连接数据缓存容器
		 * @param container
		 * 
		 */		
		public function concat(container:AbstractDataContainer):void
		{
			_container=_container.concat(container);
		}
		public function initObject(initParam:Object=null):void
		{
			_abstractClass=initParam as Class;
			_container=[];
		}
		/**
		 * 释放数据缓存 
		 * 
		 */		
		public function dispose():void
		{
			_container.length=0;
			_container=null;
			_abstractClass=null;
		}
	}
}
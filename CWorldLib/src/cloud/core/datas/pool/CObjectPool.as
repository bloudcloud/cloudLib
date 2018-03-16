package cloud.core.datas.pool
{
	import flash.utils.getQualifiedClassName;
	
	import avmplus.getQualifiedClassName;
	
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.utils.CClassFactory;
	import cloud.core.utils.CDebugUtil;
	
	import ns.singleton;

	use namespace singleton
	/**
	 * 	缓存对象池类
	 * @author cloud
	 */
	public class CObjectPool implements ICObjectPool
	{
		private var _name:String;
		private var _minSize:int;
		private var _invalidLength:Boolean;
		private var _curIndex:int;
		private var _size:int;
		private var _typeCls:Class;//回收对象的类型
		private var _constructors:Array;
		private var _constructorsCount:int;
		
		protected var _cache:Vector.<ICPoolObject>;
		
		public function get name():String
		{
			return _name;
		}
		public function get size():int
		{
			return _size;
		}

		public function CObjectPool(typeCls:Class,constructors:Array=null,size:int=5) 
		{
			this._name=flash.utils.getQualifiedClassName(typeCls);
			this._typeCls=typeCls;
			this._size=size;
			this._minSize=_size;
//			this._constructors=[typeCls]
			if(constructors!=null)
			{
				this._constructors=constructors;
				_constructorsCount=constructors.length;
			}
			this._cache=new Vector.<ICPoolObject>(size);
			initPool();
		}

		private function initPool():void
		{
			for(_curIndex=size; _curIndex>_size-_minSize; --_curIndex)
			{
				if(_constructorsCount>0)
					_cache[_curIndex-1]=CClassFactory.instance.funcs[_constructorsCount-1].call(null,_typeCls,_constructors);
				else
					_cache[_curIndex-1]=new _typeCls();
			}
		}
		
		
		public function push(o:ICPoolObject):void{
			if(_curIndex==0 || _cache[_curIndex]==null ) 
			{
				CDebugUtil.Instance.throwError("CObjectPool","push","_cache[_curIndex]","为空!");
				return;
			}
			_curIndex--;
			_cache[_curIndex]=o;
		}
		public function pop():ICPoolObject
		{
			var o:ICPoolObject;
			var index:int=_curIndex;
			if((_curIndex>=_size-1))
			{
				_size*=2;
				_minSize=_size*.5;
				_curIndex=_size;
				_cache.length=_size;
				initPool();
			}
			if(_cache[index]!=null)
			{
				_curIndex=index;
			}
			else
			{
				_curIndex=index+1;
			}
			o=_cache[_curIndex];
			o.initObject.apply(null,_constructors);
			_cache[_curIndex]=null;
			_curIndex++;
			return o;
		}
		public function flush():void
		{
			if(_minSize<_size)
			{
				for(var i:int=_size; i>_minSize; i--)
				{
					_cache[i].dispose();
					_cache[i]=null;
				}
				_cache.length=_minSize;
				if(_curIndex>=_minSize)
				{
					_curIndex=_minSize-1;
				}
				_size=_minSize;
				_minSize=_size*.5;
			}
		}
		public function dispose():void
		{
			_constructors.length=0;
			_constructors=null;
			_typeCls=null;
		}
	}
}
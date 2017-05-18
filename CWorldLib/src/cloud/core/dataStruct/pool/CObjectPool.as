package cloud.core.dataStruct.pool
{
	import flash.utils.getQualifiedClassName;
	
	import avmplus.getQualifiedClassName;
	
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.singleton.CClassFactory;
	import cloud.core.utils.CDebug;
	
	import ns.singleton;

	use namespace singleton
	/**
	 * 	对象池
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
			this._size=this._minSize=size;
			this._constructors=[typeCls]
			if(constructors!=null)
			{
				this._constructors=this._constructors.concat(constructors);
				_constructorsCount=constructors.length;
			}
			this._cache=new Vector.<ICPoolObject>(size);
			initPool();
		}

		private function initPool():void
		{
			for(_curIndex=size; _curIndex>0; _curIndex--)
			{
				if(_constructorsCount>0)
					_cache.push(CClassFactory.instance.funcs[_constructorsCount].apply(null,_constructors));
				else
					_cache.push(new _constructors[0]());
			}
		}
		
		public function push(o:ICPoolObject):void{
			o.dispose();
			if(_curIndex==0 || _cache[_curIndex]==null ) 
			{
				CDebug.instance.throwError("CObjectPool","push","_cache[_curIndex]","为空!");
				return;
			}
			_cache[--_curIndex]=o;
		}
		public function pop():ICPoolObject
		{
			var obj:ICPoolObject;
			var index:int=_curIndex;
			if((_curIndex==_size-1) ||
				(_curIndex==_size))
			{
				_size*=2;
				_minSize=_size*.5;
				_curIndex=_size;
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
			obj=_cache[_curIndex];
			obj.initObject(_constructors);
			_cache[_curIndex++]=null;
			return obj;
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
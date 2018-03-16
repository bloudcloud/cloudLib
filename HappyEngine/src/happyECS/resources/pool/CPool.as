package happyECS.resources.pool
{
	import happyECS.ns.happy_ecs;
	import happyECS.resources.pool.ICPoolObject;
	import happyECS.utils.CClassFactory;
	import happyECS.utils.CDebugUtil;
	
	use namespace happy_ecs;
	
	/**
	 * 对象缓冲池
	 * @author cloud
	 * @2018-3-8
	 */
	public class CPool implements ICPool
	{
		private var _cls:Class;
		private var _size:uint;
		private var _construtors:Array;
		private var _minSize:uint;
		private var _caches:Vector.<ICPoolObject>;
		private var _curIndex:int;
		
		public function CPool(cls:Class,size:uint,construtors:Array)
		{
			_cls=cls;
			_size=size;
			_construtors=construtors;
			_minSize=_size;
			_caches=new Vector.<ICPoolObject>(_size);
			initPool();
		}
		private function initPool():void
		{
			clear();
			var len:int=_construtors?_construtors.length:0;
			for(_curIndex=_size-1; _curIndex>=_minSize; _curIndex--)
			{
				if(len>0)
				{
					_caches[_curIndex]=CClassFactory.Instance.funcs[_construtors.length].apply(null,[_cls].concat(_construtors));
				}
				else
				{
					_caches[_curIndex]=new _cls();
				}
			}
		}
		public function push(o:ICPoolObject):void
		{
			if(_curIndex==0 || _caches[_curIndex]==null ) 
			{
				CDebugUtil.Instance.throwError("HPoolSystem","push","_caches[_curIndex]","为空!");
				return;
			}
			_curIndex--;
			_caches[_curIndex]=o;
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
				_caches.length=_size;
				initPool();
			}
			if(_caches[index]!=null)
			{
				_curIndex=index;
			}
			else
			{
				_curIndex=index+1;
			}
			o=_caches[_curIndex];
			_caches[_curIndex]=null;
			_curIndex++;
			return o;
		}
		public function clear():void
		{
			if(_caches.length>_minSize)
			{
				
			}
		}
	}
}
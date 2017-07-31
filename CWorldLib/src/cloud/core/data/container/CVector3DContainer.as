package cloud.core.data.container
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import cloud.core.data.CVector;
	import cloud.core.data.pool.ICObjectPool;
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.singleton.CPoolsManager;

	/**
	 * 3D向量数据缓存容器类
	 * @author cloud
	 */
	public class CVector3DContainer extends AbstractDataContainer implements ICPoolObject
	{
		private static var _Pool:ICObjectPool;
		
		private var _isInPool:Boolean;
		
		public function CVector3DContainer()
		{
			initObject();
		}
		override public function add(obj:*):void
		{
			_invalidSize=true;
			if(obj is Array)
			{
				var x:Number=0,y:Number=0,z:Number=0,w:Number=0;
				for(var i:int=0; i<obj.length; i++)
				{
					x=obj[i].x;
					y=obj[i].y;
					if(obj[i] is Vector3D || obj[i] is CVector)
					{
						z=obj[i].z;
						w=obj[i].w;
					}
					else if(!(obj[i] is Point))
					{
						z=obj[i].z;
					}
					_container.push(x);
					_container.push(y);
					_container.push(z);
					_container.push(w);
				}
			}
			else if(obj is AbstractDataContainer)
			{
				var dataContainer:AbstractDataContainer=obj as AbstractDataContainer;
				var datas:Array=[];
				for(i=0;i<dataContainer.size;i++)
				{
					dataContainer.getByIndex(i,datas);
				}
				_container.push.apply(null,datas);
//				_container=_container.concat(datas);
			}
			else
			{
				_container.push(obj.x);
				_container.push(obj.y);
				_container.push(obj.z);
				_container.push(obj.w);
			}
		}
		override public function getByIndex(index:uint,output:*):void
		{
			if(output is Array)
			{
				output.push(_container[index*_dataAttributeLength],_container[index*_dataAttributeLength+1],_container[index*_dataAttributeLength+2],_container[index*_dataAttributeLength+3]);
			}
			else
			{
				output.x=_container[index*_dataAttributeLength];
				output.y=_container[index*_dataAttributeLength+1];
				output.z=_container[index*_dataAttributeLength+2];
				output.w=_container[index*_dataAttributeLength+3];
			}
		}
		override public function updateByIndex(obj:*, index:int):void
		{
			_container[index*_dataAttributeLength]=obj.x;
			_container[index*_dataAttributeLength+1]=obj.y;
			_container[index*_dataAttributeLength+2]=obj.z;
			_container[index*_dataAttributeLength+3]=obj.w;
		}
		public function get isInPool():Boolean
		{
			return _isInPool;
		}
		public function initObject(...params):void
		{
			_container ||=[];
			_dataAttributeLength ||=4;
			_isInPool=false;
		}
		public function dispose():void
		{
			clear();
			_container=null;
		}
		public function back():void
		{
			clear();
			_isInPool=true;
			if(_Pool!=null)
				_Pool.push(this);
		}
		public function clone():ICPoolObject
		{
			var clone:CVector3DContainer=CreateOneInstance();
			clone.add(this);
			return clone;
		}
		/**
		 * 设置是否使用缓冲池 
		 * @param value
		 * 
		 */			
		public static function set IsUsePool(value:Boolean):void
		{
			if(value && _Pool==null)
			{
				CPoolsManager.Instance.registPool(CVector3DContainer,10);
				_Pool=CPoolsManager.Instance.getPool(CVector3DContainer);
			}
			else if(!value && _Pool!=null)
			{
				CPoolsManager.Instance.unRegistPool(CVector3DContainer);
				_Pool=null;
			}
			
		}
		/**
		 * 创建一个实例 
		 * @return CVector
		 * 
		 */		
		public static function CreateOneInstance():CVector3DContainer
		{
			return _Pool==null ? new CVector3DContainer() : _Pool.pop() as CVector3DContainer;
		}
	}
}
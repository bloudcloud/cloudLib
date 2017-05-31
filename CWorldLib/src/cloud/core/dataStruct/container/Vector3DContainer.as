package cloud.core.dataStruct.container
{
	import cloud.core.interfaces.ICPoolObject;
	import cloud.core.singleton.CPoolsManager;

	/**
	 * 3D向量数据缓存容器类
	 * @author cloud
	 */
	public class Vector3DContainer extends AbstractDataContainer implements ICPoolObject
	{
		public function Vector3DContainer(abstractClass:Class)
		{
			initObject(abstractClass);
		}
		override public function add(obj:*):void
		{
			_invalidSize=true;
			if(obj is Array || obj is Vector)
			{
				for(var i:int=0; i<obj.length; i++)
				{
					_container.push(obj[i].x);
					_container.push(obj[i].y);
					_container.push(obj[i].z);
					_container.push(obj[i].w);
				}
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
			output.x=_container[index];
			output.y=_container[index+1];
			output.z=_container[index+2];
			output.w=_container[index+3];
		}
		override public function updateByIndex(obj:*, index:int):void
		{
			_container[index]=obj.x;
			_container[index+1]=obj.y;
			_container[index+2]=obj.z;
			_container[index+3]=obj.w;
		}
		public function initObject(initParam:Object=null):void
		{
			_abstractClass ||=initParam as Class;
			_container ||=[];
			_dataAttributeLength ||=4;
		}
		public function dispose():void
		{
			clear();
			CPoolsManager.instance.getPool(Vector3DContainer).push(this);
		}
	}
}
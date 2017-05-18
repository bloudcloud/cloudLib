package cloud.core.dataStruct.container
{
	/**
	 * 3D向量数据缓存容器类
	 * @author cloud
	 */
	public class Vector3DContainer extends AbstractDataContainer
	{
		public function Vector3DContainer(abstractClass:Class)
		{
			_dataAttributeLength=4;
			super(abstractClass);
		}
		override public function add(obj:*):void
		{
			_invalidSize=true;
			_container.push(obj.x);
			_container.push(obj.y);
			_container.push(obj.z);
			_container.push(obj.w);
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
	}
}
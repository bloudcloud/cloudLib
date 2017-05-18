package cloud.core.dataStruct
{
	import flash.geom.Vector3D;
	
	/**
	 * 3D向量
	 * @author cloud
	 */
	public class CVector3D extends Vector3D
	{
		/**
		 * 获取3D坐标 
		 * @return Vector3D
		 * 
		 */		
		public function get position():Vector3D
		{
			return this;
		}
		/**
		 * 设置成3D坐标 
		 * @param value
		 * 
		 */		
		public function set position(value:Vector3D):void
		{
			this.setTo(value.x,value.y,value.z);
		}
		/**
		 * 获取3D方向 
		 * @return 
		 * 
		 */		
		public function get direction():Vector3D
		{
			return this;
		}
		/**
		 * 设置成3D方向 
		 * @param value
		 * 
		 */		
		public function set direction(value:Vector3D):void
		{
			this.setTo(value.x,value.y,value.z);
			if(value.lengthSquared!=1)
				this.normalize();
		}
		
		public function CVector3D(x:Number=0.0, y:Number=0.0, z:Number=0.0, w:Number=0.0)
		{
			super(x, y, z, w);
		}
	}
}
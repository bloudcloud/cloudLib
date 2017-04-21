package cloud.core.interfaces
{
	/**
	 * 数据模块接口
	 * @author cloud
	 */
	public interface ICDataModule
	{
		/**
		 * 添加3D对象数据 
		 * @param uniqueID
		 * @param type
		 * @param parentID
		 * @param length
		 * @param width
		 * @param height
		 * @param x
		 * @param y
		 * @param z
		 * @param rotation
		 * 
		 */		
		function addObject3DData(uniqueID:String,type:uint,parentID:String,length:Number,width:Number,height:Number,x:Number,y:Number,z:Number,rotation:Number):void;
	}
}
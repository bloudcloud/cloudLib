package extension.cloud.datas
{
	import flash.geom.Matrix3D;

	/**
	 * 模型表面数据结构
	 * @author	cloud
	 * @date	2018-4-25
	 */
	public class CMeshSurfaceData
	{
		/**
		 * 顶点数组 
		 */		
		public var vertices:Array;

		public var axisMatrix:Matrix3D;
		
		public function CMeshSurfaceData()
		{
		}
	}
}
package extension.cloud.datas
{
	import flash.geom.Vector3D;

	/**
	 *	套线类
	 * @author	cloud
	 * @date	2018-5-7
	 */
	public class CCoverLineData
	{
		/**
		 * 拥有者ID 
		 */		
		public var ownerID:String;
		/**
		 * 套线顶点集合 
		 */		
		public var vertices:Vector.<Number>;
		/**
		 * 套线放样路径 
		 */		
		public var paths:Vector.<Number>;
		/**
		 * 型材编号 
		 */		
		public var materialUrl:String;
		/**
		 * 方向向量
		 */		
		public var direction:Vector3D;
		/**
		 * 法线向量 
		 */		
		public var normal:Vector3D;
		/**
		 * 位置 
		 */		
		public var position:Vector3D;
		/**
		 * 是否闭合 
		 */		
		public var isClosure:Boolean;
//		/**
//		 * 世界矩阵 
//		 */		
//		public var worldMatrix:Matrix3D;
		
		public function CCoverLineData()
		{
		}
	}
}
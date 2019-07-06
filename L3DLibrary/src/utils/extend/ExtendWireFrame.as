package utils.extend
{
	import alternativa.engine3d.objects.WireFrame;
	
	import flash.geom.Vector3D;

	public class ExtendWireFrame extends WireFrame
	{
		/**
		 * 对alternative3D的WireFrame进行扩展
		 */		
		public function ExtendWireFrame()
		{
			super();
		}
		
		/**
		 * 以父容器原点为中心画辅助参考线，平行于xy平面
		 * @param lines，线条数
		 * @param interval，线条间隔距离
		 * @return 
		 * 
		 */		
		static public function createReferenceLines(lines:Number, interval:Number):WireFrame
		{
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			
			var i:Number;
			for(i=-lines/2; i<=lines/2; i++)
			{
				points.push(new Vector3D(-lines/2*interval, i*interval, -10));
				points.push(new Vector3D(lines/2*interval, i*interval, -10));
				
				points.push(new Vector3D(i*interval, -lines/2*interval, -10));
				points.push(new Vector3D(i*interval, lines/2*interval, -10));
			}
			
			return WireFrame.createLinesList(points, 0xF0F0F0FF, 1, 3);
		}
	}
}
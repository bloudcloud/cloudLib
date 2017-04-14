package cloud.core.interfaces
{
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.Transform3D;

	/**
	 *  3D对象数据
	 * @author cloud
	 */
	public interface ICObject3DData extends ICData
	{
		/**
		 * 获取父数据对象的唯一ID
		 * @return String
		 * 
		 */		
		function get parentID():String;
		/**
		 * 设置父数据对象的唯一ID
		 * @param value
		 * 
		 */		
		function set parentID(value:String):void;
		/**
		 * 获取长度 
		 * @return 
		 * 
		 */		
		function get length():Number;
		/**
		 * 设置长度 
		 * @param value
		 * 
		 */		
		function set length(value:Number):void;
		/**
		 * 获取宽度 
		 * @return Number
		 * 
		 */		
		function get width():Number;
		/**
		 * 设置宽度 
		 * @param value
		 * 
		 */		
		function set width(value:Number):void;
		/**
		 *  获取高度
		 * @return Number
		 * 
		 */
		function get height():Number;
		/**
		 * 设置高度 
		 * @param value
		 * 
		 */		
		function set height(value:Number):void;
		/**
		 * 获取方向 
		 * @return Vector3D
		 * 
		 */		
		function get direction():Vector3D;
		/**
		 * 设置方向 
		 * @param value
		 * 
		 */		
		function set direction(value:Vector3D):void;
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get z():Number;
		function set z(value:Number):void;
		/**
		 * 获取旋转角度值 
		 * @return int
		 * 
		 */		
		function get rotation():int;
		/**
		 * 设置旋转角度值 
		 * @param value
		 * 
		 */		
		function set rotation(value:int):void;
		/**
		 * 获取位置 
		 * @return Vector3D
		 * 
		 */
		function get position():Vector3D;
		/**
		 * 获取转换 
		 * @return Transform3D
		 * 
		 */		
		function get transform():Transform3D;
		/**
		 * 获取逆转换 
		 * @return Transform3D
		 * 
		 */		
		function get inverseTransform():Transform3D;
		/**
		 * 是否发生转换
		 * @return Boolean
		 * 
		 */		
		function get invalidPosition():Boolean;
	}
}
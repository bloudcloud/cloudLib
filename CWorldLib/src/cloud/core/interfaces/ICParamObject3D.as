package cloud.core.interfaces
{
	/**
	 * 参数化数据接口
	 * @author cloud
	 */
	public interface ICParamObject3D extends ICObject3D
	{
		function get topOffset():Number;
		function set topOffset(value:Number):void;
		function get bottomOffset():Number;
		function set bottomOffset(value:Number):void;
		function get leftOffset():Number;
		function set leftOffset(value:Number):void;
		function get rightOffset():Number;
		function set rightOffset(value:Number):void;
	}
}
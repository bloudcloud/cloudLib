package cloud.core.interfaces
{
	/**
	 * 单元件数据接口
	 * @author cloud
	 */
	public interface ICUnitObject3D extends ICObject3D
	{
		function get leftSpacing():Number;
		function set leftSpacing(value:Number):void;
		function get rightSpacing():Number;
		function set rightSpacing(value:Number):void;
		function get topSpacing():Number;
		function set topSpacing(value:Number):void;
		function get bottomSpacing():Number;
		function set bottomSpacing(value:Number):void;
	}
}
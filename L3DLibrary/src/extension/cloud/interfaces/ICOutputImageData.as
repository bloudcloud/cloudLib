package extension.cloud.interfaces
{
	import flash.display.BitmapData;

	/**
	 * 出图数据接口
	 * @author	cloud
	 * @date	2018-5-2
	 */
	public interface ICOutputImageData
	{
		function get type():uint;
		function get code():String;
		function get preview():BitmapData;
		function get svg():XML;
		function get point3Ds():Vector.<Number>;
		function get indices():Vector.<int>;
		function get uvs():Vector.<Number>;
		function get children():Vector.<ICOutputImageData>;
	}
}
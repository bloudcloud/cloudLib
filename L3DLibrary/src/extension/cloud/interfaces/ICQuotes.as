package extension.cloud.interfaces
{
	import flash.utils.ByteArray;
	
	import cloud.core.datas.base.CVector;

	/**
	 * 报价数据接口 
	 * @author cloud
	 * 
	 */
	public interface ICQuotes
	{
		function get qType():uint;
		function set qType(value:uint):void;
		function get qName():String;
		function set qName(value:String):void;
		function get qLength():Number;
		function set qLength(value:Number):void;
		function get qWidth():Number;
		function set qWidth(value:Number):void;
		function get qHeight():Number;
		function set qHeight(value:Number):void;
		function get price():Number;
		function set price(value:Number):void;
		function get size():CVector;
		function set size(value:CVector):void;
		function get previewBuffer():ByteArray;
		function set previewBuffer(value:ByteArray):void;
	}
}
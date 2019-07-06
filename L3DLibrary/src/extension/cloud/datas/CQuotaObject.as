package extension.cloud.datas
{
	import flash.utils.ByteArray;

	public class CQuotaObject
	{
		/**
		 * 唯一Code 
		 */		
		public var Code:String;
		/**
		 * 产品类型（中文） 
		 */		
		public var Type:String;
		/**
		 * 产品名称 
		 */		
		public var Name:String;
		/**
		 * 产品长度 
		 */		
		public var Length:Number;
		/**
		 * 产品高度 
		 */		
		public var Height:Number;
		/**
		 * 产品厚度 
		 */		
		public var Width:Number;
		/**
		 * 产品面积 
		 */		
		public var Area:Number;
		/**
		 * 产品图片 
		 */		
		public var Preview:ByteArray;
		/**
		 * 产品单价 
		 */		
		public var Price:Number;
		/**
		 * 产品个数 
		 */		
		public var Piece:Number;
		/**
		 * 产品单位（中文） 
		 */		
		public var unitString:String;
		/**
		 * 产品备注 
		 */		
		public var remark:String;

		public var totalLength:Number;
		public var totalHeight:Number;
		public var isXDirection:Boolean;
		public var totalArea:Number;
		
		public function CQuotaObject()
		{
			totalArea=totalLength=totalHeight=0;
			Length=Height=Width=Area=Price=Piece=0;
		}
	}
}
package prefabs.components
{
	import flash.utils.ByteArray;
	
	import happyECS.ecs.component.BaseHComponent;
	
	import prefabs.TypeDict;
	
	/**
	 * 商品组件
	 * @author cloud
	 * @2018-3-12
	 */
	public class CommodityComponent extends BaseHComponent
	{
		public var code:String;

		public var classCode:String;
		public var className:String;

		public var price:Number;
		public var cost:Number;
		public var catalog:int;
		public var spec:String;
		public var remark:String;
		public var description:String;
		
		public var previewBuffer:ByteArray;
		public var offGround:Number;
		
		public var url:String;
		public var combo:String;
		public var brand:String;
		public var style:String;
		public var series:String;
		public var subSeries:String;
		public var linkedDataUrl:String;
		public var family:String;
		
		public var isPolyMode:Boolean;
		public var offBoard:Number;
		public var orgCode:String;
		public var orgName:String;
		public var linkVRDataUrl:String;
		public var parentCode:String;
		public var linkCDDataUrl:String;
		
		public function CommodityComponent()
		{
			super(TypeDict.COMMODITY_COMPONENT_CLSNAME);
		}
	}
}
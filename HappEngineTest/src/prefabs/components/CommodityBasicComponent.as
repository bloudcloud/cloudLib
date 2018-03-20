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
	public class CommodityBasicComponent extends BaseHComponent
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
		
		public function CommodityBasicComponent()
		{
			super(TypeDict.COMMODITY_COMPONENT_CLSNAME);
		}
		
		override protected function doUpdateComponent():void
		{
			code=_resource.code;
			classCode=_resource.classCode;
			className=_resource.className;
			price=_resource.price;
			cost=_resource.cost;
			catalog=_resource.catalog;
			spec=_resource.spec;
			remark=_resource.remark;
			description=_resource.description;
			offGround=_resource.offGround;
			url=_resource.url;
			combo=_resource.combo;
			brand=_resource.brand;
			style=_resource.style;
			series=_resource.series;
			subSeries=_resource.subSeries;
			linkedDataUrl=_resource.linkedDataUrl;
			family=_resource.family;
			isPolyMode=_resource.isPolyMode;
			offBoard=_resource.offBoard;
			orgCode=_resource.orgCode;
			orgName=_resource.orgName;
			linkVRDataUrl=_resource.linkVRDataUrl;
			parentCode=_resource.parentCode;
			linkCDDataUrl=_resource.linkCDDataUrl;
		}
	}
}
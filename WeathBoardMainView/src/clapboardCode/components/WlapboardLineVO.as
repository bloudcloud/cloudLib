package clapboardCode.components
{
	import wallDecorationModule.model.vo.CClapboardLineVO;
	
	public class WlapboardLineVO extends CClapboardLineVO
	{
		public var positionY :Number ;
		public function WlapboardLineVO(clsType:String)
		{
			super(clsType);
		}
		override protected function doDeserializeXML(xml:XML):void
		{
			super.doDeserializeXML(xml);
			if(Number(xml.@positionY) != 0)
				positionY =xml.@positionY;
		}
	}
}
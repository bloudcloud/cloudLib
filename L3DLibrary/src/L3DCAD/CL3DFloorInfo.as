package L3DCAD
{
	import cloud.core.utils.CUtil;
	
	import extension.cloud.dict.CL3DConstDict;

	/**
	 * 地面信息类
	 * @author	cloud
	 * @date	2018-12-28
	 */
	public class CL3DFloorInfo
	{
		public var uid:String;
		public var roundPoint3Ds:Vector.<Number>;
		public var innerPoint3Ds:Vector.<Number>;
		public var outterPoint3Ds:Vector.<Number>;
		
		public function CL3DFloorInfo()
		{
			uid=CL3DConstDict.TYPE_FLOOR+CL3DConstDict.STRING_LINKSYMBOL+CUtil.Instance.createUID();
			roundPoint3Ds=new Vector.<Number>();
			innerPoint3Ds=new Vector.<Number>();
			outterPoint3Ds=new Vector.<Number>();
		}
	}
}
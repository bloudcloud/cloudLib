package extension.wl.toolpackage
{
	public class ToolEventData
	{
		public var type:int = 1;//弹条id
		public var revisionLayer:int = 1;//修改弹条对应数据层级：1为本身；2为二级；以此类推
		public var currentLayer:int = 1;//弹条层级:1为一级；2为二级；以此类推
		public var info:Object = null;//事件数据
		public function ToolEventData()
		{
		}
	}
}
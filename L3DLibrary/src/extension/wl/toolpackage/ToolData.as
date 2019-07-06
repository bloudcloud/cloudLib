package extension.wl.toolpackage
{
	import extension.wl.models.LabelModel;

	public class ToolData
	{
		public var popUpBarType:String = ""; //弹条类型
		public var popUpBarData:Vector.<LabelModel> = null; //一级弹条数据
		public var popUpBarChildData:Vector.<LabelModel> = null; //二级弹条数据
		
		public function ToolData()
		{
		}
	}
}
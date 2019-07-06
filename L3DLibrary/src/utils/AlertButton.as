package utils
{
	import spark.components.Button;
	/**
	 * 按钮切换视图显示状态
	 * @author lx
	 */	
	public class AlertButton extends Button
	{
		[Bindable]
		public var sourceOver:String;
		[Bindable]
		public var sourceOut:String;
		
		public function AlertButton()
		{
			super.tabChildren = false;
			super.tabEnabled = false;
			super.tabFocusEnabled = false;
			tabEnabled = false;
			tabChildren = false;
			tabFocusEnabled = false;
		}
	}
}
package extension.cloud.mvcs.base.view
{
	import mx.core.UIComponent;
	
	import cloud.core.utils.CUtil;
	
	/**
	 * 基础界面组件
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CBaseL3DViewComponent extends UIComponent
	{
		private var _className:String;
		
		protected var _id:String;
		
		public function CBaseL3DViewComponent(className:String)
		{
			super();
			_id=CUtil.Instance.createUID();
			_className=className;
			
			doInitilization();
		}
		
		protected function doInitilization():void
		{
			
		}
		
		protected function doDispose():void
		{
			
		}
		
		internal function dispose():void
		{
			doDispose();
		}
	}
}
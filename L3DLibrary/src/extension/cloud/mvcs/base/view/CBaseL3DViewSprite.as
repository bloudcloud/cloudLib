package extension.cloud.mvcs.base.view
{
	import flash.display.Sprite;
	
	import cloud.core.utils.CUtil;
	
	/**
	 * 基础业务界面类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CBaseL3DViewSprite extends Sprite
	{
		private var _className:String;
		protected var _id:String;

		public function get id():String
		{
			return _id;
		}

		public function CBaseL3DViewSprite(className:String="CBaseL3DViewSprite")
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
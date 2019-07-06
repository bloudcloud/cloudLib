package extension.lrj.datas
{
	/**
	 * 用于功能模块弹出提示TipsToolView时传递的数据 
	 * @author Debugger
	 * 
	 */	
	public class TipsToolData
	{
		/**
		 * 提示內容 
		 */		
		public var tips:String = ""; 
		
		/**
		 * 提示类型  0:确定 取消 1:右上角x
		 */		
		public var viewType:int = 0;
		
		/**
		 * 点击取消或关闭(右上角X)回调函数
		 */		
		public var cancelCallBack:Function = null; 
		
		/**
		 * 点击确定时回调函数 
		 */		
		public var confirmCallBack:Function = null;
		
		/**
		 * 是否自动关闭 
		 */		
		public var isTimer:Boolean = false;
		
		/**
		 * tipsToolView携带数据 
		 */		
		public var info:Object = null;
		
		public function TipsToolData()
		{
		}
	}
}
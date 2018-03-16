package resources.status
{
	import resources.manager.StatusMGR;
	import resources.status.consts.StatusConst;

	public class RenderMGStatus implements IStatus
	{
		private var _isRunning:Boolean;
		private var statusMGR:StatusMGR;
		public function RenderMGStatus(statusMGR:StatusMGR)
		{
			this.statusMGR = statusMGR;
		}
		
		public function setup():void
		{
			_isRunning = true;
		}
		
		public function reset():void
		{
			_isRunning = false;
		}
		
		public function get name():String
		{
			return StatusConst.Render;
		}
		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
	}
}
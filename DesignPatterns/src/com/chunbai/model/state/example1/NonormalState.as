package com.chunbai.model.state.example1
{
	
	/**
	 * 状态不正常
	 * */
	public class NonormalState implements IState
	{
		public function NonormalState()
		{
			
		}
		
		public function shot():void
		{
			trace("今天你投篮十中一");
		}
		
	}
}
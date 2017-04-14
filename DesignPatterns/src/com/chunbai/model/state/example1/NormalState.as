package com.chunbai.model.state.example1
{
	
	/**
	 * 状态正常
	 * */
	public class NormalState implements IState
	{
		public function NormalState()
		{
			
		}
		
		public function shot():void
		{
			trace("今天你投篮十中五");
		}
		
	}
}
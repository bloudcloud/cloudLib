package com.chunbai.model.state.example1
{
	
	/**
	 * 状态超常
	 * */
	public class SuperState implements IState
	{
		public function SuperState()
		{
			
		}
		
		public function shot():void
		{
			trace("今天你投篮十中十");
		}
		
	}
}